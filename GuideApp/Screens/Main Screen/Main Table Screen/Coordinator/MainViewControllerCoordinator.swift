import UIKit

// MARK: - координатор главной таблицы с ивентами

class MainViewControllerCoordinator: BaseCoodinator {

    var navigationController: UINavigationController

    var mainTableDetailCoordinator: MainTableDetailCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let mainModel = MainViewModel()
        let mainVC = MainViewController(viewModel: mainModel)
        mainVC.delegate = self
        add(coordinator: self)
        navigationController.pushViewController(mainVC, animated: true)

    }

}
extension MainViewControllerCoordinator: MainViewControllerDelegate {
    func goToFilterScreen() {
        let filterViewModel = FilterViewModel()
        let filterViewController = FilterViewController(viewModel: filterViewModel)
        filterViewController.delegate = self
        filterViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(filterViewController, animated: true)
    }
    
    func goToTableDetailScreen() {
        let coordinator = MainTableDetailCoordinator(navigationController: navigationController)
        coordinator.output = self
        mainTableDetailCoordinator = coordinator

        add(coordinator: coordinator)
        coordinator.start()
    }
}
extension MainViewControllerCoordinator: MainTableDetailCoordinatorOutput {
    func coordinatorWantsToBackToTable() {
        mainTableDetailCoordinator.map { remove(coordinator: $0) }
        navigationController.popViewController(animated: true)
    }
}
extension MainViewControllerCoordinator: FilterViewControllerDelegate {
    func goBackToMainTable() {
        navigationController.popViewController(animated: true)
    }
}
