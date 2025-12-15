//
//  FetchCountriesHandler.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//


struct FetchCountriesHandler: FetchCountriesHandling {

    let api: RestCountriesService

    init(api: RestCountriesService = RestCountriesAPI()) {
        self.api = api
    }

    func execute() async throws -> [CountryInfoListModel] {
        try await api.fetchAllCountries()
    }
}
