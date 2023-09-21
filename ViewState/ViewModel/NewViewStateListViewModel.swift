import Foundation

@MainActor
final class NewViewStateListViewModel: ObservableObject, Pageable {
    @Published var viewState: NewViewState<[Item], CustomError> = .loading(dummyItems())
    var pageToken: String?
    
    private var items = [Item]()
    
    func onTask() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // データ取得成功の場合
        items = Self.dummyItems()
        pageToken = UUID().uuidString
        
        viewState = .success(items)
        
        // データ取得失敗の場合
//        viewState = .failure(.unknown)
    }
    
    func onRefresh() async {
        guard !viewState.isLoading else { return }
        
        viewState = .refreshing(items)
        
        items.removeAll()
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        items = Self.dummyItems()
        pageToken = UUID().uuidString
        
        viewState = .success(items)
    }
    
    func onPaging() async {
        guard !viewState.isLoading else { return }
        
        viewState = .paging(items)
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        if Bool.random() {
            // データ取得成功の場合
            items += Self.dummyItems()
            pageToken = UUID().uuidString
    
            viewState = .success(items)
        } else {
            // データ取得失敗の場合
            viewState = .pagingFailure(items)
        }
    }
    
    static func dummyItems() -> [Item] {
        return Array(0..<20).map { _ in
            let uuid = UUID().uuidString
            return Item(id: uuid, text: uuid)
        }
    }
}
