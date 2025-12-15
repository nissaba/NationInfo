//
//  CountryNativeNameResponse.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

struct CountryNativeNameResponse: Decodable {
    let official: String
    let common: String
}
