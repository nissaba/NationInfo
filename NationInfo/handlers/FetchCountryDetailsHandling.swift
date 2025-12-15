//
//  FetchCountryDetailsHandling.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

protocol FetchCountryDetailsHandling {
    func execute(name: String) async throws -> CountryInfoModel
}
