//
//  Dictionary+extension.swift
//  CustomeNewsFinder
//
//  Created by алексей ганзицкий on 12.02.2023.
//

import Foundation
protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {

    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
}

