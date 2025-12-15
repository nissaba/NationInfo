//
//  NationInfoDetailsViewModel.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-15.
//

import Foundation

/// View model for country details; fetches details and reports errors through the coordinator.
@Observable
class NationInfoDetailsViewModel {
    var name: String
    var flagUrl: URL?
    var flagAltText: String?
    var population: Int = 0
    var continent: String = ""
    var capital: String = ""
    var isDataLoaded: Bool = false
    
    @ObservationIgnored private let countryInfoHandler: FetchCountryDetailsHandling
    @ObservationIgnored private weak var coordinator: CountriesCoordinatorProtocole?
    
    /// Creates a details view model.
    /// - Parameters:
    ///   - name: Country name to fetch details for.
    ///   - flagUrl: Optional flag URL passed from the list.
    ///   - flagAltText: Optional accessibility text for the flag.
    ///   - countryInfoHandler: Use case for fetching details.
    ///   - coordinator: Coordinator to report errors to.
    init(
        name: String,
        flagUrl: URL? = nil,
        flagAltText: String? = nil,
        countryInfoHandler: FetchCountryDetailsHandling = FetchCountryDetailsHandler(),
        coordinator: CountriesCoordinatorProtocole? = nil
    ) {
        self.countryInfoHandler = countryInfoHandler
        self.name = name
        self.flagUrl = flagUrl
        self.flagAltText = flagAltText
        self.coordinator = coordinator
    }
    
    /// Loads details; on failure routes a friendly message to the coordinator.
    func loadDetails() async {
        isDataLoaded = false
        do {
            let country = try await countryInfoHandler.execute(name: name)
            population = country.population
            continent = country.continents.first ?? ""
            capital = country.capital.first ?? ""
            isDataLoaded = true
        } catch {
            coordinator?.showError(message: userFriendlyMessage(for: error))
        }
    }

    private func userFriendlyMessage(for error: Error) -> String {
        if let apiError = error as? RestCountriesAPIError {
            switch apiError {
            case .invalidURL:
                return String(localized: .invalidUrlErrorMessage)
            case .invalidResponse:
                return String(localized: .invalidServerResponse)
            case .httpStatus(let code):
                return String(localized: .httpServerErrorMessage(code))
            case .decodingFailed:
                return String(localized: .invalidDataRecieved)
            case .transport(let underlying):
                if let urlError = underlying as? URLError {
                    return urlError.localizedDescription
                }
                return underlying.localizedDescription
            }
        }
        return error.localizedDescription
    }
}
