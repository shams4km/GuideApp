import UIKit

// MARK: - координатор детального экрана ивента из главной таблицы

protocol MainTableDetailCoordinatorOutput: AnyObject {
    func coordinatorWantsToBackToTable()
}

class MainTableDetailCoordinator: BaseCoodinator {

    private var navigationController: UINavigationController
    weak var output: MainTableDetailCoordinatorOutput?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        let mainTableDetailModel = MainTableDetailViewModel()
        let mainTableDetailVC = MainTableDetailViewController(viewModel: mainTableDetailModel)
        mainTableDetailVC.delegate = self
        mainTableDetailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(mainTableDetailVC, animated: true)

    }
}
extension MainTableDetailCoordinator: MainTableDetailViewControllerDelegate {
    func goToBackToTable() {
        output?.coordinatorWantsToBackToTable()
    }

}
