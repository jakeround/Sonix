//
//  UserManager.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//
   

import Foundation
import Combine

class UserManager {
    
    static let shared = UserManager()
    var bag = Set<AnyCancellable>()
    
    var token: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    var currentUser: CurrentValueSubject<PutioKitUser?, Never> = CurrentValueSubject(nil)
    var isLoggedIn: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    private init() {}
    
    func saveData(token: String? = nil, user: PutioKitUser? = nil, triggerLogin: Bool = false) {
        if let token = token, !token.isEmpty {
            UserDefaults.standard.set(token, forKey: UserDefaultsKey.token)
            self.token.send(token)
        }

        if let user = user {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                UserDefaults.standard.set(encoded, forKey: UserDefaultsKey.user)
                self.currentUser.send(user)
                if triggerLogin { self.isLoggedIn.send(true) }
            }
        }

        UserDefaults.standard.synchronize()
    }
    
    func readUserData(){
        token.send(UserDefaults.standard.string(forKey: UserDefaultsKey.token))
        if let data = UserDefaults.standard.object(forKey: UserDefaultsKey.user) as? Data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(PutioKitUser.self, from: data) {
                self.currentUser.send(user)
                self.isLoggedIn.send(true)
            }
        }
    }
    
    func removeUserData() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.token)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.user)
        UserDefaults.standard.synchronize()
        self.isLoggedIn.send(false)
    }
    
    func getCredential() -> Credential {
        return Credential(accessToken: self.token.value)
    }
}

