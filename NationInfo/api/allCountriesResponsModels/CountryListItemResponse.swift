//
//  CountryListItemResponse.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

struct CountryListItemResponse: Decodable {
    let name: CountryNameResponse
    let flags: CountryFlagsResponse
}
