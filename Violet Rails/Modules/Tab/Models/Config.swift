//
//  Config.swift
//  Violet Rails
//
//  Created by Joses Solmaximo on 05/05/23.
//

import Foundation

struct Config: Codable {
    let data: ConfigData
}

struct ConfigData: Codable {
    let id, type: String
    let attributes: Attributes
}

struct Attributes: Codable {
    let id: Int
    let createdAt, updatedAt: String
    let properties: Properties
    let version: Int
    let slug, name, namespaceType: String
    let requiresAuthentication: Bool

    enum CodingKeys: String, CodingKey, Codable {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case properties
        case version
        case slug
        case name
        case namespaceType = "namespace_type"
        case requiresAuthentication = "requires_authentication"
    }
}

struct Properties: Codable {
    let tabNavigation: [TabNavigation]

    enum CodingKeys: String, CodingKey {
        case tabNavigation = "tab_navigation"
    }
}

struct TabNavigation: Codable {
    let path, label: String
}

enum ServiceError: Error {
    case invalidURL
    case invalidResponse

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL is invalid"
        case .invalidResponse:
            return "Response is invalid"
        }
    }
}
