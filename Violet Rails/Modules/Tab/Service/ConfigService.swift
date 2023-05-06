//
//  ConfigService.swift
//  Violet Rails
//
//  Created by Joses Solmaximo on 05/05/23.
//

import Foundation

struct ConfigService {
    let configUrl = "/api/1/mobile_client_configuration/describe"

    func getConfig(endpoint: String) async throws -> Config {
        guard let url = URL(string: "\(endpoint)\(configUrl)") else {
            throw ServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            throw ServiceError.invalidResponse
        }
        
        return try JSONDecoder().decode(Config.self, from: data)
    }
}
