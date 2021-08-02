//
//  DetailEndPointItem.swift
//  GameBazaar
//
//  Created by bahadir on 29.05.2021.
//

import Foundation
import CoreAPI

enum DetailEndPointItem: Endpoint {
    case detailPage(query: String)
    var baseURL: String { "https://api.rawg.io/api/" }
    
    var path: String {
        switch self {
        case .detailPage(let query):
            print(query)
            return "games/\(query)?key=\(Constants.apiKey)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .detailPage: return .get
        }
    }
}
