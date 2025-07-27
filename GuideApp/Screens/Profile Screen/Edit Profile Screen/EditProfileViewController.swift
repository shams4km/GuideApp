import UIKit

// MARK: - экран редактирования профиля

protocol EditProfileViewControllerDelegate: AnyObject {
    func goBackToProfileScreen()
    func showImageLibraryByPicker(by imagePicker: UIImagePickerController)
}

class EditProfileViewController: UIViewController {

    private let contentView: EditProfileView = .init()
    private let viewModel: EditProfileViewModel

    private var isFirstAppearance = true

    weak var delegate: EditProfileViewControllerDelegate?

    init(viewModel: EditProfileViewModel) {
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
        contentView.setupImagePickerDelegate(self)

        contentView.setupFirstNameTextFieldDelegate(self)
        contentView.setupLastNameTextFieldDelegate(self)

        setupNavigationBar()
        setupCurrentUserInfo()

    }

}
extension EditProfileViewController {
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = contentView.backBarButtonItem
    }
}
extension EditProfileViewController {
    func setupCurrentUserInfo() {
        if let image = viewModel.getCurrentUserImage() {
            contentView.configureAvatarImageView(image: image)
        }
    }
}
extension EditProfileViewController: EditProfileViewDelegate {
    func avatarImageTapped() {
        delegate?.showImageLibraryByPicker(by: contentView.imagePicker)
    }
    func setupNewInfo(firstName: String?, lastName: String?, image: UIImage?) {
        viewModel.setupNewProfileInfo(
            firstName: firstName,
            lastName: lastName,
            image: image
        )
        delegate?.goBackToProfileScreen()
    }
    func backBarButtonItemDidPressed() {
        delegate?.goBackToProfileScreen()
    }
}
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        let image = info[.originalImage] as? UIImage
        if let unwrappedImage = image {
            contentView.configureAvatarImageView(image: unwrappedImage)
        }
    }
}
extension EditProfileViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
