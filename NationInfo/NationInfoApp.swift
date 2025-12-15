//
//  NationInfoApp.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-13.
//

import SwiftUI

@main
struct NationInfoApp: App {
    @State private var coordinator = CountriesCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.rootView()
                    .navigationDestination(for: CountriesCoordinator.Route.self) { route in
                        coordinator.destination(for: route)
                    }
            }
            .alert(.error, isPresented: $coordinator.showErrorAlert) {
                Button(.ok, role: .cancel) { }
            } message: {
                Text(coordinator.errorMessage ?? String(localized: .genericError))
            }
        }
    }
}
