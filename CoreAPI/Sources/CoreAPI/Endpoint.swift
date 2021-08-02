//
//  File.swift
//  
//
//  Created by bahadir on 24.05.2021.
//

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var headers: [String: String] { get }
}

public extension Endpoint {
    var headers: [String: String] { [:] }
    var parameters: [String: Any] { [:] }
    var url: String { "\(baseURL)\(path)" }
}
