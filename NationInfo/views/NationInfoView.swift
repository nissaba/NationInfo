//
//  NationInfoView.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import SwiftUI

struct NationInfoView: View {
    @State var viewModel: NationInfoDetailsViewModel

    init(viewModel: NationInfoDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isDataLoaded {
                VStack {
                    CountryInfoCard(
                        countryName: viewModel.name,
                        continent: viewModel.continent,
                        population: viewModel.population,
                        flagUrl: viewModel.flagUrl,
                        flagAltText: viewModel.flagAltText
                    )
                    Spacer()
                }
            } else {
                ProgressView()
            }
        }
        .task {[weak viewModel] in
            await viewModel?.loadDetails()
        }
        .navigationTitle(String(localized: .countryInfo))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let url = URL(string: "https://flagcdn.com/w320/bt.png")
    NavigationStack {
        NationInfoView(viewModel: NationInfoDetailsViewModel(name: "Nom du pays", flagUrl: url))
    }
    .background(Color(.systemGroupedBackground))
}
