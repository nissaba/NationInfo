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
    
    @ObservationIgnored private var isNavigating = false
    @ObservationIgnored private var currentRouteKey: String?
    
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

    /// Builds the root view (countries list) and injects this coordinator into its view model.
    @ViewBuilder
    func rootView() -> some View {
        NationsListView(
            viewModel: NationsListViewModel(
                coordinator: self
            )
        )
    }

    /// Pushes the details screen for the given country.
    /// Applies guards to avoid duplicate or concurrent navigations by comparing a stable route key.
    func showDetails(for country: CountryInfoListModel) {
        //Prevent call from showing same navigation more than once
        let routeKey = "details:\(country.name)"
        guard isNavigating == false, currentRouteKey != routeKey else {
            return
        }
        
        isNavigating = true
        currentRouteKey = routeKey
        
        path.append(Route.details(country))            
        
    }
    
    /// Marks the end of a navigation transition, re-enabling subsequent navigations.
    func notifyNavigationCompleted() {
        isNavigating = false
    }
    
    /// Should be called when a back navigation occurs from a destination.
    /// Updates the current route key (cleared at root) and resets the navigation guard.
    func notifyBackNavigation() {
        currentRouteKey = path.isEmpty ? nil : currentRouteKey
        isNavigating = false
    }

    /// Pops the last route from the navigation stack if present.
    /// Clears the current route key when returning to root and resets the navigation guard.
    func back() {
        if !path.isEmpty {
            path.removeLast()
        }
        if path.isEmpty {
            currentRouteKey = nil
        }
        isNavigating = false
    }

    /// Presents a global error message via an alert at the root of the flow.
    func showError(message: String) {
        errorMessage = message
        showErrorAlert = true
    }

    /// Resolves a `Route` into a destination view for use with `NavigationStack`.
    /// Instantiates the appropriate view model and injects this coordinator.
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

