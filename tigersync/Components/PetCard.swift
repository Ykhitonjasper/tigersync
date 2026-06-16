import SwiftUI

public struct PetCard: View {
    public let pet: Pet
    public let logCount: Int
    public var isSelected = false

    private var petColor: Color { Color(hex: pet.colorHex) }

    public init(pet: Pet, logCount: Int, isSelected: Bool = false) {
        self.pet = pet
        self.logCount = logCount
        self.isSelected = isSelected
    }

    public var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    Circle()
                        .fill(petColor.opacity(0.15))
                        .frame(width: 56, height: 56)
                    Image(systemName: pet.species.icon)
                        .font(.title2)
                        .foregroundStyle(petColor)
                }

                if logCount > 0 {
                    Text("\(logCount)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(petColor)
                        .clipShape(Capsule())
                        .offset(x: 6, y: -4)
                }
            }

            VStack(spacing: 2) {
                Text(pet.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(pet.species.rawValue.capitalized)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 96)
        .cardSurface(padding: 14)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardRadius, style: .continuous)
                .strokeBorder(isSelected ? petColor : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    HStack {
        PetCard(pet: MockData.pets[0], logCount: 9, isSelected: true)
        PetCard(pet: MockData.pets[1], logCount: 9)
        PetCard(pet: MockData.pets[2], logCount: 0)
    }
    .padding()
}
