//
//  EdamamService.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 03/05/2023.
//

import Foundation
import Alamofire

// MARK: - Recipe Search API
class EdamamService {

    // MARK: - Properties
    private let session: AFSession

    // MARK: - Initialization
    init(session: AFSession = EdamamSession()) {
        self.session = session
    }

    // MARK: - Methods
    func getRecipes(for ingredients: [String], callback: @escaping(Recipes?, Error?) -> Void) {
        let foodsParameter = ["app_id": verifiedKey(accesKey: "API_RECIPE_ID"),
                              "app_key": verifiedKey(accesKey: "API_RECIPE_KEY"),
                              "q": ingredients.joined(separator: ",")]

        let url = EdamamURL.endpoint
        guard let endpointURL = URL(string: url) else {
                // Handle the case where the URL is invalid
            print(AFError.invalidURL(url: url))
            callback(nil, EdamamErrors.invalidURL)
                return
            }

        session.request(url: endpointURL,
                        method: .get,
                        parameters: foodsParameter) {(responseData: AFDataResponse<Data>) in
            DispatchQueue.main.async {
                switch responseData.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let recipes = try decoder.decode(Recipes.self, from: data)
                        callback(recipes, nil)
                    } catch {
                        print(error.localizedDescription)
                        callback(nil, EdamamErrors.decodingError)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    callback(nil, error)
                }
            }
        }
    }
}
enum EdamamErrors: Error {
    case invalidURL
    case decodingError
}
