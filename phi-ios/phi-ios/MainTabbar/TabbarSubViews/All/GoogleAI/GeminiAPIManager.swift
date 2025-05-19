//
//  GeminiAPIManager.swift
//  MSAIDemo
//
//  Created by Kenneth Wu on 2024/12/12.
//

import Foundation

typealias GeminiCompletion = (Result<String, GeminiError>) -> Void

enum GeminiError: Error {
    case invalidURL
    case noDataReceived
    case invalidResponse(Int)
    case decodingError(Error)
    case noCandidates
    case unknownError(Error)
    case emptyAPIKey
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The API URL is invalid."
        case .noDataReceived:
            return "No data was received from the server."
        case .invalidResponse(let statusCode):
            return "Invalid response received. Status code: \(statusCode)."
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)."
        case .noCandidates:
            return "No candidates were found in the response."
        case .unknownError(let error):
            return "An unknown error occurred: \(error.localizedDescription)."
        case .emptyAPIKey:
            return "API key cannot be empty."
        }
    }
}

struct GeminiRequest: Codable {
    struct Content: Codable {
        struct Part: Codable {
            let text: String
        }
        let parts: [Part]
    }
    let contents: [Content]
}

struct GeminiResponse: Codable {
    let candidates: [Candidate]
    
    struct Candidate: Codable {
        let content: Content
        
        struct Content: Codable {
            let parts: [Part]
            
            struct Part: Codable {
                let text: String
            }
        }
    }
}

class GeminiAPIManager {
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent"
    private var apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func generateContent(prompt: String, completion: @escaping GeminiCompletion) {
        guard !apiKey.isEmpty else {
            completion(.failure(.emptyAPIKey))
            return
        }
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = GeminiRequest(contents: [
            GeminiRequest.Content(parts: [GeminiRequest.Content.Part(text: prompt)])
        ])
        
        do {
            let data = try JSONEncoder().encode(payload)
            request.httpBody = data
        } catch {
            completion(.failure(.unknownError(error)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse((response as? HTTPURLResponse)?.statusCode ?? -1)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noDataReceived))
                return
            }
            
            do {
                let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
                
                if let firstCandidate = geminiResponse.candidates.first {
                    let generatedText = firstCandidate.content.parts.first?.text ?? "No Text"
                    DispatchQueue.main.async {
                        completion(.success(generatedText))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(.noCandidates))
                    }
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}
