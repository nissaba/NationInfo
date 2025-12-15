//
//  CountriesCoordinator.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-15.
//

import SwiftUI

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

    var path = NavigationPath()
    var showErrorAlert = false
    var errorMessage: String?

    @ViewBuilder
    func rootView() -> some View {
        NationsListView(
            viewModel: NationsListViewModel(
                coordinator: self
            )
        )
    }

    func showDetails(for country: CountryInfoListModel) {
        path.append(Route.details(country))
    }

    func back() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func showError(message: String) {
        errorMessage = message
        showErrorAlert = true
    }

    @ViewBuilder
    func destination(for route: Route) -> some View {
        switch route {
        case .details(let country):
            NationInfoView(
                viewModel: NationInfoDetailsViewModel(
                    name: country.name,
                    flagUrl: country.flagURL,
                    coordinator: self
                )
            )
        }
    }
}
