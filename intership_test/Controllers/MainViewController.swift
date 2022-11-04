import UIKit

final class MainViewController: UIViewController {
    private var companyDataNetworkService: CompanyDataNetworkServiceProtocol?
    private var employees: [Employee]?
    private lazy var alert = AlertView()
    private lazy var activityIndicator = UIActivityIndicatorView()

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            EmployeeCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: EmployeeCollectionViewCell.self)
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

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
        view.backgroundColor = ColorPalette.mainBackground
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        setupNavigationBar()
        getCompanyData()
        setupConstraints()
    }

    @objc
    private func didpullRefresh() {
        getCompanyData()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .compact)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ColorPalette.mainText,
            NSAttributedString.Key.font: UIFont.SFBoldFont(size: Constants.navigationBarFontSize)
        ]
        navigationController?.navigationBar.tintColor = ColorPalette.mainText
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func showAlert(with error: NetworkError) {
        alert.configure(errorDescription: error.rawValue)
        alert.delegate = self
        view.addSubview(alert)
        alert.frame = view.frame
        alert.center = view.center
    }

    private func getCompanyData() {
        companyDataNetworkService?.getCompanyData { result in
            switch result {
            case let .success(companyData):
                self.activityIndicator.stopAnimating()
                self.employees = companyData.employess.sorted {$0.name < $1.name}
                self.title = "\(companyData.name) employees"
                self.collectionView.reloadData()
            case let .failure(error):
                self.activityIndicator.stopAnimating()
                self.showAlert(with: error)
            }
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.employees?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard
                let data = employees?[indexPath.row],
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: EmployeeCollectionViewCell.self),
                    for: indexPath) as? EmployeeCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(with: data)
            return cell
        }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width-2*Constants.sideIndent
        let height = Constants.cellHeight
        return CGSize(width: width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.cellSpasing
    }
}

extension MainViewController: AlertViewDelegate {
    func cancelButtonPressed() {
        getCompanyData()
        alert.removeFromSuperview()
        activityIndicator.startAnimating()
    }
}

private enum Constants {
    static let sideIndent: CGFloat = 16
    static let cellHeight: CGFloat = 135
    static let cellSpasing: CGFloat = 16
    static let navigationBarFontSize: CGFloat = 30
}
