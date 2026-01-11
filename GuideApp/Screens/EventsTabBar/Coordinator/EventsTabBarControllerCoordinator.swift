import UIKit

// MARK: - координатор таб бар контроллера

protocol EventsTabBarControllerCoordinatorOutput: AnyObject {
    func signOut()
}

class EventsTabBarControllerCoordinator: BaseCoodinator {

    private let eventsTabBarController: EventsTabBarController

    let mainViewControllerCoordinator = MainViewControllerCoordinator(navigationController: UINavigationController())
    let profileViewControllerCoordinator = ProfileViewControllerCoordinator(
        navigationController: UINavigationController()
    )
    weak var output: EventsTabBarControllerCoordinatorOutput?

    init(eventsTabBarController: EventsTabBarController) {
        self.eventsTabBarController = eventsTabBarController
        super.init()
    }

    override func start() {

        if !childCoordinators.isEmpty {
            childCoordinators.removeAll()
        }

        let mainNavigationController = UINavigationController()
        mainNavigationController.tabBarItem = UITabBarItem(
            title: "Main",
            image: UIImage(systemName: "house"),
            tag: 1
        )
        mainViewControllerCoordinator.navigationController = mainNavigationController
        mainViewControllerCoordinator.start()

        let profileNavigationController = UINavigationController()
        profileViewControllerCoordinator.output = self
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            tag: 2
        )
        profileViewControllerCoordinator.navigationController = profileNavigationController
        profileViewControllerCoordinator.start()

        let bduiViewController = BDUIViewController()
        let bduiNavigationController = UINavigationController(rootViewController: bduiViewController)
        bduiNavigationController.tabBarItem = UITabBarItem(
            title: "Offers",
            image: UIImage(systemName: "star.fill"),
            tag: 3
        )

        let tabBarControllers = [mainNavigationController, profileNavigationController, bduiNavigationController]
        eventsTabBarController.viewControllers = tabBarControllers
    }

}

extension EventsTabBarControllerCoordinator: ProfileViewControllerCoordinatorOutput {
    func signOut() {
        output?.signOut()
    }
}
