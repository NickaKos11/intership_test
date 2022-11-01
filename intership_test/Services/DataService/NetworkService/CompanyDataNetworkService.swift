import Foundation

protocol CompanyDataNetworkServiceProtocol: AnyObject {
    func getCompanyData(
        completion: @escaping (Result<Company, NetworkError>) -> Void
    )
}

final class CompanyDataNetworkService: CompanyDataNetworkServiceProtocol {
    
    private var baseUrl: BaseURL
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
        request: HTTPRequest = BaseRequest(),
        completionQueue: DispatchQueue = DispatchQueue.main ,
        backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .background)
    ) {
        self.baseUrl = baseUrl
        self.request = request
        self.backgroundQueue = backgroundQueue
        self.completionQueue = completionQueue
    }
    
    func getCompanyData(completion: @escaping (Result<Company, NetworkError>) -> Void) {
        
        backgroundQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.request.execute(
                url: self.baseUrl.url
            ) { (result: (Result<CompaniesDTO, NetworkError>)) in
                self.completionQueue.async {
                    switch result {
                    case let .success(companiesDTO):
                        print(companiesDTO)
                        completion(.success(Company(name: "что-то пришло", employess: [Employee(name: "fff", phoneNumber: "999", skills: ["dd", "ss"])])))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
