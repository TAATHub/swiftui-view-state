import SwiftUI

struct NewViewStateListView: View {
    @StateObject var viewModel: NewViewStateListViewModel = .init()
    
    var body: some View {
        let _ = Self._printChanges()
        
        GeometryReader { proxy in
            List {
                switch viewModel.viewState {
                // .refreshingを別のcaseで書くと、refreshableがidleでない時に変更が起きてしまう
                case .success(let items), .refreshing(let items), .paging(let items):
                    listView(items: items, redacted: false)
                    footerLoadingView()
                case .pagingFailure(let items):
                    listView(items: items, redacted: false)
                    footerErrorView()
                case .empty:
                    emptyView(proxy)
                case .loading(let items):
                    listView(items: items, redacted: true)
                    // ローディングインジケーターが良い場合はこちら
//                    loadingView(proxy)
                case .failure:
                    failureView(proxy)
                }
            }
            .listStyle(.plain)
            .task {
                await viewModel.onTask()
            }
            .refreshable {
                await viewModel.onRefresh()
            }
        }
    }
    
    private func loadingView(_ proxy: GeometryProxy) -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .frame(width: proxy.size.width, height: proxy.size.height)
    }
    
    private func listView(items: [Item], redacted: Bool) -> some View {
        ForEach(items) { item in
            HStack(spacing: 16) {
                Color.gray
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text(item.text)
                
                Spacer()
            }
            .frame(height: 48)
        }
        .listRowSeparator(.hidden)
        .redacted(reason: redacted ? .placeholder : [])
    }
    
    private func footerLoadingView() -> some View {
        FooterLoadingView(isVisible: viewModel.hasNextPage) {
            await viewModel.onPaging()
        }
        .id(UUID())
        .listRowSeparator(.hidden)
    }
    
    private func footerErrorView() -> some View {
        FooterErrorView(isVisible: viewModel.hasNextPage) {
            await viewModel.onPaging()
        }
        .listRowSeparator(.hidden)
    }
    
    private func emptyView(_ proxy: GeometryProxy) -> some View {
        Text("データがありません")
            .frame(width: proxy.size.width, height: proxy.size.height)
    }
    
    private func failureView(_ proxy: GeometryProxy) -> some View {
        Text("エラーが発生しました")
            .frame(width: proxy.size.width, height: proxy.size.height)
    }
}
