import UIKit

// MARK: - вью экрана редактирования профиля

protocol EditProfileViewDelegate: AnyObject {
    func setupNewInfo(firstName: String?, lastName: String?, image: UIImage?)
    func avatarImageTapped()
    func backBarButtonItemDidPressed()
}

class EditProfileView: UIView {

    private lazy var pageNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Profile"
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 18, weight: .heavy, width: .condensed)
        label.textColor = .black
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        return label
    }()
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "demoCat")
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 80
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.vividPinkColor().cgColor
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTapGestureRecognizer)
        return imageView
    }()
    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Your First Name"
        textField.backgroundColor = .systemGray5
        textField.textColor = .systemGray
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 13, weight: .medium)
        textField.autocapitalizationType = .none
        return textField
    }()
    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Your Last Name"
        textField.backgroundColor = .systemGray5
        textField.textColor = .systemGray
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 13, weight: .medium)
        textField.autocapitalizationType = .none
        return textField
    }()
    private lazy var setupButton: UIButton = {
        let button = UIButton()
        button.setTitle("Setup", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.backgroundColor = UIColor.vividPinkColor()
        button.setTitleColor(.white, for: .normal)

        let action = UIAction { [weak self] _ in
            self?.delegate?.setupNewInfo(
                firstName: self?.firstNameTextField.text,
                lastName: self?.lastNameTextField.text,
                image: self?.avatarImageView.image
            )

        }

        button.addAction(action, for: .touchUpInside)

        return button
    }()
    private lazy var backBarButtonItemAction = UIAction { [weak self] _ in
        self?.delegate?.backBarButtonItemDidPressed()
    }
    lazy var backBarButtonItem = UIBarButtonItem(title: "Back", primaryAction: self.backBarButtonItemAction)

    private lazy var imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))

    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }()

    weak var delegate: EditProfileViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension EditProfileView {
    func configureView() {
        addSubview(pageNameLabel)
        addSubview(avatarImageView)
        addSubview(firstNameTextField)
        addSubview(lastNameTextField)
        addSubview(setupButton)

        pageNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(64)
            make.height.equalTo(24)
        }
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(pageNameLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(160)
        }
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(48)
        }
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(48)
        }
        setupButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-64)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(48)
        }
    }
    func configureAvatarImageView(image: UIImage) {
        avatarImageView.image = image
    }

}
extension EditProfileView {
    @objc func imageTapped() {
        delegate?.avatarImageTapped()
    }
}
extension EditProfileView {
    func setupImagePickerDelegate(_ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        imagePicker.delegate = delegate
    }
}
extension EditProfileView {
    func setupFirstNameTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        firstNameTextField.delegate = delegate
    }
    func setupLastNameTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        lastNameTextField.delegate = delegate
    }
}
