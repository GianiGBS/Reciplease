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
        guard let apiURL = EdamamURL.endpoint(foodsParameter: ingredients) else {
                // Handle the case where the URL is invalid
            callback(nil, EdamamErrors.invalidURL)
                return
            }

        session.request(url: apiURL,
                        method: .get) { (responseData: AFDataResponse<Data>) in
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

class EdamamSession: AFSession {
    func request(url: URL,
                 method: Alamofire.HTTPMethod,
                 completionHandler: @escaping (Alamofire.AFDataResponse<Data>) -> Void) {
        AF.request(url).responseData { responseData in
            completionHandler(responseData)
        }
    }
}
enum EdamamErrors: Error {
    case invalidURL
    case decodingError
    case server
}
