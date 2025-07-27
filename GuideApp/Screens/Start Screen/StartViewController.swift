import UIKit

// MARK: - стартовый экран

protocol StartViewControllerDelegate: AnyObject {
    func goToLoginScreen()
}

class StartViewController: UIViewController {

    private var contentView: StartView = .init()

    weak var delegate: StartViewControllerDelegate?

    override func loadView() {
        view = contentView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6

        contentView.delegate = self
    }

}
extension StartViewController: NextScreenStartViewDelegate {
    func nextScreenButtonDidPressed() {
        delegate?.goToLoginScreen()
    }
}
