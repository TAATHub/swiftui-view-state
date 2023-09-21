import Foundation

enum CurrentViewState {
    case idle([Item])
    case empty
    case progress([Item])
    case failure
}

enum NewViewState<V, E: Error> {
    case initial
    case loading(V)
    case success(V)
    case empty
    case failure(E)
    case refreshing(V)
    case paging(V)
    case pagingFailure(V)
}

extension NewViewState {
    var isLoading: Bool {
        switch self {
        case .loading(_), .refreshing(_), .paging(_):
            return true
        default:
            return false
        }
    }
}

enum CustomError: Error {
    case unknown
}
