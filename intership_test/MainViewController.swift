import UIKit

class MainViewController: UIViewController {
    private var companyDataNetworkService: CompanyDataNetworkServiceProtocol?
    private var companyName: String?
    private var employees: [Employee]?
    
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
        view.backgroundColor = .white
        getCompanyData()
    }
    
    func getCompanyData() {
        companyDataNetworkService?.getCompanyData { result in
            switch result {
            case let .success(companyData):
                self.companyName = companyData.name
                self.employees = companyData.employess
            case let .failure(error):
                //TODO: add alert
                print(error)
            }
        }
    }
}

