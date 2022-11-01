import UIKit

class MainViewController: UIViewController {
    var companyDataNetworkService: CompanyDataNetworkServiceProtocol?

    init(
        companyDataNetworkService: CompanyDataNetworkServiceProtocol = CompanyDataNetworkService()
    ) {
        self.companyDataNetworkService = companyDataNetworkService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getCompanyData()
    }

    func getCompanyData() {
        companyDataNetworkService?.getCompanyData { result in
            switch result {
            case let .success(companyData):
                print(companyData)
            case let .failure(error):
                print(error)
            }
        }
    }
}
