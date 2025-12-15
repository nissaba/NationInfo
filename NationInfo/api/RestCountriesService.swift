//
//  RestCountriesService.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation


protocol RestCountriesService {
    func fetchAllCountries() async throws -> [CountryInfoListModel]
    func fetchCountryDetails(name: String) async throws -> CountryInfoModel
}
