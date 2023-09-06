//
//  NetWorkManagement.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 08/05/2023.
//

import Foundation
import Alamofire

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
    func request(url: URL,
                 method: HTTPMethod,
                 parameters: Parameters,
                 completionHandler: @escaping (AFDataResponse<Data>) -> Void)
}

final class EdamamSession: AFSession {

    func request(url: URL,
                 method: Alamofire.HTTPMethod,
                 parameters: Alamofire.Parameters,
                 completionHandler: @escaping (Alamofire.AFDataResponse<Data>) -> Void) {
        AF.request(url).responseDecodable { responseData in
            completionHandler(responseData)
        }
    }
}
