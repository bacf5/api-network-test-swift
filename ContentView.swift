//
//  ContentView.swift
//  api-call-test
//
//  Created by Bruno Agustín Caruso Fassa on 21/07/2025.
//

import SwiftUI


struct ContentView: View {
    @State private var catImg: Cats?

    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .foregroundColor(.secondary)
                .frame(width: 120, height: 120)
            
            Text("Facts")
                .bold()
                .font(.title2)
            
            Text("Success or not")
            
            Spacer()
            
            
            
        }
        .padding()
        .task {
            
        }
        
    }
    
    func getImgCat() async throws -> Cats {
        guard let endpoint = URL(string: "https://api.thecatapi.com/v1/images/search") else { throw NetworkError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: endpoint)
        
        guard let response = response as? HTTPURLResponse, response .statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
         let decoder = JSONDecoder()
        
            return try decoder.decode(Cats.self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }

}

#Preview {
    ContentView()
}

// ALL IN THE SAME FILE BECAUSE IM TESTING SOMETHING BRRUDA

struct Cats: Decodable {
    let url: String
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}


