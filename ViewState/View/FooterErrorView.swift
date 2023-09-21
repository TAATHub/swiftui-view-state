import SwiftUI

struct FooterErrorView: View {
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
                    Button {
                        Task {
                            await onTask()
                        }
                    } label: {
                        Text("再読み込み")
                            .foregroundStyle(Color.blue)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                EmptyView()
            }
        }
    }
}
