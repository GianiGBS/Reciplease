//
//  RecipeService.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 03/05/2023.
//

import Foundation

// MARK: - Recipe Search API
class RecipeService {
    
    // MARK: - Properties
    static var shared = RecipeService()
    private init() {}
    private var task: URLSessionDataTask?
    private var recipeSession = URLSession(configuration: .default)
    
    // MARK: - Initialization
    init(recipeSession: URLSession) {
        self.recipeSession = recipeSession
    }
    
    // MARK: - Methods
    func getRecipe(for ingredients: [String], callback: @escaping(Bool, Recipe?) -> Void) {
        
        let allURL = RecipeAPI.url + ingredients.joined(separator: ",")
        
        var request = URLRequest(url: URL(string: allURL)!)
        request.httpMethod = HTTPMethod.get.rawValue
        
        task?.cancel()
        task = recipeSession.dataTask(with: request) {data, response, error in DispatchQueue.main.async {
            guard let data = data, error == nil else {
                callback(false, nil)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(false, nil)
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(Recipe.self, from: data) else {
                callback(false, nil)
                return
            }
            print(responseJSON)
            let recipe = responseJSON
            callback(true, recipe)
            
        }
        }
        task?.resume()
    }
}
