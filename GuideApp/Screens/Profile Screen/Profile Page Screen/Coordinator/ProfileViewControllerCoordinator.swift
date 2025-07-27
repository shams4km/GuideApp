import UIKit

// MARK: - координатор экрана профиля

protocol ProfileViewControllerCoordinatorOutput: AnyObject {
    func signOut()
}

class ProfileViewControllerCoordinator: BaseCoodinator {

    var navigationController: UINavigationController

    weak var output: ProfileViewControllerCoordinatorOutput?

    private var favouriteViewControllerCoordinator: FavouriteViewControllerCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let profileModel = ProfileViewModel()
        let profileVC = ProfileViewController(viewModel: profileModel)
        profileVC.delegate = self
        add(coordinator: self)
        navigationController.pushViewController(profileVC, animated: true)
    }

//    функция для получения текущего контроллера (чтобы открыть галерею методом present)
    private func getTopViewController() -> UIViewController? {
        if var topController = navigationController.topViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

}
extension ProfileViewControllerCoordinator: ProfileViewControllerDelegate {
    func goToEditProfileScreen() {
        let editProfileViewModel = EditProfileViewModel()
        let editProfileVC = EditProfileViewController(viewModel: editProfileViewModel)
        editProfileVC.delegate = self
        editProfileVC.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(editProfileVC, animated: true)
    }
    func goToFavouriteTableScreen() {
        let coordinator = FavouriteViewControllerCoordinator(navigationController: navigationController)
        coordinator.output = self
        favouriteViewControllerCoordinator = coordinator

        add(coordinator: coordinator)
        coordinator.start()
    }
    func signOut() {
        output?.signOut()
    }
    func deleteAccountSignOut() {
        output?.signOut()
    }
}
extension ProfileViewControllerCoordinator: FavouriteViewControllerCoordinatorOutput {
    func coordinatorWantsToOpenTableDetailScreen() {
        let favouriteTableDetailViewModel = FavouritesTableDetailViewModel()
        let favouriteTableDetailVC = FavouritesTableDetailViewController(viewModel: favouriteTableDetailViewModel)
        favouriteTableDetailVC.delegate = favouriteViewControllerCoordinator
        favouriteTableDetailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(favouriteTableDetailVC, animated: true)
    }
    func coordinatorWantsToBackToTableFromTableDetailScreen() {
        navigationController.popViewController(animated: true)
    }
    func coordinatorWantsToBackToProfileScreen() {
        favouriteViewControllerCoordinator.map { remove(coordinator: $0) }
        navigationController.popViewController(animated: true)
    }
    
}
// открывает галерею чтобы установить новое фото профиля
extension ProfileViewControllerCoordinator: EditProfileViewControllerDelegate {
    func showImageLibraryByPicker(by imagePicker: UIImagePickerController) {
        guard let topViewController = getTopViewController() else {
            return
        }
        topViewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func goBackToProfileScreen() {
        navigationController.popViewController(animated: true)
    }
    
}
