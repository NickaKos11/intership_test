import Foundation

struct BaseSession {
    let session: URLSession
    
    init() {
        self.session = URLSession.init(configuration: .default)
        self.session.configuration.timeoutIntervalForRequest = TimeInterval(15)
    }
}
