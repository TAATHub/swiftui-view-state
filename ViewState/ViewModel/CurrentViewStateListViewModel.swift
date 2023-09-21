import Foundation

@MainActor
final class CurrentViewStateListViewModel: ObservableObject {
    @Published var viewState: CurrentViewState = .progress(dummyItems())
    
    var hasNextPage: Bool {
        return pageToken?.isEmpty == false
    }

    private var pageToken: String?
    private var items = [Item]()
    
    func onTask() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // データ取得成功の場合
        items = Self.dummyItems()
        pageToken = UUID().uuidString
        
        viewState = .idle(items)
        
        // データ取得成功の場合
//        viewState = .failure(.unknown)
    }
    
    func onRefresh() async {
        items.removeAll()
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        items = Self.dummyItems()
        pageToken = UUID().uuidString
        
        viewState = .idle(items)
    }
    
    func onScrollToEnd() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // データ取得成功の場合
        items += Self.dummyItems()
        pageToken = UUID().uuidString
        
        viewState = .idle(items)
        
        // データ取得失敗の場合
//        viewState = .failure(.unknown)
    }
    
    static func dummyItems() -> [Item] {
        return Array(0..<20).map { _ in
            let uuid = UUID().uuidString
            return Item(id: uuid, text: uuid)
        }
    }
}
