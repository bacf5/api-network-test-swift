//
//  ContentView.swift
//  api-call-test
//
//  Created by Bruno Agustín Caruso Fassa on 21/07/2025.
//

import SwiftUI


struct ContentView: View {
    @State private var catImg: URL?
    @State private var catFact: Facts?

    
    var body: some View {
        VStack(spacing: 20) {
            
            if let catImg = catImg {
                AsyncImage(url: catImg) { image in
                    image
                        .resizable()
                        .scaledToFit()
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
            
            
            
            
//            ForEach(library.bookTitles, id: \.self) { title in
//                                    Text(title)
            
            Text("Success or not")
            
            Spacer()
            
        }
        .padding()
        .task {
            do {
                catImg = try await getImgCat()
                catFact = try await getFactsCat()
                
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
    }
    
    func getFactsCat() async throws -> Facts {
        let catFactUrl = URL(string: "https://meowfacts.herokuapp.com/")!
        
        
        
//        guard let url = URL(string: "https://meowfacts.herokuapp.com/") else {
//            throw NetworkError.invalidUrl
//        }
        
        let (data, response) = try await URLSession.shared.data(from: catFactUrl)
        
        let decoder = JSONDecoder()
        
        let catFact = try decoder.decode(Facts.self, from: data)
        
        return catFact
        
    }
}

#Preview {
    ContentView()
}

// ALL IN THE SAME FILE BECAUSE IM TESTING SOMETHING BRRUDA

//struct Cats: Decodable {
//    let url: String
//}

struct Facts: Decodable {
    let facts: [String]
    let success: String
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}




