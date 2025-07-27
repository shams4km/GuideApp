import UIKit

// MARK: - ячейки таблицы фильтрации по городу

class FilterTableViewCell: UITableViewCell {
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium, width: .condensed)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension FilterTableViewCell {
    private func configureView() {
        contentView.backgroundColor = .systemGray6

        contentView.addSubview(cityNameLabel)

        cityNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 80))
        }
    }
}
extension FilterTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self) + "_filter"
    }

    func configureCell(with cityName: String) {
        cityNameLabel.text = cityName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cityNameLabel.text = nil
    }

}
