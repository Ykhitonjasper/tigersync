import SwiftUI

extension View {
    func screenChrome() -> some View {
        ZStack {
            GlassBg()
            self
        }
    }
}
