//
//  FetchCountryDetailsHandler.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

struct FetchCountryDetailsHandler: FetchCountryDetailsHandling {
    let api: RestCountriesService

    init(api: RestCountriesService = RestCountriesAPI()) {
        self.api = api
    }

    func execute(name: String) async throws -> CountryInfoModel {
        try await api.fetchCountryDetails(name: name)
    }
}
