import UIKit

final class SkillCollectionViewCell: UICollectionViewCell {

    private lazy var skillLabel: UILabel = {
        let skillLabel = UILabel()
        skillLabel.font = UIFont.SFRegularFont(size: Constants.skillLabelFontSize)
        skillLabel.textColor = ColorPalette.mainText
        skillLabel.numberOfLines = 1
        skillLabel.translatesAutoresizingMaskIntoConstraints = false
        return skillLabel
    }()

    private lazy var skillView: UIView = {
        let skillView = UIView()
        skillView.backgroundColor = ColorPalette.accentColor
        skillView.layer.cornerRadius = Constants.skillViewCornerRadius
        skillView.translatesAutoresizingMaskIntoConstraints = false
        return skillView
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

    func configure(with skill: String) {
        skillLabel.text = skill
    }

    private func setup() {
        contentView.addSubview(skillView)
        contentView.addSubview(skillLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            skillView.topAnchor.constraint(equalTo: contentView.topAnchor),
            skillView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            skillView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            skillView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            skillLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sideIndent
            ),
            skillLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.verticalIndent
            ),
            skillLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.sideIndent
            ),
            skillLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.verticalIndent
            )
        ])
    }
}

private enum Constants {
    static let skillLabelFontSize: CGFloat = 19
    static let skillViewCornerRadius: CGFloat = 13
    static let sideIndent: CGFloat = 16
    static let verticalIndent: CGFloat = 3
}
