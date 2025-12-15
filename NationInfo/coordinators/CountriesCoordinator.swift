//
//  CountriesCoordinator.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-15.
//

import SwiftUI

/// Concrete coordinator for the countries flow. Owns navigation path and builds views/view models.
@Observable
final class CountriesCoordinator: CountriesCoordinatorProtocole {

    enum Route: Hashable {
        case details(CountryInfoListModel)
        
        static func == (lhs: Route, rhs: Route) -> Bool {
            switch (lhs, rhs) {
            case let (.details(l), .details(r)):
                // Compare on stable identity; adjust if your model has a unique id
                return l.name == r.name && l.flagURL == r.flagURL
            }
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case let .details(model):
                hasher.combine("details")
                hasher.combine(model.name)
                hasher.combine(model.flagURL)
            }
        }
    }

    /// Current navigation path.
    var path = NavigationPath()
    /// Controls presentation of a global error alert.
    var showErrorAlert = false
    /// Message displayed in the global error alert.
    var errorMessage: String?

    /// Root view for the flow (countries list).
    @ViewBuilder
    func rootView() -> some View {
        NationsListView(
            viewModel: NationsListViewModel(
                coordinator: self
            )
        )
    }

    /// Pushes a details route.
    func showDetails(for country: CountryInfoListModel) {
        path.append(Route.details(country))
    }

    /// Pops the last route if available.
    func back() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    /// Presents an error message via root-level alert.
    func showError(message: String) {
        errorMessage = message
        showErrorAlert = true
    }

    /// Resolves a navigation route into a destination view.
    @ViewBuilder
    func destination(for route: Route) -> some View {
        switch route {
        case .details(let country):
            NationInfoView(
                viewModel: NationInfoDetailsViewModel(
                    name: country.name,
                    flagUrl: country.flagURL,
                    flagAltText: country.flagAltText,
                    coordinator: self
                )
            )
        }
    }
}
