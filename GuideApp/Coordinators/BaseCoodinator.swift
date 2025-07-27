import Foundation

class BaseCoodinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    
    func start() {
        fatalError("Child should implement funcStart")
    }
}
