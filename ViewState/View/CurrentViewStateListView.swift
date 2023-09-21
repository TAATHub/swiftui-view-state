import SwiftUI

struct CurrentViewStateListView: View {
    @StateObject var viewModel: CurrentViewStateListViewModel = .init()
    
    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .idle(let items):
                listView(items: items, redacted: false)
            case .empty:
                emptyView
            case .progress(let items):
                listView(items: items, redacted: true)
            case .failure:
                failureView
            }
        }
        .task {
            await viewModel.onTask()
        }
        .refreshable {
            await viewModel.onRefresh()
        }
    }
    
    private func listView(items: [Item], redacted: Bool) -> some View {
        List {
            ForEach(items) { item in
                HStack(spacing: 16) {
                    Color.gray
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(item.text)
                    
                    Spacer()
                }
                .frame(height: 48)
                .listRowSeparator(.hidden)
            }
            
            FooterLoadingView(isVisible: viewModel.hasNextPage) {
                await viewModel.onScrollToEnd()
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .redacted(reason: redacted ? .placeholder : [])
    }
    
    private var emptyView: some View {
        Text("データがありません")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var failureView: some View {
        Text("エラーが発生しました")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
