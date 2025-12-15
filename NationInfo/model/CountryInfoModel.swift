//
//  CountryInfoModel.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

struct CountryInfoModel: Identifiable, Equatable {
    let id: UUID
    let continents: [String]
    let population: Int
    let capital: [String]

    init(
        continents: [String],
        population: Int,
        capital: [String]
    ) {
        self.id = UUID()
        self.continents = continents
        self.population = population
        self.capital = capital
    }
}
