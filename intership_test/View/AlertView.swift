import UIKit

protocol AlertViewDelegate: AnyObject {
    func reloadButtonPressed()
}

final class AlertView: UIView {
    weak var delegate: AlertViewDelegate?

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = ColorPalette.mainBackground
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = ColorPalette.accentColor.cgColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var errorTitleLabel: UILabel = {
        let errorTitleLabel = UILabel()
        errorTitleLabel.font = UIFont.SFBoldFont(size: Constants.errorTitleFontSize)
        errorTitleLabel.text = Strings.errorTitleText
        errorTitleLabel.numberOfLines = 1
        errorTitleLabel.textColor = ColorPalette.mainText
        errorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return errorTitleLabel
    }()

    private lazy var errorLabel: UILabel = {
        let errorTitle = UILabel()
        errorTitle.font = UIFont.SFRegularFont(size: Constants.errorFontSize)
        errorTitle.numberOfLines = 0
        errorTitle.textColor = ColorPalette.mainText
        errorTitle.translatesAutoresizingMaskIntoConstraints = false
        return errorTitle
    }()

    private lazy var reloadButton: UIButton = {
        let reloadButton = UIButton()
        reloadButton.titleLabel?.font = UIFont.SFBoldFont(size: Constants.buttonTitleFontSize)
        reloadButton.setTitle(Strings.buttonText, for: .normal)
        reloadButton.setTitleColor(ColorPalette.mainText, for: .normal)
        reloadButton.backgroundColor = ColorPalette.accentColor
        reloadButton.layer.cornerRadius = Constants.buttonCornerRadius
        reloadButton.addTarget(self, action: #selector(reloadButtonPressed), for: .touchUpInside)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        return reloadButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    func configure(errorDescription: String) {
        errorLabel.text = "\(errorDescription) \(Strings.alertText)"
    }

    @objc
    private func reloadButtonPressed() {
        self.delegate?.reloadButtonPressed()
    }

    private func setupView() {
        [
            contentView,
            errorTitleLabel,
            errorLabel,
            reloadButton
        ].forEach {
            addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.contentViewSideIndent
            ),
            contentView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Constants.contentViewSideIndent
            ),
            errorTitleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.topIndent
            ),
            errorTitleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sideIndent
            ),
            errorTitleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.sideIndent
            ),
            errorLabel.topAnchor.constraint(
                equalTo: errorTitleLabel.bottomAnchor,
                constant: Constants.labelsIndent
            ),
            errorLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sideIndent
            ),
            errorLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.sideIndent
            ),
            reloadButton.topAnchor.constraint(
                equalTo: errorLabel.bottomAnchor,
                constant: Constants.labelsIndent
            ),
            reloadButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.sideIndent
            ),
            reloadButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.sideIndent
            ),
            reloadButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            reloadButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.bottomIndent
            )
        ])
    }
}

private enum Constants {
    static let errorTitleFontSize: CGFloat = 24
    static let errorFontSize: CGFloat = 17
    static let buttonTitleFontSize: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 13
    static let contentViewCornerRadius: CGFloat = 13
    static let contentViewSideIndent: CGFloat = 34
    static let topIndent: CGFloat = 20
    static let sideIndent: CGFloat = 16
    static let labelsIndent: CGFloat = 12
    static let bottomIndent: CGFloat = 20
    static let buttonHeight: CGFloat = 48
}

private enum Strings {
    static let errorTitleText = "Упс!"
    static let buttonText = "Попробовать еще раз"
    static let alertText = "Попробуйте еще раз или зайдите в приложение позже."
}
