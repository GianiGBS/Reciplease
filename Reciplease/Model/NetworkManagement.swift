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

// MARK: - Convert Int to Time
func formatTime(_ minutes: Int) -> String {
    if minutes < 60 {
        return "\(minutes) min"
    } else if minutes == 60 {
        return "1 h"
    } else {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        if remainingMinutes == 0 {
            return "\(hours) h"
        } else {
            return "\(hours) h \(remainingMinutes) min"
        }
    }
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
                 completionHandler: @escaping (AFDataResponse<Data>) -> Void)
}
