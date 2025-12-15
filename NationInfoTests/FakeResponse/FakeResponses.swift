//
//  FakeResponses.swift
//  NationInfoTests
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

enum FakeResponses {
    static let allCountriesSuccess = """
    [
      {
        "cca2": "FR",
        "name": {
          "common": "France",
          "official": "French Republic",
          "nativeName": {
            "fra": { "official": "République française", "common": "France" }
          }
        },
        "flags": {
          "png": "https://flagcdn.com/fr.png",
          "svg": "https://flagcdn.com/fr.svg",
          "alt": "The flag of France"
        }
      },
      {
        "cca2": "JP",
        "name": {
          "common": "Japan",
          "official": "Japan",
          "nativeName": {
            "jpn": { "official": "日本", "common": "日本" }
          }
        },
        "flags": {
          "png": "https://flagcdn.com/jp.png",
          "svg": "https://flagcdn.com/jp.svg",
          "alt": "The flag of Japan"
        }
      }
    ]
    """

    static let invalidJSON = "{ this is not valid json }"

    static let emptyArray = "[]"

    static let missingAlt = """
    [
      {
        "cca2": "DE",
        "name": {
          "common": "Germany",
          "official": "Federal Republic of Germany",
          "nativeName": {
            "deu": { "official": "Bundesrepublik Deutschland", "common": "Deutschland" }
          }
        },
        "flags": {
          "png": "https://flagcdn.com/de.png",
          "svg": "https://flagcdn.com/de.svg"
        }
      }
    ]
    """

    static let invalidFlagURL = """
    [
      {
        "cca2": "XX",
        "name": { "common": "Example", "official": "Example", "nativeName": {} },
        "flags": {
          "png": "not-a-valid-url",
          "svg": "https://flagcdn.com/xx.svg",
          "alt": "Flag alt text"
        }
      }
    ]
    """

    static let countryDetailsSuccess = """
    [
      {
        "continents": ["Europe"],
        "population": 67000000,
        "capital": ["Paris"]
      }
    ]
    """
}
