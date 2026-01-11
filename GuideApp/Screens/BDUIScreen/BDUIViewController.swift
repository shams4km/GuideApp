import UIKit
import SnapKit

// MARK: - Models
struct BDUIScreenData: Codable {
    let screenTitle: String
    let components: [BDUIComponent]
}

struct BDUIComponent: Codable {
    let type: String
    let text: String?
    let style: String? // "header", "body"
    let url: String?
}

// MARK: - Controller
class BDUIViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        loadData()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    private func loadData() {
        guard let url = Bundle.main.url(forResource: "bdui_screen", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load generic JSON")
            return
        }
        
        do {
            let screenData = try JSONDecoder().decode(BDUIScreenData.self, from: data)
            title = screenData.screenTitle
            render(components: screenData.components)
        } catch {
            print("Error decoding BDUI: \(error)")
        }
    }
    
    private func render(components: [BDUIComponent]) {
        for component in components {
            let view = createView(for: component)
            stackView.addArrangedSubview(view)
        }
    }
    
    private func createView(for component: BDUIComponent) -> UIView {
        switch component.type {
        case "text":
            let label = UILabel()
            label.text = component.text
            label.numberOfLines = 0
            if component.style == "header" {
                label.font = .systemFont(ofSize: 24, weight: .bold)
            } else {
                label.font = .systemFont(ofSize: 16)
            }
            return label
            
        case "image":
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.backgroundColor = .systemGray5
            
            imageView.snp.makeConstraints { make in
                make.height.equalTo(200)
            }
            
            if let urlString = component.url {
                Task {
                    if let image = try? await ImageNetworkManager.shared.downloadImage(by: urlString) {
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                }
            }
            return imageView
            
        default:
            return UIView()
        }
    }
}
