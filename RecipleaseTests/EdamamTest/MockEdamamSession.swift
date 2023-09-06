//
//  MockURLProtocol.swift
//  RecipleaseTests
//
//  Created by Giovanni Gabriel on 19/07/2023.
//

import Foundation
import Alamofire
@testable import Reciplease

struct MockedResult {
    var response: HTTPURLResponse?
    var data: Data?
    var error: Error?
}

final class MockEdamamSession: AFSession {

    // MARK: - Properties
    private let mockedResult: MockedResult

    // MARK: - Initialization
    init(mockedResult: MockedResult) {
        self.mockedResult = mockedResult
    }

    // MARK: - Methods
    func request(url: URL,
                 method: Alamofire.HTTPMethod,
                 parameters: Alamofire.Parameters,
                 completionHandler: @escaping (Alamofire.AFDataResponse<Data>) -> Void) {
        let httpResponse = mockedResult.response
        let data = mockedResult.data
        let error = mockedResult.error
        let result: Result<Data, AFError>
        if let error = error {
            let afError = AFError.sessionTaskFailed(error: error)
            result = .failure(afError)
        } else {
            if let data = data {
                result = .success(data)
            } else {
                let afError = AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                result = .failure(afError)
            }
        }

        // Create a fake HTTPURLResponse
        let httpUrlResponse = HTTPURLResponse(url: url,
                                              statusCode: httpResponse?.statusCode ?? 200,
                                              httpVersion: nil,
                                              headerFields: nil)!

        // Create an AFDataResponse object
        let dataResponse = AFDataResponse<Data>(
            request: nil,
            response: httpResponse,
            data: data,
            metrics: nil,
            serializationDuration: 0,
            result: result
        )

        // Call the completion with the mock response
        completionHandler(dataResponse)
    }
}
