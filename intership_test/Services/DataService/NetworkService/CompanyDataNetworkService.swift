import Foundation

protocol CompanyDataNetworkServiceProtocol: AnyObject {
    func getCompanyData(
        completion: @escaping (Result<Company, NetworkError>) -> Void
    )
}

final class CompanyDataNetworkService: CompanyDataNetworkServiceProtocol {

    private var baseUrl: BaseURL
    private var baseSession: BaseSession
    private let request: HTTPRequest

    private let backgroundQueue: DispatchQueue
    private let completionQueue: DispatchQueue

    private let cacheService: CompanyDataCacheServiceProtocol

    init(
        baseUrl: BaseURL = BaseURL(
            baseURLData: BaseURLData(
                baseURLProtocol: .https,
                baseURLHost: .host,
                baseURLPath: .employees
            )
        ),
        baseSession: BaseSession = BaseSession(),
        request: HTTPRequest = BaseRequest(),
        completionQueue: DispatchQueue = DispatchQueue.main,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .background),
        cacheService: CompanyDataCacheServiceProtocol = CompanyDataCacheService()
    ) {
        self.baseUrl = baseUrl
        self.baseSession = baseSession
        self.request = request
        self.backgroundQueue = backgroundQueue
        self.completionQueue = completionQueue
        self.cacheService = cacheService
    }

    func getCompanyData(completion: @escaping (Result<Company, NetworkError>) -> Void) {
        backgroundQueue.async { [weak self] in

            guard let self = self else {
                return
            }

            self.request.execute(
                url: self.baseUrl.url,
                session: self.baseSession.session
            ) { (result: (Result<CompaniesDTO, NetworkError>)) in
                self.completionQueue.async {
                    switch result {
                    case let .success(companiesDTO):
                        completion(.success(Company(from: companiesDTO)))

                        self.cacheService.saveAll(data: companiesDTO) { result in
                            switch result {
                            case .success:
                                UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "CacheTimeInSeconds")
                            case .failure(let error):
                                print("Cache error: \(error)")
                            }
                        }
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
