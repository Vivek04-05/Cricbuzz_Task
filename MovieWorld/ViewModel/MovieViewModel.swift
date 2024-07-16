//
//  MovieViewModel.swift
//  MovieWorld
//
//  Created by Vivek Patel on 15/07/24.
//

import Foundation
struct MovieViewModel {
    
    
    func loadData() -> [MovieDataModel] {
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
            print("JSON file not found")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let movieData = try JSONDecoder().decode([MovieDataModel].self, from: data)
            return movieData
        } catch {
            print("Failed to decode JSON: \(error)")
            return []
        }
    }
    
}
