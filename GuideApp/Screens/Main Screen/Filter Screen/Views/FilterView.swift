import UIKit

// MARK: - вью таблицы фильтрации по городу

protocol FilterViewDelegate: AnyObject {
    func backBarButtonItemDidPressed()
}

class FilterView: UIView {
    private lazy var pageNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter by city:"
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 18, weight: .heavy, width: .condensed)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private lazy var cityTableView: UITableView = {
        let table = UITableView()
        table.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.reuseIdentifier)
        table.backgroundColor = .systemGray6
        table.contentInsetAdjustmentBehavior = .never
        table.rowHeight = 64
        table.showsVerticalScrollIndicator = false
        return table
    }()

    private lazy var backBarButtonItemAction = UIAction { [weak self] _ in
        self?.delegate?.backBarButtonItemDidPressed()
    }
    lazy var backBarButtonItem = UIBarButtonItem(title: "Back", primaryAction: self.backBarButtonItemAction)

    weak var delegate: FilterViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension FilterView {
    private func configureView() {
        addSubview(pageNameLabel)
        addSubview(cityTableView)

        pageNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(64)
            make.height.equalTo(24)
        }
        cityTableView.snp.makeConstraints { make in
            make.top.equalTo(pageNameLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(4)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

}
extension FilterView {
    func setupDataSource(_ dataSource: UITableViewDataSource) {
        self.cityTableView.dataSource = dataSource
    }

    func setupDelegate(_ delegate: UITableViewDelegate) {
        self.cityTableView.delegate = delegate
    }

    func reloadData() {
        cityTableView.reloadData()
    }

}
