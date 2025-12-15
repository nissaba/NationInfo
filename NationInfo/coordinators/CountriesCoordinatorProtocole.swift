//
//  CountriesCoordinatorProtocole.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-15.
//

/// Navigation and error coordination for countries flows.
protocol CountriesCoordinatorProtocole: AnyObject {
    /// Pushes the details screen for a given country.
    func showDetails(for: CountryInfoListModel)
    /// Pops back in the navigation stack.
    func back()
    /// Presents an error message from view models.
    func showError(message: String)
}
