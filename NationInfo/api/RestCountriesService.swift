//
//  RestCountriesService.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation


/// Abstraction for RestCountries API calls.
protocol RestCountriesService {
    /// Fetches all countries with basic info (name, flags).
    func fetchAllCountries() async throws -> [CountryInfoListModel]
    /// Fetches details (continents, population, capital) for a country name.
    func fetchCountryDetails(name: String) async throws -> CountryInfoModel
}
