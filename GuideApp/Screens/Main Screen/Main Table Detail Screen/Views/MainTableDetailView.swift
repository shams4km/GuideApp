import UIKit

// MARK: - вью детального экрана ивента из главной таблицы

protocol MainTableDetailViewDelegate: AnyObject {
    func backBarButtonItemDidPressed()
    func bookmarkDidPressed()
}

class MainTableDetailView: UIView {
    private lazy var pageNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Event"
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 18, weight: .heavy, width: .condensed)
        label.textColor = .black
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        return label
    }()
    private lazy var backBarButtonItemAction = UIAction { [weak self] _ in
        self?.delegate?.backBarButtonItemDidPressed()
    }
    lazy var backBarButtonItem = UIBarButtonItem(title: "Back", primaryAction: self.backBarButtonItemAction)

    private lazy var bookmarkImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(bookmarkTapGestureRecognizer)
        return image
    }()
    private lazy var eventImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.layer.borderWidth = 6
        image.layer.borderColor = UIColor.vividPinkColor().cgColor
        return image
    }()
    private lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .heavy, width: .condensed)
        label.textColor = .black
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        label.numberOfLines = 4
        return label
    }()
    private lazy var ageRestrictionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .bold, width: .condensed)
        label.textColor = .systemGray2
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        return label
    }()
    private lazy var bodyAboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold, width: .condensed)
        label.textColor = .black
        label.backgroundColor = .systemGray6
        label.textAlignment = .left
        return label
    }()
    private var eventBodyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 14, weight: .medium, width: .condensed)
        textView.textColor = .systemGray2
        textView.backgroundColor = .systemGray6
        textView.isEditable = false
        textView.isScrollEnabled = true
        return textView
    }()
    private lazy var priceNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold, width: .condensed)
        label.textColor = .systemGray2
        label.text = "Price: "
        label.backgroundColor = .systemGray6
        label.textAlignment = .left
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold, width: .condensed)
        label.textColor = .systemGray2
        label.backgroundColor = .systemGray6
        label.textAlignment = .left
        return label
    }()
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold, width: .condensed)
        label.textColor = .systemGray2
        label.text = "City: "
        label.backgroundColor = .systemGray6
        label.textAlignment = .left
        return label
    }()
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold, width: .condensed)
        label.textColor = .systemGray2
        label.backgroundColor = .systemGray6
        label.textAlignment = .left
        return label
    }()
    private lazy var dateNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold, width: .condensed)
        label.textColor = .systemGray2
        label.text = "Date: "
        label.backgroundColor = .systemGray6
        label.textAlignment = .left
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold, width: .condensed)
        label.textColor = .systemGray2
        label.backgroundColor = .systemGray6
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private lazy var bookmarkTapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(bookmarkTapped)
    )

    weak var delegate: MainTableDetailViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
extension MainTableDetailView {
    private func configureView() {
        addSubview(pageNameLabel)
        addSubview(eventNameLabel)
        addSubview(ageRestrictionLabel)
        addSubview(eventImageView)

        addSubview(bodyAboutLabel)
        addSubview(eventBodyTextView)

        addSubview(cityNameLabel)
        addSubview(cityLabel)

        addSubview(priceNameLabel)
        addSubview(priceLabel)

        addSubview(dateNameLabel)
        addSubview(dateLabel)

        addSubview(bookmarkImageView)

        pageNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(64)
            make.height.equalTo(24)
        }
        bookmarkImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        eventNameLabel.snp.makeConstraints { make in
            make.top.equalTo(pageNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(70)
        }
        ageRestrictionLabel.snp.makeConstraints { make in
            make.top.equalTo(eventNameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 136, height: 12))
        }
        eventImageView.snp.makeConstraints { make in
            make.top.equalTo(ageRestrictionLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(200)
        }
        bodyAboutLabel.snp.makeConstraints { make in
            make.top.equalTo(eventImageView.snp.bottom).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide).inset(32)
            make.width.equalTo(48)
            make.height.equalTo(20)
        }
        eventBodyTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bodyAboutLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(106)
        }
        cityNameLabel.snp.makeConstraints { make in
            make.top.equalTo(eventBodyTextView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(20)
        }
        cityLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cityNameLabel.snp.centerY)
            make.leading.equalTo(cityNameLabel.snp.trailing).offset(4)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(64)
            make.height.equalTo(20)
        }
        priceNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(20)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceNameLabel.snp.centerY)
            make.leading.equalTo(priceNameLabel.snp.trailing).offset(4)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(20)
        }
        dateNameLabel.snp.makeConstraints { make in
            make.top.equalTo(priceNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateNameLabel.snp.centerY)
            make.leading.equalTo(dateNameLabel.snp.trailing).offset(4)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(20)
        }
    }
}
extension MainTableDetailView {
    func configureEventNameLabel(with text: String) {
        eventNameLabel.text = text
    }
    func configureBodyTextView(with text: String) {
        eventBodyTextView.text = text
    }
    func configureAgeRestrictionLabel(with text: String) {
        ageRestrictionLabel.text = text
    }
    func configurePriceLabel(with text: String) {
        priceLabel.text = text
    }
    func configureCityLabel(with text: String) {
        cityLabel.text = text
    }
    func configureDateLabel(with text: String) {
        dateLabel.text = text
    }
    func configureDetail(by image: UIImage) {
        eventImageView.image = image
    }
    func configureBookmarkImage(with imageName: String) {
        bookmarkImageView.image = UIImage(named: imageName)
    }
}
extension MainTableDetailView {
    func animateBookmarkChange(imageName: String, completion: @escaping () -> Void) {
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            self.bookmarkImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }

        animator.addCompletion { [weak self] _ in
            self?.bookmarkImageView.image = UIImage(named: imageName)
            UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
                self?.bookmarkImageView.transform = CGAffineTransform.identity
            }.startAnimation()
            completion()
        }

        animator.startAnimation()
    }
    @objc func bookmarkTapped() {
        delegate?.bookmarkDidPressed()
    }
}
