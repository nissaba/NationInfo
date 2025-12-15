//
//  FetchCountryDetailsHandlerMock.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

struct FetchCountryDetailsHandlerMock: FetchCountryDetailsHandling {
    let result: Result<CountryInfoModel, Error>

    func execute(name: String) async throws -> CountryInfoModel {
        try result.get()
    }
}
