import Foundation

protocol CompanyDataNetworkServiceProtocol: AnyObject {
    func getCompanyData(
        completion: @escaping (Result<CompaniesDTO, NetworkError>) -> Void
    )
}

final class CompanyDataNetworkService: CompanyDataNetworkServiceProtocol {

    private var baseUrl: BaseURL
    private var baseSession: BaseSession
    private let request: HTTPRequest

    private let backgroundQueue: DispatchQueue
    private let completionQueue: DispatchQueue

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
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .background)
    ) {
        self.baseUrl = baseUrl
        self.baseSession = baseSession
        self.request = request
        self.backgroundQueue = backgroundQueue
        self.completionQueue = completionQueue
    }

    func getCompanyData(completion: @escaping (Result<CompaniesDTO, NetworkError>) -> Void) {
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
                        completion(.success(companiesDTO))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
