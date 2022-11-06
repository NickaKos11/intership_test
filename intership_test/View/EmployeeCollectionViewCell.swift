import UIKit

final class EmployeeCollectionViewCell: UICollectionViewCell {

    private var skills: [String]?

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.SFBoldFont(size: Constants.nameLabelFontSize)
        nameLabel.textColor = ColorPalette.mainText
        nameLabel.numberOfLines = 1
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    private lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.font = UIFont.SFRegularFont(size: Constants.phoneLabelFontSize)
        phoneLabel.textColor = ColorPalette.additionalText
        phoneLabel.numberOfLines = 1
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        return phoneLabel
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            SkillCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: SkillCollectionViewCell.self)
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with employeeInfo: Employee) {
        nameLabel.text = employeeInfo.name
        phoneLabel.text = "Phone: \(employeeInfo.phoneNumber)"
        skills = employeeInfo.skills
        collectionView.reloadData()
    }

    private func setup() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.shadowRadius = Constants.shadowRadius
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowColor = ColorPalette.shadowColor.cgColor
        contentView.layer.shadowOpacity = Constants.shadowOpasity
        [
            nameLabel,
            phoneLabel,
            collectionView
        ]
            .forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.topIndent
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sideIndent
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.sideIndent
            ),
            phoneLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: Constants.labelsIndent
            ),
            phoneLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sideIndent
            ),
            phoneLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.sideIndent
            ),
            collectionView.topAnchor.constraint(
                equalTo: phoneLabel.bottomAnchor
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sideIndent
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.bottomIndent
            )
        ])
    }
}

extension EmployeeCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        skills?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let data = skills?[indexPath.row],
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: SkillCollectionViewCell.self),
                for: indexPath) as? SkillCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.configure(with: data)
        return cell
    }
}

extension EmployeeCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.cellSpasing
    }
}

private enum Constants {
    static let nameLabelFontSize: CGFloat = 22
    static let phoneLabelFontSize: CGFloat = 17
    static let topIndent: CGFloat = 16
    static let sideIndent: CGFloat = 25
    static let bottomIndent: CGFloat = 13
    static let labelsIndent: CGFloat = 9
    static let skillsTopIndent: CGFloat = 11
    static let cornerRadius: CGFloat = 13
    static let shadowRadius: CGFloat = 5
    static let shadowOpasity: Float = 1
    static let cellSpasing: CGFloat = 8
}
