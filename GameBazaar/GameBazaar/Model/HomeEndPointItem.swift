//
//  HomeEndPointItem.swift
//  GameBazaar
//
//  Created by bahadir on 24.05.2021.
//

import Foundation
import CoreAPI

enum HomeEndPointItem: Endpoint { 
    case homepage(query: String, device: String)
    case platform
    
    var baseURL: String { "https://api.rawg.io/api/" }
    
    var path: String {
        switch self {
        case .homepage(let query, let device):
            return "games?key=\(Constants.apiKey)&page=\(query)&search=\(device)"
        case .platform:
            return "platforms/lists/parents?key=\(Constants.apiKey)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .homepage: return .get
        case .platform: return .get
        }
    }
}
