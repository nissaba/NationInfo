//
//  RestCountriesAPITests.swift
//  NationInfoTests
//
//  Created by Pascale on 2025-12-14.
//

import Foundation
import Testing
@testable import NationInfo

@MainActor
struct RestCountriesAPITests {

    @Test func fetchAllCountries_success() async throws {
        // Given a valid payload, the client should decode and map list items with flag URLs and alt text.
        let data = Data(FakeResponses.allCountriesSuccess.utf8)
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com/v3.1/all")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let session = MockSession(result: .success((data, response)))
        let api = RestCountriesAPI(session: session, baseURL: URL(string: "https://example.com")!)

        let countries = try await api.fetchAllCountries()

        #expect(!countries.isEmpty)
        let first = try #require(countries.first)
        #expect(first.name == "France")
        #expect(first.flagURL == URL(string: "https://flagcdn.com/fr.png"))
        #expect(first.flagAltText == "The flag of France")
    }

    @Test func fetchAllCountries_emptyArray() async throws {
        // Given an empty payload, the client should return an empty list without throwing.
        let data = Data(FakeResponses.emptyArray.utf8)
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com/v3.1/all")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let session = MockSession(result: .success((data, response)))
        let api = RestCountriesAPI(session: session, baseURL: URL(string: "https://example.com")!)

        let countries = try await api.fetchAllCountries()

        #expect(countries.isEmpty)
    }

    @Test func fetchAllCountries_missingAlt() async throws {
        // Missing optional alt text should decode to nil, not fail decoding.
        let data = Data(FakeResponses.missingAlt.utf8)
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com/v3.1/all")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let session = MockSession(result: .success((data, response)))
        let api = RestCountriesAPI(session: session, baseURL: URL(string: "https://example.com")!)

        let countries = try await api.fetchAllCountries()

        let first = try #require(countries.first)
        #expect(first.flagAltText == nil)
    }

    @Test func fetchAllCountries_invalidFlagURL() async throws {
        // An invalid flag URL string should be treated as nil after validation.
        let data = Data(FakeResponses.invalidFlagURL.utf8)
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com/v3.1/all")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let session = MockSession(result: .success((data, response)))
        let api = RestCountriesAPI(session: session, baseURL: URL(string: "https://example.com")!)

        let countries = try await api.fetchAllCountries()

        let first = try #require(countries.first)
        #expect(first.flagURL == nil)
    }

    @Test func fetchCountryDetails_success() async throws {
        // Details endpoint should decode continents/population/capital correctly.
        let data = Data(FakeResponses.countryDetailsSuccess.utf8)
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com/v3.1/name/france")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let session = MockSession(result: .success((data, response)))
        let api = RestCountriesAPI(session: session, baseURL: URL(string: "https://example.com")!)

        let details = try await api.fetchCountryDetails(name: "france")

        #expect(details.continents == ["Europe"])
        #expect(details.population == 67000000)
        #expect(details.capital == ["Paris"])
    }

    @Test func fetchCountryDetails_httpError() async throws {
        // Non-2xx HTTP status should surface as httpStatus error.
        let data = Data()
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com/v3.1/name/france")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!
        let session = MockSession(result: .success((data, response)))
        let api = RestCountriesAPI(session: session, baseURL: URL(string: "https://example.com")!)

        do {
            _ = try await api.fetchCountryDetails(name: "france")
            Issue.record("Expected HTTP error")
        } catch let error as RestCountriesAPIError {
            if case .httpStatus(404) = error { return }
            Issue.record("Unexpected error: \(error)")
        } catch {
            Issue.record("Unexpected non-API error: \(error)")
        }
    }

    @Test func fetchCountryDetails_decodingError() async throws {
        // Bad JSON should surface as decodingFailed error.
        let data = Data(FakeResponses.invalidJSON.utf8)
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com/v3.1/name/france")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let session = MockSession(result: .success((data, response)))
        let api = RestCountriesAPI(session: session, baseURL: URL(string: "https://example.com")!)

        do {
            _ = try await api.fetchCountryDetails(name: "france")
            Issue.record("Expected decoding error")
        } catch let error as RestCountriesAPIError {
            if case .decodingFailed = error { return }
            Issue.record("Unexpected error: \(error)")
        } catch {
            Issue.record("Unexpected non-API error: \(error)")
        }
    }

