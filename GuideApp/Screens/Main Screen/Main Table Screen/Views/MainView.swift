import UIKit

// MARK: - вью главной таблицы с ивентами

protocol MainViewDelegate: AnyObject {
    func refreshDataInTable()
}

class MainView: UIView {
    private lazy var pageNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Events"
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 18, weight: .heavy, width: .condensed)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private lazy var eventsTableView: UITableView = {
        let table = UITableView()
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        table.backgroundColor = .systemGray6
        table.contentInsetAdjustmentBehavior = .never
        table.rowHeight = 120
        table.showsVerticalScrollIndicator = false
        return table
    }()
    lazy var tableSearchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events..."
        searchController.searchBar.showsBookmarkButton = true
        return searchController
    }()
    private lazy var tableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        return refreshControl
    }()
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    weak var delegate: MainViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension MainView {
    private func configureView() {
        addSubview(eventsTableView)
        addSubview(activityIndicatorView)

        eventsTableView.addSubview(tableRefreshControl)

        eventsTableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(4)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

}
extension MainView {
    func setupDataSource(_ dataSource: UITableViewDataSource) {
        self.eventsTableView.dataSource = dataSource
    }

    func setupDelegate(_ delegate: UITableViewDelegate) {
        self.eventsTableView.delegate = delegate
    }

    func reloadData() {
        eventsTableView.reloadData()
    }

}
extension MainView {
    func startAnimatingActivityIndicator() {
        activityIndicatorView.startAnimating()
    }
    func stopAnimatingActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}
extension MainView {
    @objc func refreshTableData() {
        delegate?.refreshDataInTable()
    }
    func endRefreshing() {
        tableRefreshControl.endRefreshing()
    }
    func isRefreshing() -> Bool {
        return tableRefreshControl.isRefreshing
    }
}
extension MainView {
    func setupSearchResultsUpdater(_ searchResultsUpdater: UISearchResultsUpdating) {
        tableSearchController.searchResultsUpdater = searchResultsUpdater
    }
    func setupDelegateForSearchController(_ delegate: UISearchControllerDelegate) {
        tableSearchController.delegate = delegate
    }
    func setupDelegateForSearchBar(_ delegate: UISearchBarDelegate) {
        tableSearchController.searchBar.delegate = delegate
    }

}
