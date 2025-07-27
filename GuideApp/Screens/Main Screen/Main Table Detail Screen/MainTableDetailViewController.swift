import UIKit

// MARK: - детальный экран ивента из главной таблицы

protocol MainTableDetailViewControllerDelegate: AnyObject {
    func goToBackToTable()
}

class MainTableDetailViewController: UIViewController {

    private let contentView: MainTableDetailView = .init()
    private let viewModel: MainTableDetailViewModel

    weak var delegate: MainTableDetailViewControllerDelegate?

    init(viewModel: MainTableDetailViewModel) {
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

        setupNavigationBar()

        setupEventInfo()
    }

}
extension MainTableDetailViewController {
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = contentView.backBarButtonItem
    }
}
extension MainTableDetailViewController {
    func setupEventInfo() {
        if let event = viewModel.fetchSelectedEvent() {
            let name = event.title
            let bodyText = viewModel.getConfiguredEventBodyTextView(with: event)
            let ageRestriction = viewModel.getConfiguredAgeRestrictionLabel(with: event)
            let price = viewModel.getConfiguredPriceLabel(with: event)
            let city = viewModel.getConfiguredCityLabel(with: event)
            let dates = viewModel.getConfiguredDateLabel(with: event)

            contentView.configureEventNameLabel(with: name)
            contentView.configureBodyTextView(with: bodyText)
            contentView.configureAgeRestrictionLabel(with: ageRestriction)
            contentView.configurePriceLabel(with: price)
            contentView.configureCityLabel(with: city)
            contentView.configureDateLabel(with: dates)

            let bookmarkImageName = viewModel.getBookmarkImageNameBySelectedEventBeforeAnimation(selectedEvent: event)
            contentView.configureBookmarkImage(with: bookmarkImageName)
        }

        viewModel.fetchSelectedEventImage { [weak self] image in
            if let fetchImage = image {
                self?.contentView.configureDetail(by: fetchImage)
            } else {
                if let noImage = UIImage(named: "no_photo") {
                    self?.contentView.configureDetail(by: noImage)
                }
            }
        }
    }

}
extension MainTableDetailViewController: MainTableDetailViewDelegate {
    func backBarButtonItemDidPressed() {
        delegate?.goToBackToTable()
    }
    func bookmarkDidPressed() {

        if let event = viewModel.fetchSelectedEvent() {

            if viewModel.isEventFavourite(selectedEvent: event) {
                contentView.animateBookmarkChange(imageName: "bookmark") { [weak self] in
                    self?.viewModel.deleteFavouriteEvent(with: event)
                }
            } else {
                contentView.animateBookmarkChange(imageName: "bookmark-black") { [weak self] in
                    self?.viewModel.saveFavoriteEvent(with: event)
                }
            }
        }
    }

}
