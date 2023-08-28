//
//  NetWorkManagement.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 08/05/2023.
//

import Foundation
import Alamofire

// MARK: - Enum
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - Verified Key
func verifiedKey(accesKey: String) -> String {
    let apiKey = Bundle.main.object(forInfoDictionaryKey: accesKey) as? String

    guard let key = apiKey, !key.isEmpty else {
        return "API key does not exist"
    }
    return "\(key)"
}

// MARK: - View Protocol
protocol ViewDelegate: AnyObject {
    func updateView()
    func toggleActivityIndicator(shown: Bool)
    func presentAlert(title: String, message: String)
}

// MARK: - Protocol
protocol AFSession {
    func request(url: URL, method: HTTPMethod, parameters: Parameters, completionHandler: @escaping (DataResponse<Recipes, AFError>?) -> Void)
}

final class EdamamSession: AFSession {
    
    func request(url: URL, method: HTTPMethod, parameters: Parameters, completionHandler: @escaping (DataResponse<Recipes, AFError>?) -> Void) {
        AF.request(url).responseDecodable(of: Recipes.self) { (responseData) in
            completionHandler(responseData)
        }
        }
}


//        AF.request(url).responseDecodable { (response: DataResponse<T, AFError>) in
//                completionHandler(response)
//            }


//    func request(url: URL, completionHandler: @escaping (AFDataResponse<Any>) -> Void) {
//        AF.request(url).responseData { response in
//            completionHandler(response)
//        }
//    }
