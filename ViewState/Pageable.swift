import Foundation

@MainActor
protocol Pageable {
    var hasNextPage: Bool { get }
    var pageToken: String? { get }
    
    func onTask() async
    func onRefresh() async
    func onPaging() async
}

extension Pageable {
    var hasNextPage: Bool {
        return pageToken?.isEmpty == false
    }
}
