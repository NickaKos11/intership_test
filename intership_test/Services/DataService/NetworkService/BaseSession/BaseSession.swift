import Foundation

struct BaseSession {
    let session: URLSession

    init() {
        session = URLSession.init(configuration: .default)
        session.configuration.timeoutIntervalForRequest = TimeInterval(15)
    }
}
