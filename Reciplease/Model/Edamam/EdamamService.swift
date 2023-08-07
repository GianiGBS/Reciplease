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
    
    private let edamamSession : Session
    let config: EndpointConfig
    // MARK: - Initialization
    init(config: EndpointConfig, session: URLSessionConfiguration = URLSessionConfiguration.default) {
        let sessionManager = Alamofire.Session(configuration: session)
        edamamSession = Session(configuration: session)
        self.config = config
    }
    
    // MARK: - Methods
    func getRecipes(for ingredients: [String], callback: @escaping(Bool, Welcome?) -> Void) {
        // TODO: - Alamofire
        let foodsParameter = ["app_id": verifiedKey(accesKey: "API_RECIPE_ID"),
                              "app_key": verifiedKey(accesKey: "API_RECIPE_KEY"),
                              "q": ingredients.joined(separator: ",")]
        guard let url = URL(string: config.url) else { return }

        AF.request(url,
                   method: .get,
                   parameters: foodsParameter,
                   encoding: URLEncoding.default,
                   headers: nil,
                   interceptor:  nil)
        .validate()
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let welcome = try JSONDecoder().decode(Welcome.self, from: data)
                        callback(true, welcome)
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
