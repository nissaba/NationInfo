//
//  CountryNameResponse.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation
struct CountryNameResponse: Decodable {
    let common: String
    let official: String
    let nativeName: [String: CountryNativeNameResponse]
}
