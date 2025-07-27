import UIKit
import Combine

// MARK: - экран главной таблицы с ивентами

protocol MainViewControllerDelegate: AnyObject {
    func goToTableDetailScreen()
    func goToFilterScreen()
}

class MainViewController: UIViewController {

    private let contentView: MainView = .init()
    private let viewModel: MainViewModel

    private var isFirstAppearance = true

    private var cancellables = Set<AnyCancellable>()

    weak var delegate: MainViewControllerDelegate?

    init(viewModel: MainViewModel) {
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

        firstAppearance()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        // делегаты для таблицы
        contentView.setupDataSource(self)
        contentView.setupDelegate(self)

        contentView.setupSearchResultsUpdater(self)
        contentView.setupDelegateForSearchController(self)
        contentView.setupDelegateForSearchBar(self)

        contentView.delegate = self

        setupNavigationBar()

        checkingEventsEmpty()
        setupEvents()
        checkCityFilterState()
        setupSearchBarFilteredEvents()

    }
    
}
extension MainViewController {
    func setupNavigationBar() {
        navigationItem.searchController = contentView.tableSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(searchController: contentView.tableSearchController)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.configureCell(tableView, cellForRowAt: indexPath, searchController: contentView.tableSearchController)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.saveCurrentMainTableSelectedEventInEventService(
            didSelectRowAt: indexPath,
            searchController: contentView.tableSearchController
        )
        delegate?.goToTableDetailScreen()
    }
}
extension MainViewController {
    func setupEvents() {
        viewModel.eventsPublisher
            .sink { [weak self] _ in
                self?.contentView.reloadData()
            }
            .store(in: &cancellables)
    }
    func checkCityFilterState() {
        viewModel.selectedCityPublisher
            .sink { [weak self] city in
                if let city = city, city != "Reset" {
                    self?.viewModel.getAllEventsByCity(cityName: city)
                } else {
                    self?.viewModel.getAllEvents()
                }
            }
            .store(in: &cancellables)
    }
    func setupSearchBarFilteredEvents() {
        viewModel.searchBarFilteredEventsPublisher
            .sink { [weak self] _ in
                self?.contentView.reloadData()
            }
            .store(in: &cancellables)
    }
    func checkingEventsEmpty() {
        viewModel.$eventsAreEmpty
            .receive(on: DispatchQueue.main)
            .sink { [weak self] areEmpty in
                if areEmpty {
                    self?.contentView.startAnimatingActivityIndicator()
                } else {
                    self?.contentView.stopAnimatingActivityIndicator()
                }
            }
            .store(in: &cancellables)
    }
    func firstAppearance() {
        if isFirstAppearance {
            viewModel.getAllEvents()
            isFirstAppearance = false
        }
    }
}
extension MainViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        delegate?.goToFilterScreen()
        print("Search bar button called!")
    }
}
extension MainViewController: MainViewDelegate {
//    функция для обновления страницы
    func refreshDataInTable() {
        viewModel.getAllEvents()
        contentView.endRefreshing()
    }
}
