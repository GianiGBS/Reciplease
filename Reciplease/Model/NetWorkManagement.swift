//
//  NetWorkManagement.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 08/05/2023.
//

import Foundation

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
