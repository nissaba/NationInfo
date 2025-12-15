//
//  CountryFlagsResponse.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

struct CountryFlagsResponse: Decodable {
    let png: String
    let svg: String
    let alt: String?
}
