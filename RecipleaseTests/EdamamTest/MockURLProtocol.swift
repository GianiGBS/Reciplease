//
//  MockURLProtocol.swift
//  RecipleaseTests
//
//  Created by Giovanni Gabriel on 19/07/2023.
//

import Foundation
import XCTest

@testable import Reciplease

final class MockURLProtocol: URLProtocol {
    // MARK: - Properties
    
    enum ResponseType {
        case error(Error)
        case succes(HTTPURLResponse)
    }
    static var responseType: ResponseType!
    static var response: HTTPURLResponse?
    static var data: Data?
    static var error: Error?
    
    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
            return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    private(set) var activeTask: URLSessionTask?

    // MARK: - Methods

    override class func canInit(with request: URLRequest) -> Bool {
        // To check if this protocol can handle the given request.
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Here you return the canonical version of the request but most of the time you pass the orignal one.
        return request
    }
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    // MARK: -
    override func startLoading() {
        activeTask = session.dataTask(with: request.urlRequest!)
        activeTask?.cancel()
        
        if let response = MockURLProtocol.response {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let data = MockURLProtocol.data {
            self.client?.urlProtocol(self, didLoad: data)
        }
        if let error = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    // MARK: -
    override func stopLoading() {
        // This is called if the request gets canceled or completed.
        activeTask?.cancel()
    }
}
// MARK: - URLSessionDataDelegate

extension MockURLProtocol: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        switch MockURLProtocol.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .succes(let response)?:
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        default:
            break
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
}
extension MockURLProtocol {
    
    enum MockError: Error {
        case none
    }

    static func responseWithFailure() {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.error(MockError.none)
    }

    static func responseWithStatusCode(code: Int) {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.succes(HTTPURLResponse(url: URL(string: "https://api.edamam.com/api/recipes/v2?type=public&beta=false")!, statusCode: code, httpVersion: nil, headerFields: nil)!)
    }
}
