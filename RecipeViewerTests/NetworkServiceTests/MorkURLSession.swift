//
//  MorkURLSession.swift
//  RecipeViewer
//
//  Created by Li Zhao on 2/25/25.
//

import XCTest
@testable import RecipeViewer

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
         return request
    }
        
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No handler provided for MockURLProtocol")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            XCTFail("Error handling request: \(error)")
        }
    }
    
    override func stopLoading() {}
}

