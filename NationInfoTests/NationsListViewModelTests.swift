//
//  NationsListViewModelTests.swift
//  NationInfoTests
//
//  Created by Pascale on 2025-12-14.
//

import Foundation
import Testing
@testable import NationInfo

@MainActor
struct NationsListViewModelTests {

    @Test func loadCountries_success_usesMockHandler() async throws {
        let mockCountries = [
            CountryInfoListModel(name: "France", flagURL: nil, flagAltText: nil)
        ]
        let handler = FetchCountriesHandlerMock(result: .success(mockCountries))
        let coordinator = CoordinatorSpy()
        let vm = NationsListViewModel(countriesHandler: handler, coordinator: coordinator)

        await vm.loadCountries()

        #expect(vm.countries == mockCountries)
        #expect(coordinator.lastError == nil)
    }

    @Test func loadCountries_failure_setsErrorMessage() async throws {
        let handler = FetchCountriesHandlerMock(result: .failure(URLError(.notConnectedToInternet)))
        let coordinator = CoordinatorSpy()
        let vm = NationsListViewModel(countriesHandler: handler, coordinator: coordinator)

        await vm.loadCountries()

        #expect(vm.countries.isEmpty)
        #expect(coordinator.lastError != nil)
    }

    @Test func didSelect_invokesCoordinator() async throws {
        let handler = FetchCountriesHandlerMock(result: .success([]))
        let coordinator = CoordinatorSpy()
        let vm = NationsListViewModel(countriesHandler: handler, coordinator: coordinator)
        let country = CountryInfoListModel(name: "Test", flagURL: nil, flagAltText: nil)

        vm.didSelect(country: country)

        #expect(coordinator.lastSelected == country)
    }
}

private final class CoordinatorSpy: CountriesCoordinatorProtocole {
    var lastSelected: CountryInfoListModel?
    var lastError: String?

    func showDetails(for country: CountryInfoListModel) {
        lastSelected = country
    }

    func showError(message: String) {
        lastError = message
    }

    func back() { }
}
