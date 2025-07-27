import UIKit
import Combine

// MARK: - экран регистрации

protocol SignUpViewControllerDelegate: AnyObject {
    func backToLoginScreen()
    func signUpUser()
}

class SignUpViewController: UIViewController {

    private let contentView: SignUpView = .init()
    private let viewModel: SignUpViewModel

    private var cancellable: AnyCancellable?

    weak var delegate: SignUpViewControllerDelegate?

    init(viewModel: SignUpViewModel) {
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
        navigationItem.hidesBackButton = true

        contentView.backLoginButtonDelegate = self
        contentView.signUpEnterButtonDelegate = self

        contentView.setupUserNameTextFieldDelegate(self)
        contentView.setupEmailTextFieldDelegate(self)
        contentView.setupPasswordTextFieldDelegate(self)
        contentView.setupPasswordCheckTextFieldDelegate(self)

        successfulySignUp()

    }
}
// из viewmodel узнаем успешно ли введены данные и регистрируем пользователя
extension SignUpViewController {
    func successfulySignUp() {
        cancellable = viewModel.$successfulySignUp
            .sink { [weak self] userSuccessfulySignUp in
                if userSuccessfulySignUp {
                    self?.delegate?.signUpUser()
                } else {
                    print("Что то пошло не так! Не удалось зарегистрироваться.")
                }
            }
    }
}
extension SignUpViewController: BackLoginButtonSignUpViewDelegate, SignUpEnterButtonSignUpViewDelegate {
    func backLoginButtonDidPressed() {
        delegate?.backToLoginScreen()
    }
    func signUpEnterButtonDidPressed(email: String, password: String, passwordAgain: String, userName: String) {
        viewModel.signUpUser(email: email, password: password, passwordAgain: passwordAgain, userName: userName)
    }
}
extension SignUpViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
