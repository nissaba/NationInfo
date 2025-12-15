import SwiftUI

struct CountryInfoCard: View {
    let countryName: String
    let continent: String
    let population: Int
    let flagUrl: URL?
    let flagAltText: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 12) {
                // Flag
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.red.opacity(0.15))
                AsyncImage(url: flagUrl) { phase in
                    switch phase {
                    case .empty: ProgressView()
                    case .success(let image): image.resizable().scaledToFit()
                    case .failure: Image(systemName: "flag.slash")
                        @unknown default: EmptyView()
                        }
                    }
                    .frame(width: 40, height: 24)
                }
                .frame(width: 56, height: 40)
                .accessibilityLabel(Text(flagAltText ?? String(localized: "flag_of_format", comment: "default flag accessibility label")))

                // Name
                Text(countryName)
                    .font(.title2.bold())
                    .foregroundStyle(.primary)

                Spacer()
            }

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                infoRow(icon: "globe.europe.africa.fill", title: "Continent", value: continent)
                infoRow(icon: "person.3.fill", title: "Population", value: formattedPopulation(population))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.background)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
        .padding()
    }

    // MARK: - Helpers

    @ViewBuilder
    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))

            Text(title + ":")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(value)
                .font(.subheadline)
                .foregroundStyle(.primary)

            Spacer()
        }
    }

    private func formattedPopulation(_ count: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: count)) ?? "\(count)"
    }
}

#Preview {
    let url = URL(string: "https://flagcdn.com/w320/bt.png")
    ScrollView {
        CountryInfoCard(
            countryName: "Country Name",
            continent: "Continent",
            population: 98_347,
            flagUrl: url,
            flagAltText: "Drapeau de test"
        )
    }
    .background(Color(.systemGroupedBackground))
}
