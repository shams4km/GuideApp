import UIKit
import SnapKit

// MARK: - вью экрана профиля

protocol ProfileViewDelegate: AnyObject {
    func signOutButtonDidPressed()
    func favouriteButtonDidPressed()
    func editProfileButtonDidPressed()
    func deleteProfileButtonDidPressed()
}

class ProfileView: UIView {
    private lazy var pageNameLabel: UILabel = {
        let label = UILabel()
        label.text = "My profile"
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 18, weight: .heavy, width: .condensed)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private lazy var userFirstnameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 21, weight: .heavy, width: .condensed)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private lazy var userSurnameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 21, weight: .heavy, width: .condensed)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        // imageView.image = UIImage(named: "no-avatar")
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 80
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.vividPinkColor().cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.setTitle("My Favourites", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.backgroundColor = UIColor.vividPinkColor()
        button.setTitleColor(.white, for: .normal)

        let action = UIAction { [weak self] _ in
            self?.delegate?.favouriteButtonDidPressed()
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()
    private lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.backgroundColor = UIColor.vividPinkColor()
        button.setTitleColor(.white, for: .normal)

        let action = UIAction { [weak self] _ in
            self?.delegate?.editProfileButtonDidPressed()
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()
    private lazy var deleteProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Profile", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.backgroundColor = UIColor.vividPinkColor()
        button.setTitleColor(.white, for: .normal)

        let action = UIAction { [weak self] _ in
            self?.delegate?.deleteProfileButtonDidPressed()
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.backgroundColor = UIColor.vividPinkColor()
        button.setTitleColor(.white, for: .normal)

        let action = UIAction { [weak self] _ in
            self?.delegate?.signOutButtonDidPressed()
        }
        button.addAction(action, for: .touchUpInside)

        return button
    }()

    weak var delegate: ProfileViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension ProfileView {
    private func configureView() {

        let stackView = UIStackView(arrangedSubviews: [userFirstnameLabel, userSurnameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 1

        addSubview(pageNameLabel)
        addSubview(avatarImageView)
        addSubview(stackView)
        addSubview(favouriteButton)
        addSubview(editProfileButton)
        addSubview(deleteProfileButton)
        addSubview(signOutButton)

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
        stackView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(72)
            make.height.equalTo(32)
        }
        favouriteButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(48)
        }
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(favouriteButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(48)
        }
        deleteProfileButton.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(48)
        }
        signOutButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(48)
        }
    }

}
extension ProfileView {
    func configureProfileInfo(firstName: String, lastName: String) {
        userFirstnameLabel.text = firstName
        userSurnameLabel.text = lastName
    }
    func configureProfileImage(image: UIImage?) {
        if let image = image {
            avatarImageView.image = image
        } else {
            avatarImageView.image = UIImage(named: "no-avatar")
        }
    }
}
