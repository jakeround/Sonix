//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.

import SwiftUI
import Combine

typealias PutioKitFile = FilesService.Model.File

struct PutioKitSearchFile: Identifiable {
    let file: PutioKitFile
    let id: Int
    var isLoading: Bool = false
    var shareURL: URL? = nil
}

final class SearchViewModel: ObservableObject {
    
    private var bag = Set<AnyCancellable>()
        
    var putioKitClient: ApiClientModel!
    
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var isUploading: Bool = false
    
    @Published var searchText: String = ""
    @Published var datasource: [PutioKitSearchFile] = []
    
    @Published var showVideoPlayer: Bool = false
    
    let userManager: UserManager = .shared
    
    let size: Int = 20
    var cursor: String = ""
    var hasMore: Bool = true
    
    let fileType: String = "mp4" //+ "mkv" // supports MKV need to figure out how to allow both
    
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
    
    func trasferData() {
        guard !searchText.isEmpty else { return }
        
        isUploading = true
                
        let transferService = TransfersService(clientModel: putioKitClient, networkHandler: URLSession.shared, credentialsStore: userManager.getCredential())
        let params = TransfersService.Model.AddParameters(url: searchText, parentId: 0, callbackURL: nil)
        
        transferService.addTransfer(parameters: params) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isUploading = false
                self.searchText = ""
                switch result {
                case .success: break
                    //self.refreshData()
                case .failure(let error):
                    self.errorHandling(error: error)
                }
            }
        }?.store(in: &bag)
        
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
    
}

