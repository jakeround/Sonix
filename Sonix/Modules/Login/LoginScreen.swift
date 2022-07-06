//
//  LoginScreen.swift
//  Sonix
//
//  Created by Jake Round on 10/06/2022.
//


import SwiftUI

struct LoginScreen: View {
    
    
    @State private var showingSheet = false
    
    
    
    var body: some View {
        
        ZStack {
            
        
                
                VStack() {
                   
                   
                    
                    Spacer()
                    Text("Sonix")
                        .font(.system(size: 42, weight: .bold))
                    Text("Watch your favourite movies")
                        .foregroundColor(.gray)
                    Spacer()
                    
                    
                    
                    
                    HStack {
                    Button(action: { showingSheet.toggle() }) {
                            Text("Get Started")
                        }
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 54)
                        //.padding([.leading, .trailing], 20)
                        .foregroundColor(.white)
                        
                        .background(Color.primary)
                        .cornerRadius(13)
                        
                        
                    }//.padding([.leading, .trailing], 20)
                    
                    .sheet(isPresented: $showingSheet) {
                        SheetView()
                    }
                    
                    //.background(Color.primary)
                    //.cornerRadius(13)
                    //.buttonStyle(PlainButtonStyle())
                    
                    

                            
                            

                    
                }
                //.padding()
                .padding([.leading, .trailing], 20)
            
            
        }
        //.padding()
        .navigationBarHidden(true)
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(AppColor.BackGround.lightBackground))
       //.errorAlert(error: $viewModel.error)
        
    }
    
    
    
    struct SheetView: View {
        @Environment(\.dismiss) var dismiss
        @StateObject var viewModel = LoginViewModel()
        @State var showTabScreen: Bool = false
        
        @State private var username = ""
        @State private var password = ""

        var body: some View {
            VStack (alignment: .leading) {
                HStack {
                    
                }.frame(height: 16)
                
                VStack(alignment: .leading) {
                Text("Username or email address")
                        .multilineTextAlignment(.leading)
                    .font(.system(size: 14, weight: .bold, design: .default))
                    //.frame(alignment: .leading)
                    
                }
                LoginField(placeholder: Constants.userName, isPassword: false, value: $viewModel.username)
                
                VStack(alignment: .leading, spacing: 6) {
                Text("Password")
                    .font(.system(size: 14, weight: .bold, design: .default))
                }
                .frame(alignment: .trailing)
                LoginField(placeholder: Constants.password, isPassword: true, value: $viewModel.password)
                
                Spacer()
                
                Button {
                    viewModel.startAuthenticationFlow()
                } label: {
                    if $viewModel.isLoading.wrappedValue {
                        ProgressView()
                            .tint(Color(AppColor.primaryText))
                        
                    } else {
                        Text(Constants.login)
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 54)
                            .foregroundColor(.white)
                            
                            .background(Color.primary)
                            .cornerRadius(13)
                    }
                    
                }
                
                
                
                

                
            }
            .padding([.leading, .trailing], 20)
                

                
           
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
                .cornerRadius(8)
                //.border(Color(AppColor.Components.LoginField.background), width: 1)
                .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(AppColor.Components.LoginField.background), lineWidth: 1)
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
        static let userName = "Jake"
        static let password = ""
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
