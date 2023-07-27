//
//  RequestBuilder.swift
//  lub-ios-alexdok
//
//  Created by алексей ганзицкий on 04.02.2023.
//

import Foundation

protocol RequestBuilder {
    func createRequestFrom(url: String, params: [String: String]) -> URLRequest?
}

class RequestBuilderImpl: RequestBuilder {
    func createRequestFrom(url: String, params: [String: String]) -> URLRequest? {

        guard var url = URL(string: url) else { return nil }
        url = url.appendingQueryParameters(params)
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
        request.httpMethod = "GET"
      
        return request
    }
}
