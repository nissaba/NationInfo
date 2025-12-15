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
            .alert("Erreur", isPresented: $coordinator.showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(coordinator.errorMessage ?? String(localized: "Une erreur est survenue.", comment: "generic error message"))
            }
        }
    }
}
