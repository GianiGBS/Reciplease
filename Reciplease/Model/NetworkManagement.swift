//
//  NetWorkManagement.swift
//  Reciplease
//
//  Created by Giovanni Gabriel on 08/05/2023.
//

import Foundation
import Alamofire

// MARK: - Verified Key
extension String {
    var verifiedKey: String {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: self) as? String

        guard let key = apiKey, !key.isEmpty else {
            return "API key does not exist"
        }
        return key
    }
}
// MARK: - Convert Int to Time
extension Int {
    func formatTime() -> String {
            let hours = self / 3600
            let minutes = (self % 3600) / 60
            let seconds = self % 60

            var formattedTime = ""
            if hours > 0 {
                formattedTime += "\(hours)h "
            }
            if minutes > 0 {
                formattedTime += "\(minutes)min "
            }
            if seconds > 0 {
                formattedTime += "\(seconds)s"
            }
            return formattedTime.trimmingCharacters(in: .whitespaces)
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
