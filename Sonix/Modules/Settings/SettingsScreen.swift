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
    
    let userManager: UserManager = .shared
        
    @StateObject var viewModel = SettingsViewModel()
    @State var showLogoutAlert: Bool = false

    var body: some View {
        NavigationView {
            
         
    

            
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
            .background(Color(AppColor.BackGround.darkBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.title)
            .errorAlert(error: $viewModel.error)
            
        }
        .navigationViewStyle(.stack)

    }
    
    private var listingView: some View {
        
        ScrollView {
            
            
            HStack {
                Text("Sonix allows you to browse movies and stream via Put.io")
                    .multilineTextAlignment(.leading)
            }
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .topLeading
                )
            .padding()
            .background(Color(AppColor.BackGround.cardColour))
            .cornerRadius(10)
            
            
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

