//
//  MessageService.swift
//  RoomsToGo
//
//  Created by Ahmed Gedi on 7/12/24.
//

import Foundation

class MessageService {
    func fetchMessages(for email: String, completion: @escaping (Result<[Message], MessageError>) -> Void) {
        guard let url = URL(string: "https://vcp79yttk9.execute-api.us-east-1.amazonaws.com/messages/users/\(email)") else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let messages = try JSONDecoder().decode([Message].self, from: data)
                completion(.success(messages))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}

enum MessageError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case noData
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .networkError(let error):
            return error.localizedDescription
        case .noData:
            return "No data received."
        case .decodingError:
            return "Failed to decode messages."
        }
    }
}

