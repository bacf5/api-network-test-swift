//
//  ContentView.swift
//  api-call-test
//
//  Created by Bruno Agustín Caruso Fassa on 21/07/2025.
//

import SwiftUI


struct ContentView: View {
    @State private var catImg: URL?

    
    var body: some View {
        VStack(spacing: 20) {
            
            if let catImg = catImg {
                AsyncImage(url: catImg) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                }
                placeholder: {
                    Rectangle()
                        .foregroundColor(.secondary)
                    
                }
                .frame(width: 200, height: 200)
            }
            
            
            
            Text("Facts")
                .bold()
                .font(.title2)
            
            Text("Success or not")
            
            Spacer()
            
        }
        .padding()
        .task {
            do {
                catImg = try await getImgCat()
            } catch NetworkError.invalidUrl {
                print("Invalid URL")
            } catch NetworkError.invalidData {
                print("Invalid data")
            } catch NetworkError.invalidResponse {
                print("Invalid response")
            } catch {
                print("Unexpected error")
            }
        }
       
        
    }
    
    func getImgCat() async throws -> URL {
        guard let url = URL(string: "https://cataas.com/cat") else {
            throw NetworkError.invalidUrl
        }
        
        return url
        
//        var request = URLRequest(url: url)
////        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
//        let (data, response) = try await URLSession.shared.data(from: url)
        
//        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//            throw NetworkError.invalidResponse
//        }
//        
//        do {
//            let decoder = JSONDecoder()
//            return try decoder.decode(Cats.self, from: data)
//        } catch {
//            throw NetworkError.invalidData
//        }
    }
//
}

#Preview {
    ContentView()
}

// ALL IN THE SAME FILE BECAUSE IM TESTING SOMETHING BRRUDA

//struct Cats: Decodable {
//    let url: String
//}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}


