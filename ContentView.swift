//
//  ContentView.swift
//  api-call-test
//
//  Created by Bruno Agustín Caruso Fassa on 21/07/2025.
//

import SwiftUI


struct ContentView: View {
    @State var catImg: URL?
    @State var catFact: CatFacts?
    @State var dogImg: DogImg?
    @State var dogFact: DogFacts?

    
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
            
            if let catFact = catFact {
                Text(catFact.data.first ?? "No fact found")
                    .bold()
                
            } else {
                Text("Loading your cat fact...")
                    .italic()
            }
            
            Spacer()
            
//            if let dogImg = DogImg? {}
//                placeholder: {
//                    Rectangle()
//                        .foregroundColor(.secondary)
//                    
//                }
//                .frame(width: 200, height: 200)
//            }
//            Text("\(dogImg?.message)")
            
            if let dogImg = dogImg {
                AsyncImage(url: URL(string: dogImg.message)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                    
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.secondary)
                    
                }
                .frame(width: 200, height: 200)
                    
            }
            
            Text("Cool Fact perrito")

            Spacer()
            
        }
        .padding()
        .task {
            do {
                catImg = try await getImgCat()
                catFact = try await getFactsCat()
                dogImg = try await getImgDog()
                dogFact = try await getFactsDog()
                
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
    
    func getFactsCat() async throws -> CatFacts {
        let catFactUrl = URL(string: "https://meowfacts.herokuapp.com/")!
        
        let (data, response) = try await URLSession.shared.data(from: catFactUrl)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let fact = try JSONDecoder().decode(CatFacts.self, from: data)
        
        return fact
 
        
    }
    
    func getImgDog() async throws -> DogImg {
        let dogImgURL = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        let (data, response) = try await URLSession.shared.data(from: dogImgURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let imageDog = try JSONDecoder().decode(DogImg.self, from: data)
        
        return imageDog
    }
    
    func getFactsDog() async throws -> DogFacts {
        let dogFactUrl = URL(string: "https://dogapi.dog/api/facts")!
        
        let (data, response) = try await URLSession.shared.data(from: dogFactUrl)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let fact = try JSONDecoder().decode(DogFacts.self, from: data)
        
        return fact
    }
}

#Preview {
    ContentView()
}

// ALL IN THE SAME FILE BECAUSE IM TESTING SOMETHING BRRUDA

//struct Cats: Decodable {
//    let url: String
//}

struct CatFacts: Decodable {
    let data: [String]
//    let success: String
}

struct DogImg: Decodable {
    let message: String
}

struct DogFacts: Decodable {
    let facts: [String]
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}




