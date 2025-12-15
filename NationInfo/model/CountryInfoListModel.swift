//
//  CountryInfoListModel.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation

struct CountryInfoListModel: Identifiable, Equatable, Hashable {
    let id:UUID
    let name: String        // name.common
    let flagURL: URL?     // flags.png
    let flagAltText: String //alternate (utilise pour l'accessibilité)
    
    init(name: String, flagURL: URL?, flagAltText: String?) {
        self.id =  UUID()
        self.name = name
        self.flagURL = flagURL
        self.flagAltText = flagAltText ?? String(localized: .flagOfFormat(name))
    }
}
