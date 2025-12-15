//
//  NationsListViewModel.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-13.
//

import Foundation

@Observable
class NationsListViewModel {
    
    var countries: [CountryInfoListModel] = []
    var pageName: String = ""
    
    @ObservationIgnored private let fetchCountiresHandler: FetchCountriesHandling
    @ObservationIgnored private weak var coordinator: CountriesCoordinatorProtocole?
    
    init(
        countriesHandler: FetchCountriesHandling = FetchCountriesHandler(),
        coordinator: CountriesCoordinatorProtocole? = nil
    ) {
        self.fetchCountiresHandler = countriesHandler
        self.coordinator = coordinator
        pageName = String(localized: "Liste de pays", comment:"la liste des pays")
    }
    
    func loadCountries() async {
        do {
            let unsorted = try await fetchCountiresHandler.execute()
            countries = unsorted.sorted { lhs, rhs in
                lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
        } catch {
            coordinator?.showError(message: userFriendlyMessage(for: error))
        }
    }

    func didSelect(country: CountryInfoListModel) {
        coordinator?.showDetails(for: country)
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
