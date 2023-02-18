//
//  APIError.swift
//  Templates
//
//  Created by Alma Hodzic on 18.02.23.
//

import Foundation

enum APIError: Error {
    case network(description: String)
    case parsing(description: String)
}
