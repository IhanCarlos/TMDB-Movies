//
//  APIClientMock.swift
//  TMDB Movie
//
//  Created by ihan carlos on 20/04/26.
//

import Foundation
@testable import TMDB_Movie

final class APIClientMock: APIClientProtocol {

    var sendCalled = false
    var lastEndpoint: Endpoint?
    var successResponse: Any?
    var errorResponse: Error?
    
    var fetchDataCalled = false
    var lastURL: URL?
    var fetchDataSuccessResponse: Data?
    var fetchDataErrorResponse: Error?
    
    func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        sendCalled = true
        lastEndpoint = endpoint
        
        if let error = errorResponse {
            throw error
        }
        
        if let response = successResponse as? T {
            return response
        }
        
        throw NSError(domain: "APIClientMock", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta de 'send' não configurada"])
    }
    
    func fetchData(_ url: URL) async throws -> Data {
        fetchDataCalled = true
        lastURL = url
        
        if let error = fetchDataErrorResponse {
            throw error
        }
        
        if let data = fetchDataSuccessResponse {
            return data
        }
        
        return Data()
    }
}
