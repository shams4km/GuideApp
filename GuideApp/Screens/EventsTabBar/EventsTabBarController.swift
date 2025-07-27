import UIKit

// MARK: - класс таб бар контроллера

class EventsTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}
