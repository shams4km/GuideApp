import UIKit
import SnapKit

// MARK: - вью таблицы избранных ивентов

protocol FavouritesViewDelegate: AnyObject {
    func backBarButtonItemDidPressed()
}

class FavouritesView: UIView {

    private lazy var pageNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Favourite Events"
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 18, weight: .heavy, width: .condensed)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private lazy var eventsTableView: UITableView = {
        let table = UITableView()
        table.register(FavouritesTableViewCell.self, forCellReuseIdentifier: FavouritesTableViewCell.reuseIdentifier)
        table.backgroundColor = .systemGray6
        table.contentInsetAdjustmentBehavior = .never
        table.rowHeight = 120
        table.showsVerticalScrollIndicator = false
        return table
    }()
    private lazy var noDataCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Click on the bookmark on the event page to add it to your favorites"
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 14, weight: .bold, width: .condensed)
        label.textColor = .systemGray4
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    private lazy var backBarButtonItemAction = UIAction { [weak self] _ in
        self?.delegate?.backBarButtonItemDidPressed()
    }
    lazy var backBarButtonItem = UIBarButtonItem(title: "Back", primaryAction: self.backBarButtonItemAction)

    weak var delegate: FavouritesViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FavouritesView {
    private func configureView() {
        addSubview(pageNameLabel)
        addSubview(eventsTableView)
        addSubview(noDataCaptionLabel)

        pageNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(64)
            make.height.equalTo(24)
        }
        eventsTableView.snp.makeConstraints { make in
            make.top.equalTo(pageNameLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(4)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        noDataCaptionLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }

}
extension FavouritesView {
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
extension FavouritesView {
    func hideNoDataCaptionLabel(isHidden: Bool) {
        noDataCaptionLabel.isHidden = isHidden
    }
}
