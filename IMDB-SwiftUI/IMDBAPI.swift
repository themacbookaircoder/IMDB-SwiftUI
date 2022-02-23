//
//  IMDBAPI.swift
//  IMDB-SwiftUI
//
//  Created by Kuldeep Vashisht on 23/02/22.
//

import Foundation

// data structure to which matches the json

struct PageData: Codable{
    let search: [Movie]
    let totalResults: String
    let response: String
    
    // coding keys - in the json search is under Search with capital S so I have to change it here
    // I don't want to have a Search field with capital S in the structure
    // same with response etc...
    enum CodingKeys: String, CodingKey{
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

struct Movie: Codable{
    let id: String
    let title: String
    let year: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey{
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}

// class which handles the api calls
final class IMDBAPI{

    // function to get data from the api
    func getDataForPageNr(page: Int, completion: @escaping (PageData) -> ()){
        
        // check if page argument in the URL is a positive number
        guard page >= 1 else{ return }
        
        // create the URL
        if let url = URL(string: "http://www.omdbapi.com/?s=Batman&page=\(page)&apikey=eeefc96f"){
            // start URL session
            URLSession.shared.dataTask(with: url){ data, response, error in
                // if you get a data response
                if let data = data{
                    do{
                        // decode the JSON to the PageData object
                        let result = try JSONDecoder().decode(PageData.self, from: data)
                        
                        // we are changing the UI dynamically here, you have to do that on the main thread in SwiftUI
                        DispatchQueue.main.async {
                            // use the completion handler and pass the result
                            completion(result)
                        }
                        
                    }
                    // here handle errors when decoding of JSON fails
                    catch let error{
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    
}

