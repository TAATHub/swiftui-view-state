import SwiftUI

struct FooterLoadingView: View {
    let isVisible: Bool
    let onTask: () async -> Void

    init(isVisible: Bool, onTask: @escaping () async -> Void) {
        self.isVisible = isVisible
        self.onTask = onTask
    }

    var body: some View {
        Group {
            if isVisible {
                VStack(alignment: .center) {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    Task {
                        await onTask()
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
}
