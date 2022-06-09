//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.


import SwiftUI

struct LoginScreen: View {
    
    
    @State private var showingSheet = false
    
    
    
    var body: some View {
        
        ZStack {
            
        
                
                VStack() {
                   
                   
                    
                    Spacer()
                    Text("Sonix")
                        .font(.system(size: 42, weight: .bold))
                    Spacer()
                    
                    
                    Button(action: { showingSheet.toggle() }) {
                        Text("Login")
                            .frame(width: 390, height: 56)
                            .font(.system(size: 18, weight: .bold, design: .default))
                           .foregroundColor(.white)
                           .contentShape(Rectangle()) // Add this line
                    }
                    .sheet(isPresented: $showingSheet) {
                        SheetView()
                    }
                    
                    .background(Color.primary)
                    .cornerRadius(13)
                    .buttonStyle(PlainButtonStyle())
                    
                    

                            
                            

                    
                }
                .padding()
                
            
            
        }
        .padding()
        .navigationBarHidden(true)
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(AppColor.BackGround.lightBackground))
       //.errorAlert(error: $viewModel.error)
        
    }
    
    
    
    struct SheetView: View {
        @Environment(\.dismiss) var dismiss
        
        @StateObject var viewModel = LoginViewModel()
        
        @State var showTabScreen: Bool = false

        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                
                Text("Login")
                    .font(.system(size: 48, weight: .bold))
                
                LoginField(placeholder: Constants.userName, isPassword: false, value: $viewModel.username)
                    
                LoginField(placeholder: Constants.password, isPassword: true, value: $viewModel.password)
                    


                
                
                
                Button {
                    viewModel.startAuthenticationFlow()
                } label: {
                    if $viewModel.isLoading.wrappedValue {
                        ProgressView()
                            .tint(Color(AppColor.primaryText))
                        
                    } else {
                        Text(Constants.login)
                            .frame(width: 390, height: 56)
                            .font(.system(size: 18, weight: .bold, design: .default))
                           .foregroundColor(.white)
                           .contentShape(Rectangle()) // Add this line
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.primary)
                .cornerRadius(13)
                .buttonStyle(PlainButtonStyle())
                .keyboardShortcut(.defaultAction)
                
                .disabled($viewModel.loginButtonDisabled.wrappedValue)
                //.buttonStyle(ThemeButtonStyle())
                
                Spacer()

                
            }
            .padding()
            .errorAlert(error: $viewModel.error)
            
        }
        
    }
    
    struct LoginField: View {
        let placeholder: String
        let isPassword: Bool
        @Binding var value: String
        
        var body: some View {
            getField()
                .modifier(
                    PlaceholderStyle(showPlaceHolder:  $value.wrappedValue.isEmpty,
                                     placeholder: placeholder)
                )
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
                //.padding()
                .frame(height: 50)
                .background(
                    Color(AppColor.Components.LoginField.background).cornerRadius(13)
                )
                .foregroundColor(
                    Color(AppColor.Components.LoginField.text)
                )
        }
        
        func getField() -> AnyView {
            if isPassword {
                return AnyView(
                    SecureField("", text: $value)
                )
            } else {
                return AnyView(
                    TextField("", text: $value)
                )
            }
            
        }
    }
    
}


extension LoginScreen {
    struct Constants {
        static let login = "Login"
        static let userName = "Username"
        static let password = "Password"
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}


extension Color {
    static let primary = Color("pink")
}
