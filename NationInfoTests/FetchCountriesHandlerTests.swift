//
//  FetchCountriesHandlerTests.swift
//  NationInfoTests
//
//  Created by Pascale on 2025-12-14.
//

import Foundation
import Testing
@testable import NationInfo

@MainActor
struct FetchCountriesHandlerTests {

    @Test func execute_returnsCountries() async throws {
        // Handler should forward successful service result untouched.
        let expected = [
            CountryInfoListModel(name: "France", flagURL: nil, flagAltText: nil)
        ]
        let service = MockRestCountriesService(result: .success(expected))
        let handler = FetchCountriesHandler(api: service)

        let countries = try await handler.execute()

        #expect(countries == expected)
    }

    @Test func execute_propagatesError() async throws {
        // Handler should propagate service errors.
        enum SampleError: Error { case fail }
        let service = MockRestCountriesService(result: .failure(SampleError.fail))
        let handler = FetchCountriesHandler(api: service)

        do {
            _ = try await handler.execute()
            Issue.record("Expected error to propagate")
        } catch let error as SampleError {
            #expect(error == .fail)
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test func countryDetailsHandler_returnsDetails() async throws {
        // Details handler should forward the service result unchanged.
        let expected = await MainActor.run { () -> CountryInfoModel in
            CountryInfoModel(
                continents: ["Europe"],
                population: 67000000,
                capital: ["Paris"]
            )
        }
        let service = MockRestCountriesService(
            allCountriesResult: .success([]),
            countryDetailsResult: .success(expected)
        )
        let handler = FetchCountryDetailsHandler(api: service)

        let details = try await handler.execute(name: "france")

        #expect(details == expected)
    }

    @Test func countryDetailsHandler_propagatesError() async throws {
        // Details handler should propagate errors thrown by the service.
        enum SampleError: Error { case fail }
        let service = MockRestCountriesService(
            allCountriesResult: .success([]),
            countryDetailsResult: .failure(SampleError.fail)
        )
        let handler = FetchCountryDetailsHandler(api: service)

        do {
            _ = try await handler.execute(name: "france")
            Issue.record("Expected error to propagate")
        } catch let error as SampleError {
            #expect(error == .fail)
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}

private struct MockRestCountriesService: RestCountriesService {
    let allCountriesResult: Result<[CountryInfoListModel], Error>
    let countryDetailsResult: Result<CountryInfoModel, Error>

    init(
        result: Result<[CountryInfoListModel], Error>
    ) {
        self.allCountriesResult = result
        self.countryDetailsResult = .failure(URLError(.badURL))
    }

    init(
        allCountriesResult: Result<[CountryInfoListModel], Error>,
        countryDetailsResult: Result<CountryInfoModel, Error>
    ) {
        self.allCountriesResult = allCountriesResult
        self.countryDetailsResult = countryDetailsResult
    }

    func fetchAllCountries() async throws -> [CountryInfoListModel] {
        try allCountriesResult.get()
    }

    func fetchCountryDetails(name: String) async throws -> CountryInfoModel {
        try countryDetailsResult.get()
    }
}
