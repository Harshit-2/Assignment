//
//  APIManager.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import Foundation

struct APIDataItem: Codable {
    let id: String
    let name: String
    let data: [String: AnyCodable]?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, data
    }
    
    // Helper property to get data as a formatted string
    var dataString: String? {
        guard let data = data else { return nil }
        
        let pairs = data.map { key, value in
            return "\(key): \(value.value)"
        }
        return pairs.joined(separator: ", ")
    }
}

// Helper struct to handle Any values in Codable
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if container.decodeNil() {
            value = NSNull()
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        if let intValue = value as? Int {
            try container.encode(intValue)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue)
        } else if let stringValue = value as? String {
            try container.encode(stringValue)
        } else if let boolValue = value as? Bool {
            try container.encode(boolValue)
        } else if value is NSNull {
            try container.encodeNil()
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unsupported type"))
        }
    }
}

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func fetchData(completion: @escaping (Result<[APIDataItem], Error>) -> Void) {
        guard let url = URL(string: Constants.apiBaseURL) else {
            completion(.failure(NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let items = try JSONDecoder().decode([APIDataItem].self, from: data)
                completion(.success(items))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
