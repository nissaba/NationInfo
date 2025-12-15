//
//  CountryDetailsResponse.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

struct CountryDetailsResponse: Decodable {
    let continents: [String]
    let population: Int
    let capital: [String]?
}
