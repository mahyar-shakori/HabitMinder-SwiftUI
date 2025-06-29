//
//  Endpoint.swift
//  HabitMinder SwiftUI
//
//  Created by Mahyar on 02/04/2025.
//

import Foundation

protocol Endpoint {
    associatedtype Body: Encodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Body? { get }
    var headers: [String: String]? { get }
    var isMultipart: Bool { get }
    var multipartParts: [MultipartPart]? { get }
    var queryItems: [URLQueryItem]? { get }
    
    func asURLRequest(configuration: NetworkAPIConfiguration) throws -> URLRequest
}

extension Endpoint {
    var baseURL: String {
        return "https://api.api-ninjas.com"
    }
    
    func asURLRequest(configuration: NetworkAPIConfiguration) throws -> URLRequest {
            var components = URLComponents(string: baseURL + path)
            components?.queryItems = queryItems

            guard let url = components?.url else {
                throw NetworkAPIError.invalidURL
            }

            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.timeoutInterval = configuration.timeoutInterval

            headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

            if isMultipart {
                let boundary = UUID().uuidString
                request.addValue(HTTPHeaderValue.multipart(boundary: boundary), forHTTPHeaderField: HTTPHeaderKey.contentType)
                if let parts = multipartParts {
                    guard let multipartBody = buildMultipartBody(with: parts, boundary: boundary) else {
                        throw NetworkAPIError.invalidMultipartBody
                    }
                    request.httpBody = multipartBody
                }
            } else if method != .get, let body = body {
                request.httpBody = try JSONEncoder().encode(body)
                request.addValue(HTTPHeaderValue.json, forHTTPHeaderField: HTTPHeaderKey.contentType)
            }

            return request
        }
    
    func buildMultipartBody(with parts: [MultipartPart], boundary: String) -> Data? {
        var body = Data()

        for part in parts {
            guard
                let boundaryData = MultipartBoundaryBuilder.boundary(boundary).data(using: .utf8),
                let contentDispositionData = MultipartHeaderBuilder.contentDisposition(name: part.name, filename: part.filename).data(using: .utf8),
                let newLineData = MultipartConstants.newLine.data(using: .utf8)
            else {
                return nil
            }

            body.append(boundaryData)
            body.append(contentDispositionData)
            body.append(newLineData)

            if let mimeType = part.mimeType,
               let contentTypeData = MultipartHeaderBuilder.contentType(mimeType).data(using: .utf8) {
                body.append(contentTypeData)
                body.append(newLineData)
            }

            body.append(newLineData)
            body.append(part.data)
            body.append(newLineData)
        }

        guard let closingData = MultipartBoundaryBuilder.closing(boundary: boundary).data(using: .utf8) else {
            return nil
        }

        body.append(closingData)
        return body
    }
}
