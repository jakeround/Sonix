//
//  LaunchScreen.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//


import SwiftUI

struct LaunchScreen: View {
    let userManager = UserManager.shared
    
    enum AppState {
        case unauthenticated
        case authenticated
    }    
    
    @State var appState: AppState = .authenticated
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                //Image("icon_logo")
                //    .frame(width: 326, height: 78)
                 //   .onAppear {
                 //   }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(AppColor.BackGround.lightBackground))
            
            switch appState {
            case .unauthenticated:
                LoginScreen()
            case .authenticated:
                TabScreen()
            }
            
        }
        .onReceive(userManager.isLoggedIn.eraseToAnyPublisher()) { flag in
            self.appState = flag ? .authenticated : .unauthenticated
        }
        
    }
    
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
