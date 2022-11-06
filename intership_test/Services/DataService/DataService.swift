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
        if cacheUpdateIsNeeded(cacheTimeInSeconds) {
            loadFromNetwork(completion: completion)
        } else {
            cacheService.loadAll { result in
                switch result {
                case .success(let cacheInfo):
                    completion(.success(cacheInfo))
                case .failure:
                    self.loadFromNetwork(completion: completion)
                }
            }
        }
    }

    private func loadFromNetwork(completion: @escaping (Result<Company, NetworkError>) -> Void) {
        networkService.getCompanyData { networkResult in
            switch networkResult {
            case .success(let companiesDTO):
                self.saveToCache(companiesDTO)
                completion(.success(Company(from: companiesDTO)))
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }

    private func saveToCache(_ companiesInfo: CompaniesDTO) {
        cacheService.saveAll(data: companiesInfo) { result in
            switch result {
            case .success:
                UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "CacheTimeInSeconds")
            case .failure(let error):
                print("Cache error: \(error)")
            }
        }
    }

    private func cacheUpdateIsNeeded(_ cacheTimeInSeconds: Double) -> Bool {
        if  Date().timeIntervalSince1970 - cacheTimeInSeconds > Constants.cacheTimeIntervalInSeconds {
            return true
        }
        return false
    }
}

private enum Constants {
    static let cacheTimeIntervalInSeconds: Double = 3600
}
