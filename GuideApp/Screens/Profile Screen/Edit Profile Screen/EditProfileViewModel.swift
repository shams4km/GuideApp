import UIKit

// MARK: - вью модель экрана редактирования профиля

class EditProfileViewModel {

    private var userService = UserService.shared

    func getCurrentUserImage() -> UIImage? {
        if let image = userService.getCurrentUserImage() {
            return image
        } else if let noImage = UIImage(named: "no-avatar") {
            return noImage
        }
        return nil
    }

    func setupNewProfileInfo(firstName: String?, lastName: String?, image: UIImage?) {
        guard var curUser = userService.getCurrentUser() else { return }

        var newImageData: Data?

        if let firstName = firstName {
            if !firstName.isEmpty {
                curUser.firstName = firstName
            }
        }
        if let lastName = lastName {
            if !lastName.isEmpty {
                curUser.lastName = lastName
            }
        }
        if let image = image {
            curUser.avatarImage = image

            newImageData = image.jpegData(compressionQuality: 0.3)
        }

        userService.setUpdatedUser(user: curUser)

        userService.updateUserInfo(with: curUser) { result in
            switch result {
            case .success:
                print("successfully saved info about user")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        userService.updateUserPhoto(image: newImageData) { result in
            switch result {
            case .success(let sizeInfo):
                print("succes in setuping new user info with photo size: ", sizeInfo)
            case .failure(let error):
                print("error in setupNewProfileInfo", error.localizedDescription)
            }

        }
    }
    
}
