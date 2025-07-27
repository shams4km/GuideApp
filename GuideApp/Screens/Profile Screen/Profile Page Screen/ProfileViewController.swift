import UIKit
import Combine

// MARK: - экран профиля

protocol ProfileViewControllerDelegate: AnyObject {
    func signOut()
    func goToFavouriteTableScreen()
    func deleteAccountSignOut()
    func goToEditProfileScreen()
}

class ProfileViewController: UIViewController {

    private let contentView: ProfileView = .init()
    private let viewModel: ProfileViewModel

    private var cancellables = Set<AnyCancellable>()

    weak var delegate: ProfileViewControllerDelegate?


    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6

        contentView.delegate = self

        updateUserProfileInfo()
    }
    
}
extension ProfileViewController {

    func updateUserProfileInfo() {
        viewModel.currentUserPublisher
            .sink { [weak self] user in
                if let user = user {
                    self?.setupUserProfile()
                }
            }
            .store(in: &cancellables)
    }

    func setupUserProfile() {
        if let firstName = viewModel.getUserFirstName(),
            let lastName = viewModel.getUserLastName() {
            contentView.configureProfileInfo(firstName: firstName, lastName: lastName)
        }
        if let userImage = viewModel.getUserImage() {
            contentView.configureProfileImage(image: userImage)
        }
    }


}
extension ProfileViewController: ProfileViewDelegate {
    func deleteProfileButtonDidPressed() {
        viewModel.deleteProfile { [weak self] success, error in
            if error != nil {
                print("error in deleting user")
            } else if success {
                self?.delegate?.deleteAccountSignOut()
                print("user was deleted successfully")
            }
        }
    }
    
    func editProfileButtonDidPressed() {
        delegate?.goToEditProfileScreen()
    }
    
    func favouriteButtonDidPressed() {
        delegate?.goToFavouriteTableScreen()
    }
    
    func signOutButtonDidPressed() {
        delegate?.signOut()
        viewModel.signOutFromProfile()
    }
}
