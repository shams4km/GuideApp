import UIKit

// MARK: - экран таблицы фильтрации по городу

protocol FilterViewControllerDelegate: AnyObject {
    func goBackToMainTable()
}

class FilterViewController: UIViewController {

    private let contentView: FilterView = .init()
    private let viewModel: FilterViewModel

    weak var delegate: FilterViewControllerDelegate?

    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6

        contentView.delegate = self

        contentView.setupDelegate(self)
        contentView.setupDataSource(self)

        setupNavigationBar()
    }

}
extension FilterViewController {
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = contentView.backBarButtonItem
    }
}
extension FilterViewController: FilterViewDelegate {
    func backBarButtonItemDidPressed() {
        delegate?.goBackToMainTable()
    }
}
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.configureCell(tableView, cellForRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.saveCurrentFilterTableSelectedCityInLocationService(didSelectRowAt: indexPath)
        delegate?.goBackToMainTable()
    }
}
