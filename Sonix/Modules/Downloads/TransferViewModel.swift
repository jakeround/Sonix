//
//  SearchViewModel.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//

import SwiftUI
import Combine

typealias PutioKitFile = FilesService.Model.File

struct PutioKitSearchFile: Identifiable {
    let file: PutioKitFile
    let id: Int
    var isLoading: Bool = false
    var shareURL: URL? = nil
}

final class TransferViewModel: ObservableObject {
    
    private var bag = Set<AnyCancellable>()
        
    var putioKitClient: ApiClientModel!
    
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var isUploading: Bool = false
    
    @Published var datasource: [PutioKitSearchFile] = []
    
    @Published var showVideoPlayer: Bool = false
    
    @Published var progress: CGFloat = 0.0
    
    let userManager: UserManager = .shared
    
    let size: Int = 20
    var cursor: String = ""
    var hasMore: Bool = true
    
    let fileType: String = "mkv" //+ "mkv" // supports MKV need to figure out how to allow both
    
    
    init() {
        putioKitClient = ApiClientModel(id: Global.clientID, secret: Global.clientSecret, name: "")
    }
    
    deinit {
       debugPrint("Deint: \(String(describing: self))")
    }
    
    func fetchData()  {
        guard hasMore else { return }
        
        let fileService = FilesService.Searching(clientModel: putioKitClient, networkHandler: URLSession.shared, credentialsStore: userManager.getCredential())
        
        if cursor.isEmpty {
            
            isLoading = true
            
            let searchParams = FilesService.Model.SearchParameters(query: fileType, perPage: size)
            fileService.searchFiles(parameters: searchParams) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    
                    self.isLoading = false
                    
                    switch result {
                    case .success(let list):
                        self.cursor = list.cursor.safeUnwrapped
                        self.datasource = list.files.map { PutioKitSearchFile(file: $0, id: $0.id)}
                    case .failure(let error):
                        self.errorHandling(error: error)
                    }
                    
                }
            }?.store(in: &bag)
        } else {
            
            let params = FilesService.Model.NextPageParameters(cursor: cursor, perPage: size)
            fileService.searchNextPage(parameters: params) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let list):
                        self.hasMore = !list.cursor.safeUnwrapped.isEmpty
                        self.cursor = list.cursor.safeUnwrapped
                        self.datasource.append(contentsOf: list.files.map { PutioKitSearchFile(file: $0, id: $0.id)} )
                    case .failure(let error):
                        self.errorHandling(error: error)
                    }
                }
            }?.store(in: &bag)
        }
        
    }
    
    func refreshData()  {
        datasource = []
        hasMore = true
        cursor = ""
        fetchData()
    }

    
    func getStreamURL(file: PutioKitFile) -> URL? {
        return file.getStreamURL(token: userManager.token.value.safeUnwrapped)
    }
    
    func generateShareURL(file: PutioKitFile, finished: ((URL) -> ())? = nil) {
        if let datasourceIndex = self.datasource.firstIndex(where: { indexedFile in
            indexedFile.id == file.id
        }) {
            let newFile = PutioKitSearchFile(file: file, id: file.id, isLoading: true)
            datasource[datasourceIndex] = newFile
            
            let shareService = SharesService(clientModel: putioKitClient, networkHandler: URLSession.shared, credentialsStore: userManager.getCredential())
            shareService.sharePublically(fileId: file.id, username: "", completion: { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let value):
                        let sharedFile = PutioKitSearchFile(file: file, id: file.id, shareURL: value)
                        self.datasource[datasourceIndex] = sharedFile
                        finished?(value)
                    case .failure(let error):
                        self.errorHandling(error: error)
                    }
                }
            })?.store(in: &bag)
        }
    }
    
    private func errorHandling(error: Error) {
        if let putioError = error as? PutIOKitError {
            switch putioError {
            case .unauthorised:
                self.userManager.removeUserData()
            default:
                self.error = putioError
            }
        } else if let errorModel = error as? ErrorModel {
            if errorModel.code == 401 {
                self.userManager.removeUserData()
            } else {
                self.error = PutIOKitError.invalidResponse(errorModel.message)
            }
        } else {
            self.error = error
        }
    }
    
    
    var timer: Timer?
    var transferId: Int?
    var transferCompletion: DownloadURLCompletion?
    var progressCompletion: DownloadProgressCompletion?
}

public typealias DownloadURLCompletion = (Result<URL, Error>) -> Void
public typealias DownloadProgressCompletion = (CGFloat) -> Void

extension TransferViewModel {
    
    func downloadMovie(hash: String, completion: @escaping (URL) -> Void) {

        progress = 0
        isUploading = true
        
        transferData(hash: hash, completion: { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isUploading = false
                
                switch result {
                case .success(let url):
                    completion(url)
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.errorHandling(error: error)
                    }
                }
            }
        }, progress: { [weak self] progress in
            guard let self = self else { return }
            self.progress = progress
        })
    }
    
    private func transferData(hash: String, completion: DownloadURLCompletion? = nil, progress: DownloadProgressCompletion? = nil) {
        
        self.progressCompletion = progress
        self.transferCompletion = completion
                
        let transferService = TransfersService(clientModel: putioKitClient, networkHandler: URLSession.shared, credentialsStore: userManager.getCredential())
        let params = TransfersService.Model.AddParameters(url: hash, parentId: 0, callbackURL: nil)
        
        transferService.addTransfer(parameters: params) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.progressCompletion?(0.1)
                switch result {
                case .success(let value):
                    self.addTimer(transferId: value.id)
                case .failure(let error):
                    self.transferCompletion?(.failure(error))
                }
            }
        }?.store(in: &bag)
        
    }
    
    @objc private func getTransferDetail() {
        
        guard let id = transferId else { return }
                        
        let transferService = TransfersService(clientModel: putioKitClient, networkHandler: URLSession.shared, credentialsStore: userManager.getCredential())
        
        transferService.details(for: id, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.progressCompletion?(self.progress + 0.1)
                switch result {
                case .success(let value):
                    if case .completed = value.status, let fileID = value.fileId {
                        self.removeTimer()
                        self.getFiles(parentId: fileID)
                    }
                case .failure(let error):
                    self.transferCompletion?(.failure(error))
                }
            }
        })?.store(in: &bag)
    }
    
    func getFiles(parentId: Int) {
        let filesService = FilesService.Listing(clientModel: putioKitClient, networkHandler: URLSession.shared, credentialsStore: userManager.getCredential())
        
        let params = FilesService.Model.ListParameters(parentId: parentId)
        
        filesService.fetchFiles(parameters: params) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.progressCompletion?(1.0)
                switch result {
                case .success(let value):
                    if let file = value.files.first(where: { file in
                        file.type == .video
                    }), let url = file.getStreamURL(token: self.userManager.token.value.safeUnwrapped) {
                        self.transferCompletion?(.success(url))
                    }
                case .failure(let error):
                    self.transferCompletion?(.failure(error))
                }
            }
        }?.store(in: &bag)
    }
    
    private func addTimer(transferId: Int) {
        self.transferId = transferId
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getTransferDetail), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    private func removeTimer() {
        timer?.invalidate()
    }
    
}

