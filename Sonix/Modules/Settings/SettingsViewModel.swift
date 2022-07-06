//
//  SettingsViewModel.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//

   

import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
        
    private var bag = Set<AnyCancellable>()
    
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    let userManager: UserManager = .shared
        
    init() {}
    
    deinit {
        debugPrint("Deint: \(String(describing: self))")
    }
    
    func removeData(finished: (() -> Void)? = nil)  {
        isLoading = true
        userManager.removeUserData()
        
        isLoading = false
    }
    
    func userName1() {
        print("test")
        
    }

}
