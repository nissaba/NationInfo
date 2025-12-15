//
//  URLSessionProtocol.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

protocol URLSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
extension JSONDecoder: @unchecked Sendable {}
