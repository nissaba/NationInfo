//
//  CountriesCoordinatorTests.swift
//  NationInfoTests
//
//  Created by Pascale on 2025-12-15.
//

import SwiftUI
import Testing
@testable import NationInfo

@MainActor
struct CountriesCoordinatorTests {

    @Test func showDetails_appendsRoute() {
        // showDetails should push a details route onto the navigation path.
        let coordinator = CountriesCoordinator()
        let country = CountryInfoListModel(name: "France", flagURL: nil, flagAltText: nil)

        #expect(coordinator.path.count == 0)
        coordinator.showDetails(for: country)
        #expect(coordinator.path.count == 1)
    }

    @Test func back_popsRoute() {
        // back should remove the last route when present.
        let coordinator = CountriesCoordinator()
        let country = CountryInfoListModel(name: "France", flagURL: nil, flagAltText: nil)
        coordinator.showDetails(for: country)

        coordinator.back()

        #expect(coordinator.path.count == 0)
    }

    @Test func showError_setsAlertState() {
        // showError should set alert state and message for root-level alert presentation.
        let coordinator = CountriesCoordinator()

        coordinator.showError(message: "Une erreur est survenue")

        #expect(coordinator.showErrorAlert == true)
        #expect(coordinator.errorMessage == "Une erreur est survenue")
    }
}
