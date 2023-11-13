//
//  SettingsScreen.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//

   

import SwiftUI

struct SettingsScreen: View {
    
    enum SettingsType: String, CaseIterable {
        case logout = "Logout"
    }
    
    @State private var apiUrl: String = UserDefaults.standard.string(forKey: "https://www.yts.mx/api/v2") ?? "https://yts.mx/api/v2/"
    @EnvironmentObject var networkManager: NetworkManager
    
    
    let userManager: UserManager = .shared
        
    @StateObject var viewModel = SettingsViewModel()
    @State var showLogoutAlert: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Form {
                        TextField("API Base URL", text: $apiUrl)
                        Button("Save") {
                            UserDefaults.standard.set(self.apiUrl, forKey: "https://www.yts.mx/api/v2")
                            networkManager.updateApiBaseURL(to: self.apiUrl)
                        }
                    }.frame(height:300)
                    
                    
                    VStack {
                        listingView
                            .alert("", isPresented: $showLogoutAlert) {
                                Button(Constants.cancel, role: .cancel) { }
                                Button(Constants.yes, role: .none) {
                                    self.perfromLogout()
                                }
                            } message: {
                                Text(Constants.logoutMessage)
                            }
                            .frame(minWidth: 350, maxWidth: 700)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(Constants.title)
                    .errorAlert(error: $viewModel.error)
                }
            }
        }
        .navigationViewStyle(.stack)

    }
    
    private var listingView: some View {
        
        ScrollView {
            
           
            
        
            
            ForEach(0 ..< SettingsType.allCases.count) { index in
                
                let action = SettingsType.allCases[index]
                ListCell(title: action.rawValue)
                    .onTapGesture {
                        switch action {
                        case .logout:
                            self.showLogoutAlert = true
                        }
                    }
                
            }
            
            
            
            
        }
        .background(.clear)
        
    }
    
    struct ListCell: View {
        let title: String
        
        var body: some View {
            
            HStack {
                
                Text(title)
                    .padding()
                    .foregroundColor(
                        Color(AppColor.Components.SettingList.text)
                    )
                
                Spacer()
            }
            .background(
                Color(AppColor.BackGround.cardColour).cornerRadius(10)
            )
        }
    }

}

extension SettingsScreen {
    
    func perfromLogout() {
        viewModel.removeData(finished: nil)
    }
}

extension SettingsScreen {
    struct Constants {
        static let title = "Settings"
        static let logoutMessage = "Are you sure you want to logout?"
        static let cancel = "Cancel"
        static let yes = "YES"
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}





