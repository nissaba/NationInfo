//
//  NationsListView.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-13.
//

import Foundation
import SwiftUI

struct NationsListView: View {
    @State var vm: NationsListViewModel
    
    init(viewModel: NationsListViewModel) {
        _vm = State(initialValue: viewModel)
    }
    
    var body : some View{
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            VStack{
                Text(vm.pageName)
                List(vm.countries, id:\.id){ item in
                    CountryInfoListCell(
                        name: item.name,
                        flagUrl: item.flagURL,
                        flagAltText: item.flagAltText
                    ){
                        vm.didSelect(country: item)
                    }
                    .contentShape(Rectangle())
                }
                .listStyle(.plain)
                .padding(.bottom)
            }
        }
        .task{
            await vm.loadCountries()
        }
    }
}

#Preview{
    NationsListView(viewModel: NationsListViewModel())
}
