//
//  NationInfoDetailsViewModel.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-15.
//

import Foundation

@Observable
class NationInfoDetailsViewModel {
    var name: String
    var flagUrl: URL?
    var population: Int = 0
    var continent: String = ""
    var capital: String = ""
    var isDataLoaded: Bool = false
    
    @ObservationIgnored private let countryInfoHandler: FetchCountryDetailsHandling
    @ObservationIgnored private weak var coordinator: CountriesCoordinatorProtocole?
    
    init(
        name: String,
        flagUrl: URL? = nil,
        countryInfoHandler: FetchCountryDetailsHandling = FetchCountryDetailsHandler(),
        coordinator: CountriesCoordinatorProtocole? = nil
    ) {
        self.countryInfoHandler = countryInfoHandler
        self.name = name
        self.flagUrl = flagUrl
        self.coordinator = coordinator
    }
    
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
                return String(localized: "La configuration du service est invalide.", comment: "invalid url error message")
            case .invalidResponse:
                return String(localized: "Réponse du serveur invalide.", comment: "invalid response error message")
            case .httpStatus(let code):
                return String(localized: "Le serveur a retourné une erreur (\(code)).", comment: "http status error message")
            case .decodingFailed:
                return String(localized: "Les données reçues sont invalides.", comment: "decoding error message")
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
