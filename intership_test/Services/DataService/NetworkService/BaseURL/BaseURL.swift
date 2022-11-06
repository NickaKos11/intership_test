import Foundation

struct BaseURL {
    var baseURLData: BaseURLData

    var url: URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = baseURLData.baseURLProtocol.rawValue
        urlComponents.host = baseURLData.baseURLHost.rawValue
        urlComponents.path = baseURLData.baseURLPath.rawValue
        guard let url = urlComponents.url else {
            fatalError("Failed to configure URL")
        }
        return url
    }
}
