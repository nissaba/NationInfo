//
//  CountryInfoListCell.swift
//  NationInfo
//
//  Created by Pascale on 2025-12-14.
//

import Foundation
import SwiftUI

struct CountryInfoListCell: View {
    let name: String
    let flagUrl: URL?
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                AsyncImage(url: flagUrl) { phase in
                    switch phase {
                    case .empty: ProgressView()
                    case .success(let image): image.resizable().scaledToFit()
                    case .failure: Image(systemName: "flag.slash")
                    @unknown default: EmptyView()
                    }
                }
                .frame(width: 40, height: 24)

                Text(name)
                    .lineLimit(1)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}


#Preview{
    let url = URL(string: "https://flagcdn.com/w320/bt.png")
    return CountryInfoListCell(name: "Test", flagUrl: url!, onTap: { print("Tapped preview cell") })
}
