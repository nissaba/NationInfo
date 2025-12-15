//
//  CountryInfoModel.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

struct CountryInfoModel: Identifiable, Equatable {
    let id: UUID
    let name: String
    let flagURL: URL?
    let continents: [String]
    let population: Int
    let capital: [String]

    init(
        name: String,
        flagURL: URL? = nil,
        continents: [String],
        population: Int,
        capital: [String]
    ) {
        self.id = UUID()
        self.name = name
        self.flagURL = flagURL
        self.continents = continents
        self.population = population
        self.capital = capital
    }
}
