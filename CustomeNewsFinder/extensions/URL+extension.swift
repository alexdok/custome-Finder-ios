//
//  URL+extension.swift
//  CustomeNewsFinder
//
//  Created by алексей ганзицкий on 12.02.2023.
//

import Foundation
extension URL {

    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