    @Test func fetchCountryDetails_invalidURL() async throws {
        // Nil base URL should cause invalidURL error before network is hit.
        let session = MockSession(result: .failure(URLError(.badURL)))
        let api = RestCountriesAPI(session: session, baseURL: nil)

        do {
            _ = try await api.fetchCountryDetails(name: "france")
            Issue.record("Expected invalid URL error")
        } catch let error as RestCountriesAPIError {
            if case .invalidURL = error { return }
            Issue.record("Unexpected error: \(error)")
        } catch {
            Issue.record("Unexpected non-API error: \(error)")
        }
    }

    @Test func fetchAllCountries_httpError() async throws {
        let data = Data()
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com/v3.1/all")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!
        let session = MockSession(result: .success((data, response)))
        let api = RestCountriesAPI(session: session, baseURL: URL(string: "https://example.com")!)

        do {
            _ = try await api.fetchAllCountries()
            Issue.record("Expected to throw for non-2xx status")
        } catch let error as RestCountriesAPIError {
            if case .httpStatus(500) = error {
                return
            }
            Issue.record("Unexpected error: \(error)")
        } catch {
            Issue.record("Unexpected non-API error: \(error)")
        }
    }

    @Test func fetchAllCountries_nonHTTPResponse() async throws {
        let data = Data()
        let response = URLResponse(
            url: URL(string: "https://example.com/v3.1/all")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        let session = MockSession(result: .success((data, response)))
        let api =  RestCountriesAPI(session: session, baseURL: URL(string: "https://example.com")!)

        do {
            _ = try await api.fetchAllCountries()
            Issue.record("Expected to throw for invalid response type")
        } catch let error as RestCountriesAPIError {
            if case .invalidResponse = error { return }
            Issue.record("Unexpected error: \(error)")
        } catch {
            Issue.record("Unexpected non-API error: \(error)")
        }
    }

    @Test func fetchAllCountries_decodingError() async throws {
        let data = Data(FakeResponses.invalidJSON.utf8)
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com/v3.1/all")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let session = MockSession(result: .success((data, response)))
        let api =  RestCountriesAPI(session: session, baseURL: URL(string: "https://example.com")!)

        do {
            _ = try await api.fetchAllCountries()
            Issue.record("Expected to throw for decoding failure")
        } catch let error as RestCountriesAPIError {
            if case .decodingFailed = error { return }
            Issue.record("Unexpected error: \(error)")
        } catch {
            Issue.record("Unexpected non-API error: \(error)")
        }
    }

    @Test func fetchAllCountries_transportError() async throws {
        let session = MockSession(result: .failure(URLError(.notConnectedToInternet)))
        let api =  RestCountriesAPI(session: session, baseURL: URL(string: "https://example.com")!)

        do {
            _ = try await api.fetchAllCountries()
            Issue.record("Expected to throw for transport error")
        } catch let error as RestCountriesAPIError {
            if case .transport = error { return }
            Issue.record("Unexpected error: \(error)")
        } catch {
            Issue.record("Unexpected non-API error: \(error)")
        }
    }

    @Test func fetchAllCountries_invalidURL() async throws {
        let session = MockSession(result: .failure(URLError(.badURL)))
        let api = RestCountriesAPI(session: session, baseURL: nil)

        do {
            _ = try await api.fetchAllCountries()
            Issue.record("Expected to throw for invalid URL")
        } catch let error as RestCountriesAPIError {
            if case .invalidURL = error { return }
            Issue.record("Unexpected error: \(error)")
        } catch {
            Issue.record("Unexpected non-API error: \(error)")
        }
    }
}

private struct MockSession: URLSessionProtocol, @unchecked Sendable {
    let result: Result<(Data, URLResponse), Error>

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try result.get()
    }
}

private func loadFixture(named name: String) throws -> Data {
    let testsDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()

    // Prefer a local test fixture if present.
    let localFixture = testsDirectory
        .appendingPathComponent("Fixtures")
        .appendingPathComponent(name)
    if FileManager.default.fileExists(atPath: localFixture.path) {
        return try Data(contentsOf: localFixture)
    }

    // Fallback to shared resources (e.g., provided fake data under app resources).
    let sharedFixture = testsDirectory
        .deletingLastPathComponent()
        .appendingPathComponent("NationInfo")
        .appendingPathComponent("ressources")
        .appendingPathComponent(name)
    return try Data(contentsOf: sharedFixture)
}
