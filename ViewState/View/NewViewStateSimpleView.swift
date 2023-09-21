import SwiftUI

struct NewViewStateSimpleView: View {
    @StateObject var viewModel: NewViewStateSimpleViewModel = .init()
    
    var body: some View {
        let _ = Self._printChanges()
        
        GeometryReader { proxy in
            ZStack {
                switch viewModel.viewState {
                case .loading(let item):
                    contentView(item: item, redacted: true)
                    // ローディングインジケーターが良い場合はこちら
//                    loadingView(proxy)
                case .success(let item):
                    contentView(item: item, redacted: false)
                case .failure:
                    failureView(proxy)
                default:
                    EmptyView()
                }
            }
            .task {
                await viewModel.onTask()
            }
            .navigationTitle("Simple view sample")
        }
    }
    
    private func loadingView(_ proxy: GeometryProxy) -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .frame(width: proxy.size.width, height: proxy.size.height)
    }
    
    private func contentView(item: Item, redacted: Bool) -> some View {
        VStack(spacing: 16) {
            Color.gray
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            
            Text(item.text)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .redacted(reason: redacted ? .placeholder : [])
    }
    
    private func failureView(_ proxy: GeometryProxy) -> some View {
        Text("エラーが発生しました")
            .frame(width: proxy.size.width, height: proxy.size.height)
    }
}
