
import SwiftUI

struct HealthCheckView: View {
    @State private var healthCheckResult: String = "Checking..."
    @State private var isError: Bool = false
    
    @State private var searchText = ""
    private var apiService = APIService()

    var body: some View {
        VStack {
            TextField("Search", text: $searchText, onCommit: performSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Search", action: performSearch)
            
            Text("API Health Check")
                .font(.headline)

            Text(healthCheckResult)
                .font(.body)
                .foregroundColor(isError ? .red : .green)
                .onAppear(perform: performHealthCheck)
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
        apiService.performSearch(query: searchText) { data, error in
            DispatchQueue.main.async {
                if let data = data {
                    printResults(data)
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

