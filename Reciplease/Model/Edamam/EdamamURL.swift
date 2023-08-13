//
//  EdamamURL.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 03/05/2023.
//

import Foundation

// MARK: - Recipe API
class EdamamURL {
    static let endpoint = "https://api.edamam.com/api/recipes/v2?type=public&beta=false"
}

//    class RecipeSession: RecipeProtocol {
//        func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void) {
//            Alamofire.request(url).responseJSON { responseData in
//                completionHandler(responseData)
//            }
//        }
//    }
