//
//  FetchCountriesHandlerMock.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//


struct FetchCountriesHandlerMock: FetchCountriesHandling {
    let result: Result<[CountryInfoListModel], Error>

    func execute() async throws -> [CountryInfoListModel] {
        try result.get()
    }
}
