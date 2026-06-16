import SwiftUI

struct LegalDocumentScreen: View {
    let title: String
    let bodyText: String

    var body: some View {
        ScrollView {
            Text(bodyText)
                .font(.body)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
        }
        .screenChrome()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LegalDocumentScreen(title: "Privacy Policy", bodyText: LegalContent.privacyPolicy)
    }
}
