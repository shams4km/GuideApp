import UIKit

// MARK: - координатор таблицы избранных ивентов

protocol FavouriteViewControllerCoordinatorOutput: AnyObject {
    func coordinatorWantsToBackToProfileScreen()
    func coordinatorWantsToOpenTableDetailScreen()
    func coordinatorWantsToBackToTableFromTableDetailScreen()

}
class FavouriteViewControllerCoordinator: BaseCoodinator {

    var navigationController: UINavigationController
    
    weak var output: FavouriteViewControllerCoordinatorOutput?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let favouriteModel = FavouritesViewModel()
        let favouriteVC = FavouritesViewController(viewModel: favouriteModel)
        favouriteVC.delegate = self
        favouriteVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(favouriteVC, animated: true)

    }
}
extension FavouriteViewControllerCoordinator: FavouritesViewControllerDelegate {
    func goToTableDetailScreen() {
        output?.coordinatorWantsToOpenTableDetailScreen()
    }
    func backToProfileScreen() {
        output?.coordinatorWantsToBackToProfileScreen()
    }
}
extension FavouriteViewControllerCoordinator: FavouritesTableDetailControllerDelegate {
    func goBackToTableScreen() {
        output?.coordinatorWantsToBackToTableFromTableDetailScreen()
    }
}
