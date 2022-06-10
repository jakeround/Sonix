//
//  LoginViewModel.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//

import SwiftUI
import Combine

typealias PutioKitUser = AccountService.Model.Info

final class LoginViewModel: ObservableObject {
    
    private var bag = Set<AnyCancellable>()
    
    var putioKitClient: ApiClientModel!
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var error: Error?
    @Published var isLoading: Bool = false
    @Published var loginButtonDisabled: Bool = false
        
    let userManager: UserManager = .shared
        
    init() {
        putioKitClient = ApiClientModel(id: Global.clientID, secret: Global.clientSecret, name: "")
    }
    
    deinit {
        debugPrint("Deint: \(String(describing: self))")
    }
    
    private func setupObservers() {
        Publishers.CombineLatest($username, $password).sink { [weak self] eml, pwd in
            guard let self = self else { return }
            self.loginButtonDisabled = eml.isEmpty || pwd.isEmpty || pwd.count < 6
        }.store(in: &bag)
    }
    
    func performValidation() -> Bool {
        if self.username.isEmpty || self.password.isEmpty {
            self.error = ValidationError.missingField
            return false
        }
        return true
    }
    
    func startAuthenticationFlow() {
        guard performValidation() else { return }
        
        self.isLoading = true
        
        let authService = AuthenticationService.init(clientModel: putioKitClient, networkHandler: URLSession.shared)
        authService.authenticate(username: self.username, password: self.password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let token):
                    self.fetchAccountInfo(token: token.token)
                case .failure(let error):
                    self.errorHandling(error: error)
                }
            }
        }?.store(in: &bag)
        
    }
    
    
    func fetchAccountInfo(token: String) {
        
        let credential = Credential(accessToken: token)
        let profileService = AccountService.init(clientModel: putioKitClient, networkHandler: URLSession.shared, credentialsStore: credential)
        
        self.isLoading = true

        profileService.fetchInfo { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let user):
                    self.userManager.saveData(token: token, user: user, triggerLogin: true)
                case .failure(let error):
                    self.errorHandling(error: error)
                }
            }
        }?.store(in: &bag)

    }
    
    private func errorHandling(error: Error) {
        if let putioError = error as? PutIOKitError {
            self.error = putioError
        } else if let errorModel = error as? ErrorModel {
            self.error = PutIOKitError.invalidResponse(errorModel.message)
        } else {
            self.error = error
        }
    }
    
}
