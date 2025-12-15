//
//  CountriesCoordinatorProtocole.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-15.
//

protocol CountriesCoordinatorProtocole: AnyObject {
    func showDetails(for: CountryInfoListModel)
    func back()
    func showError(message: String)
}
