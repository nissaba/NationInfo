//
//  FetchCountriesHandling.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//


protocol FetchCountriesHandling {
    func execute() async throws -> [CountryInfoListModel]
}
