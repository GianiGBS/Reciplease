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
    
//    // MARK: - Properties
//    static var shared = RecipeService()
//    private init() {}
//    private var task: URLSessionDataTask?
//    private var recipeSession = URLSession(configuration: .default)
//
//    // MARK: - Initialization
//    init(recipeSession: URLSession) {
//        self.recipeSession = recipeSession
//    }
    // MARK: - Properties
    
    private let session : AFSession
    
    // MARK: - Initialization
    init(edamamSession: AFSession = EdamamSession()) {
        self.session = edamamSession

    }
    
    // MARK: - Methods

    func getRecipes(for ingredients: [String], callback: @escaping(Bool, Recipes?) -> Void) {
        let foodsParameter = ["app_id": verifiedKey(accesKey: "API_RECIPE_ID"),
                              "app_key": verifiedKey(accesKey: "API_RECIPE_KEY"),
                              "q": ingredients.joined(separator: ",")]
        
        guard let endpointURL = URL(string: EdamamURL.endpoint) else {
                // Handle the case where the URL is invalid
                return
            }

        session.request(url: endpointURL, method: .get, parameters: foodsParameter) { (responseData : DataResponse<Recipes, AFError>?) in
            switch responseData!.result {
            case .success(let data):
                do {
                    let recipes = try JSONDecoder().decode(Recipes.self, from: data as! Data)
                        callback(true, recipes)
                } catch {
                    print(error.localizedDescription)
                    callback(false, nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                callback(false, nil)
                
            }
        }
        
    }
}
//        edamamSession.request(url: endpointURL, method: .get, parameters: foodsParameter) { (response: DataResponse<Data, AFError>) in

//        edamamSession.request(EdamamURL.endpoint,method: .get, parameters: foodsParameter)
//                    .validate()
//                    .responseData { response in
//            switch response.result {
//            case .success(let data):
//                do {
//                    let welcome = try JSONDecoder().decode(Welcome.self, from: data)
//                        callback(true, welcome)
//                } catch {
//                    print(error.localizedDescription)
//                    callback(false, nil)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//                callback(false, nil)
//
//            }

