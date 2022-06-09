//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

import SwiftUI

struct SearchScreen: View {
    
    struct SharesheetURL: Identifiable {
        let id: String
        let url: URL
    }
        
    @StateObject var viewModel = SearchViewModel()
    
    @State var showVideoPlayer: Bool = false
    @State var videoURL: URL? = nil
    @State var sharesheetData: SharesheetURL?

    init() {
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some View {
        NavigationView {
            ZStack {
                
                
                VStack {
                    
                    HStack {
                        SearchField(placeholder: Constants.searchBarPlaceholder, value: $viewModel.searchText)
                        
                        Button {
                            self.transferData()
                        } label: {
                            if $viewModel.isUploading.wrappedValue {
                                ProgressView()
                                    .tint(Color(AppColor.primaryText))
                            } else {
                                Label(Constants.transfer, image: "icon_upload")
                            }
                        }
                        .buttonStyle(HollowButtonStyle())
                       
                        
                    }
                    .padding()
                    
                    listingView
                        .sheet(item: $sharesheetData, onDismiss: nil, content: { data in
                            ShareSheet(activityItems: [data.url])
                        })
                    
                }
                .onAppear {
                    self.fetchData()
                }
                .frame(minWidth: 350, maxWidth: 700)

                
                if viewModel.isLoading {
                    ActivityIndicator()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(AppColor.BackGround.darkBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.title)
            .errorAlert(error: $viewModel.error)
            .sheet(isPresented: $showVideoPlayer) {
                AVPlayerView(videoURL: $videoURL)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private var listingView: some View {
        List(viewModel.datasource) { data in
            ListCell(title: data.file.name, isLoading: data.isLoading, cellTapped: {
                self.videoURL = viewModel.getStreamURL(file: data.file)
                self.showVideoPlayer = true
            }, shareTapped: {
                getShareURL(file: data)
            })
                .listRowInsets(EdgeInsets())
                .onAppear {
                    if data.id == viewModel.datasource.last?.id {
                        viewModel.fetchData()
                    }
                }
        }
        .refreshable {
            self.refreshData()
        }
    }
    
    struct ListCell: View {
        let title: String
        let isLoading: Bool
        
        var cellTapped: (() -> ())?
        var shareTapped: (() -> ())?
        
        var body: some View {
            VStack(spacing: 10) {
                
                Spacer()
                    .frame(height: 1)
                
                HStack {
                    
                    Group {
                        Text(title)
                            .padding(.top, 10)
                            .foregroundColor(
                                Color(AppColor.Components.FileList.text)
                            )
                        
                        Spacer()
                    }
                    .onTapGesture {
                        cellTapped?()
                    }
                    
                    if isLoading {
                        ProgressView()
                            .tint(Color(AppColor.primaryText))
                    } else {
                        Button {
                            shareTapped?()
                        } label: {
                            Image("icon_share")
                        }
                    }
                    
                    Spacer()
                        .frame(width: 20)
                }
                
                Spacer()
                    .frame(height: 1)
                
                Rectangle()
                    .foregroundColor(Color(AppColor.seperator))
                    .frame(height: 0.5)
                
            }
            .padding(.leading, 20)
            .listRowBackground(Color(AppColor.Components.FileList.background))
            .listRowSeparator(.hidden)
        }
    }
    
    struct SearchField: View {
        let placeholder: String
        @Binding var value: String
        
        var body: some View {
            TextField(placeholder, text: $value)
                .padding()
                .background(
                    Color(AppColor.Components.SearchBar.background)
                        .cornerRadius(10)
                )
                .foregroundColor(
                    Color(AppColor.Components.SearchBar.text)
                )
        }
    }

}

extension SearchScreen {
    
    func fetchData() {
        viewModel.fetchData()
    }
    
    func refreshData() {
        viewModel.refreshData()
    }
    
    func transferData() {
        viewModel.trasferData()
    }
    
    func getShareURL(file: PutioKitSearchFile) {
        if let shareURL = viewModel.getStreamURL(file: file.file) {
            sharesheetData = SharesheetURL(id: UUID().uuidString, url: shareURL)
        }
        //if let shareURL = file.shareURL {
          //  sharesheetData = SharesheetURL(id: UUID().uuidString, url: shareURL)
        //} else {
           // viewModel.generateShareURL(file: file.file) { shareURL in
             //   sharesheetData = SharesheetURL(id: UUID().uuidString, url: shareURL)
            //}
        //}
    }
    
}

extension SearchScreen {
    struct Constants {
        static let title = "Sonix"
        static let searchBarPlaceholder = "Paste URL or Torrent Hash"
        static let transfer = "Transfer"
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
