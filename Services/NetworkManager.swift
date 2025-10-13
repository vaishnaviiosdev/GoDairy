//
//  NetworkManager.swift
//  GoDairy
//
//  Created by San eforce on 18/08/25.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(from urlString: String, as type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        print(url)
        
        print("url : \(url)")

        let (data, response) = try await URLSession.shared.data(from: url)
        print("The response of the fetchData is \(response)")//qad-801090

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("🔹 The Fetch Data Response is: \(responseString)")
        }

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func postData<T: Decodable>(to urlString: String, parameters: Any, as type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])

        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Perform the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("The response of the postData is \(response)")
       
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data) //it returns the decoded response data into SaveProductsResponse
    }
    
    func postFormData<T: Decodable>(
            urlString: String,
            parameters: [String:Any],
            responseType: T.Type
        ) async throws -> T {
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }

            // Convert parameters["data"] to JSON string
            guard let dataValue = parameters["data"],
                  let jsonData = try? JSONSerialization.data(withJSONObject: dataValue, options: []),
                  let jsonString = String(data: jsonData, encoding: .utf8) else {
                throw URLError(.cannotParseResponse)
            }

            // Final form-urlencoded body
            let bodyString = "data=\(jsonString)"
            guard let bodyData = bodyString.data(using: .utf8) else {
                throw URLError(.badURL)
            }

            // Request setup
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = bodyData

            print("🔹 Request URL: \(urlString)")
            print("🔹 HTTP Body: \(bodyString)")

            // Perform request
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("🔹 Raw Response: \(responseString)")
            }
            return try JSONDecoder().decode(T.self, from: data)
        }
}





