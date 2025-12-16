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
            .onChange(of: coordinator.path.count) { oldCount, newCount in
                if newCount < oldCount {
                    coordinator.notifyBackNavigation()
                } else if newCount > oldCount {
                    coordinator.notifyNavigationCompleted()
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

