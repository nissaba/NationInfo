//
//  NationsListViewModel.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-13.
//

import Foundation

/// View model for the list of nations, fetching data and delegating navigation/errors to the coordinator.
@Observable
class NationsListViewModel {
    
    var countries: [CountryInfoListModel] = []
    var pageName: String = ""
    var searchCriterion : String = "" {
        didSet{
            if searchCriterion != oldValue {
                applySearch(searchCriterion)
            }
        }
    }
    
    @ObservationIgnored var searchPlaceHolderText = String(localized: .countrySearchPlaceholder)
    
    @ObservationIgnored var internalCountryList: [CountryInfoListModel] = []
    @ObservationIgnored private let fetchCountiresHandler: FetchCountriesHandling
    @ObservationIgnored private weak var coordinator: CountriesCoordinatorProtocole?
    
    /// Creates a view model for the nations list.
    /// - Parameters:
    ///   - countriesHandler: Use case to fetch the countries list.
    ///   - coordinator: Coordinator handling navigation and errors.
    init(
        countriesHandler: FetchCountriesHandling = FetchCountriesHandler(),
        coordinator: CountriesCoordinatorProtocole? = nil
    ) {
        self.fetchCountiresHandler = countriesHandler
        self.coordinator = coordinator
        pageName = String(localized: .countriesList)
    }
    
    /// Loads countries and sorts them by name; shows an error via coordinator on failure.
    func loadCountries() async {
        do {
            let unsorted = try await fetchCountiresHandler.execute()
            internalCountryList = unsorted.sorted { lhs, rhs in
                lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
            }
            countries = internalCountryList
        } catch {
            coordinator?.showError(message: userFriendlyMessage(for: error))
        }
    }

    /// Notifies coordinator to show details for the selected country.
    func didSelect(country: CountryInfoListModel) {
        coordinator?.showDetails(for: country)
    }

    /// Updates the countries collection to match the filered liste. if text is empty then show full list
    func applySearch(_ text: String) {
        if text.isEmpty {
            countries = internalCountryList
        }else {
            countries = internalCountryList.filter { $0.name.lowercased().contains(text.lowercased()) }
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

