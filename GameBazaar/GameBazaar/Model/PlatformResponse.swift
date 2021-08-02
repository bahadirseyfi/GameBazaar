//
//  PlatformResponse.swift
//  GameBazaar
//
//  Created by bahadir on 31.05.2021.
//

import Foundation

// MARK: - PlatformResponse
struct PlatformResponse: Codable {
    let count: Int
    let results: [Device]
}

// MARK: - Result
struct Device: Codable {
    let id: Int
    let name, slug: String
    let platforms: [Platform]
}

// MARK: - Platform
struct Platform: Codable {
    let id: Int
    let name, slug: String
    let gamesCount: Int
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}
