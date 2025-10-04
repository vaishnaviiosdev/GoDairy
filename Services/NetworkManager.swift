//
//  NetworkManager.swift
//  GoDairy
//
//  Created by San eforce on 18/08/25.
//

import Foundation
import UIKit


class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(from urlString: String, as type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        print(url)

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
    
    func uploadMultipart<T: Decodable>(
        urlString: String,
        parameters: [String: Any],
        imageData: Data,
        imageFieldName: String,
        fileName: String,
        mimeType: String,
        responseType: T.Type
    ) async throws -> T {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        print("The UrlString is \(urlString)")
        print("The Parameters in the multipartFormData is \(parameters)")

        // JSON part
        let jsonData = try JSONSerialization.data(withJSONObject: parameters)
        print("The jsondata of the parameters is \(parameters)")
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"data\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        body.append(jsonData)
        print("The Json part of the jsonData is \(jsonData)")
        body.append("\r\n".data(using: .utf8)!)

        // Image part
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(imageFieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        
        
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        print(body)

        // Make the request
        let (data, response) = try await URLSession.shared.data(for: request)

        // Print raw response body (as string, for debugging)
        if let rawResponse = String(data: data, encoding: .utf8) {
            print("🧾 Raw Response:")
            print(rawResponse)
        }
        
        // Optional: Print status code
        if let httpResponse = response as? HTTPURLResponse {
            print("📦 Status Code: \(httpResponse.statusCode)")
        }

        // Decode and return
        let decoded = try JSONDecoder().decode(T.self, from: data)
        print("✅ Decoded Response: \(decoded)")
        return decoded
    }
}





