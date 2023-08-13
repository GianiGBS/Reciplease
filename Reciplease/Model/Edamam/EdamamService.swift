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
    
    // MARK: - Initialization
    init(edamamSession: Session = Session.default) {
        self.edamamSession = edamamSession

    }
    
    // MARK: - Methods

    func getRecipes(for ingredients: [String], callback: @escaping(Bool, Welcome?) -> Void) {
        let foodsParameter = ["app_id": verifiedKey(accesKey: "API_RECIPE_ID"),
                              "app_key": verifiedKey(accesKey: "API_RECIPE_KEY"),
                              "q": ingredients.joined(separator: ",")]


        edamamSession.request(EdamamURL.endpoint,method: .get,parameters: foodsParameter)
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
