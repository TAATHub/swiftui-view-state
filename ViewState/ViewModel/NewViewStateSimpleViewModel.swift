import Foundation

@MainActor
final class NewViewStateSimpleViewModel: ObservableObject {
    @Published var viewState: NewViewState<Item, CustomError> = .initial
    
    func onTask() async {
        guard !viewState.isLoading else { return }
        
        viewState = .loading(Self.dummyItem())
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // データ取得成功の場合
        viewState = .success(Self.dummyItem())
        
        // データ取得失敗の場合
//        viewState = .failure(.unknown)
    }
    
    static func dummyItem() -> Item {
        let uuid = UUID().uuidString
        return Item(id: uuid, text: uuid)
    }
}
