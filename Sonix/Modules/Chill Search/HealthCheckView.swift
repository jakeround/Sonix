
import SwiftUI

struct HealthCheckView: View {
    @State private var healthCheckResult: String = "Checking..."
    @State private var isError: Bool = false
    
    @State private var searchText = ""
    private var apiService = APIService()
    
    @State private var searchResults: [SearchResult] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("API Health Check")
                    .font(.headline)
                    .padding(.top)
                
                Text(healthCheckResult)
                    .font(.body)
                    .foregroundColor(isError ? .red : .green)
                    .padding(.bottom)
                    .onAppear(perform: performHealthCheck)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $searchText, onCommit: performSearch)
                    // Searches too quicky, not the best results
                    //.onChange(of: searchText, perform: { value in
                    //                  performSearch()
                    //            })
                        .disableAutocorrection(true)
                    if !searchText.isEmpty {
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                
                Button("Search", action: performSearch)
                    .padding(.bottom)
                
                ForEach(searchResults) { result in
                    VStack(alignment: .leading, spacing: 5) {
                        //Text(result.id)
                        Text(result.title)
                            .frame(maxWidth: .infinity)
                        //Text(result.source)
                        //Text(result.link)
                    }
                    .onTapGesture {
                        print("\(result.link)")
                        }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    
                }
            }
            .padding()
        }
    }
    
    private func performHealthCheck() {
        apiService.performHealthCheck { result, error in
            DispatchQueue.main.async {
                if let result = result {
                    healthCheckResult = "Result: \(result)"
                } else if let error = error {
                    healthCheckResult = "Error: \(error.localizedDescription)"
                    isError = true
                }
            }
        }
    }
    
    private func performSearch() {
        apiService.performSearch(query: searchText) { results, error in
            DispatchQueue.main.async {
                if let results = results {
                    self.searchResults = results
                } else if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func printResults(_ data: Data) {
        if let json = String(data: data, encoding: .utf8) {
            print(json)
        }
    }
}

