//
//  RestCountriesAPI.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

enum RestCountriesAPIError: Error {
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decodingFailed(Error)
    case transport(Error)
}

struct RestCountriesAPI: RestCountriesService, Sendable {
    private let session: URLSessionProtocol
    private let decoder: JSONDecoder
    private let baseURL: URL?

    init(
        session: URLSessionProtocol = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        baseURL: URL? = URL(string: "https://restcountries.com")
    ) {
        self.session = session
        self.decoder = decoder
        self.baseURL = baseURL
    }

    func fetchAllCountries() async throws -> [CountryInfoListModel] {
        guard let url = Self.makeAllCountriesURL(baseURL: baseURL) else {
            throw RestCountriesAPIError.invalidURL
        }

        let request = URLRequest(url: url)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw RestCountriesAPIError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw RestCountriesAPIError.httpStatus(httpResponse.statusCode)
            }

            let responseItems: [CountryListItemResponse]
            do {
                responseItems = try decoder.decode([CountryListItemResponse].self, from: data)
            } catch {
                throw RestCountriesAPIError.decodingFailed(error)
            }

            return responseItems.map { CountryInfoListModel(
                name: $0.name.common,
                flagURL: URL(string: $0.flags.png),
                flagAltText: $0.flags.alt
            )}
        } catch let apiError as RestCountriesAPIError {
            throw apiError
        } catch {
            throw RestCountriesAPIError.transport(error)
        }
    }

    func fetchCountryDetails(name: String) async throws -> CountryInfoModel {
        guard let url = Self.makeCountryDetailsURL(baseURL: baseURL, name: name) else {
            throw RestCountriesAPIError.invalidURL
        }

        let request = URLRequest(url: url)

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw RestCountriesAPIError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw RestCountriesAPIError.httpStatus(httpResponse.statusCode)
            }

            let responseItems: [CountryDetailsResponse]
            do {
                responseItems = try decoder.decode([CountryDetailsResponse].self, from: data)
            } catch {
                throw RestCountriesAPIError.decodingFailed(error)
            }

            guard let first = responseItems.first else {
                throw RestCountriesAPIError.invalidResponse
            }

            return CountryInfoModel(
                name: name,
                flagURL: nil,
                continents: first.continents,
                population: first.population,
                capital: first.capital ?? []
            )
        } catch let apiError as RestCountriesAPIError {
            throw apiError
        } catch {
            throw RestCountriesAPIError.transport(error)
        }
    }

    private static func makeAllCountriesURL(baseURL: URL?) -> URL? {
        guard let baseURL else { return nil }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = "/v3.1/all"
        components?.queryItems = [
            URLQueryItem(name: "fields", value: "cca2,name,flags")
        ]
        return components?.url
    }

    private static func makeCountryDetailsURL(baseURL: URL?, name: String) -> URL? {
        guard let baseURL else { return nil }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = "/v3.1/name/\(name)"
        components?.queryItems = [
            URLQueryItem(name: "fields", value: "continents,population,capital")
        ]
        return components?.url
    }
}
