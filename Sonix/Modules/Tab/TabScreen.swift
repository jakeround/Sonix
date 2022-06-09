//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

import SwiftUI

struct TabScreen: View {
    
    var body: some View {
        
        TabView {
            YTS()
                .tabItem {
                    Label("Movies", systemImage: "filemenu.and.selection")
                }
            Dashboard()
                .tabItem {
                    Label("Download", systemImage: "arrow.down.circle")
                }
            //ChillInstitute(url: URL(string: "https://chill.institute/")!)
                //.tabItem {
                  //  Image("icon_upload")
                   //     .renderingMode(.template)
                    
                  // Text(Constants.ChillInstitute)
                //}
            SettingsScreen()
                .tabItem {
                    Image("icon_settings")
                        .renderingMode(.template)
                    
                    Text(Constants.settings)
                }
        }
        .accentColor(Color(AppColor.Components.TabBar.tint))
        
    }
    
}

extension TabScreen {
    struct Constants {
        static let dashboard = "Dashboard"
        static let files = "Files"
        static let settings = "Settings"
        static let ChillInstitute = "Download"
    }
}

struct TabScreen_Previews: PreviewProvider {
    static var previews: some View {
        TabScreen()
    }
}
