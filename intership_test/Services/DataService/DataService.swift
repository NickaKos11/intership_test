import Foundation

protocol DataServiceProtocol {
    func getCompanyInfo(
      completion: @escaping (Result<Company, NetworkError>) -> Void
    )
}

final class DataService: DataServiceProtocol {

    private let cacheService: CompanyDataCacheServiceProtocol
    private let networkService: CompanyDataNetworkServiceProtocol
    private let cacheTimeInSeconds: Double

    init(
        cacheService: CompanyDataCacheServiceProtocol = CompanyDataCacheService(),
        networkService: CompanyDataNetworkServiceProtocol = CompanyDataNetworkService(),
        cacheTimeInSeconds: Double = UserDefaults.standard.double(forKey: "CacheTimeInSeconds")
    ) {
        self.cacheService = cacheService
        self.networkService = networkService
        self.cacheTimeInSeconds = cacheTimeInSeconds
    }

    func getCompanyInfo(completion: @escaping (Result<Company, NetworkError>) -> Void) {
        if cacheUpdateIsNeed(cacheTimeInSeconds) {
            networkService.getCompanyData(completion: completion)
        } else {
            cacheService.loadAll { result in
                switch result {
                case .success(let cacheInfo):
                    completion(.success(cacheInfo))
                case .failure:
                    self.networkService.getCompanyData(completion: completion)
                }
            }
        }
    }

    private func cacheUpdateIsNeed(_ cacheTimeInSeconds: Double) -> Bool {
        if  Date().timeIntervalSince1970 - cacheTimeInSeconds > Constants.cacheTimeIntervalInSeconds {
            return true
        }
        return false
    }
}

private enum Constants {
    static let cacheTimeIntervalInSeconds: Double = 3600
}
