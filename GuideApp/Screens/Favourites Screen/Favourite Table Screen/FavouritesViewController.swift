import UIKit
import Combine

// MARK: - таблица избранных ивентов

protocol FavouritesViewControllerDelegate: AnyObject {
    func backToProfileScreen()
    func goToTableDetailScreen()
}
class FavouritesViewController: UIViewController {

    private let contentView: FavouritesView = .init()
    private let viewModel: FavouritesViewModel

    private var cancellables = Set<AnyCancellable>()

    weak var delegate: FavouritesViewControllerDelegate?

    init(viewModel: FavouritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.getAllUserFavouriteEventsByIdArray()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6

        contentView.setupDataSource(self)
        contentView.setupDelegate(self)
        
        contentView.delegate = self

        setupNavigationBar()
        setupEvents()
        checkingEventsEmpty()
    }

}
extension FavouritesViewController {
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = contentView.backBarButtonItem
    }
}
extension FavouritesViewController {
    func checkingEventsEmpty() {
        viewModel.$userFavouriteEventsAreEmpty
            .receive(on: DispatchQueue.main)
            .sink { [weak self] areEmpty in
                if areEmpty {
                    self?.contentView.hideNoDataCaptionLabel(isHidden: false)
                } else {
                    self?.contentView.hideNoDataCaptionLabel(isHidden: true)
                }
            }
            .store(in: &cancellables)
    }
    func setupEvents() {
        viewModel.favouriteEventsPublisher
            .sink { [weak self] _ in
                self?.contentView.reloadData()
            }
            .store(in: &cancellables)
    }

}
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.configureCell(tableView, cellForRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.saveCurrentFavouriteTableSelectedEventInEventService(didSelectRowAt: indexPath)
        delegate?.goToTableDetailScreen()
    }
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        viewModel.deleteByLeftSwipe(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    }
}
extension FavouritesViewController: FavouritesViewDelegate {
    func backBarButtonItemDidPressed() {
        delegate?.backToProfileScreen()
    }
}
