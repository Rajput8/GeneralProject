import UIKit

class LoginVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var authorizationErrorDescLbl: UILabel!
    @IBOutlet weak var continueView: UIView!

    // MARK: - Stored Properties
    fileprivate lazy var viewModel = { AuthorizationViewModel() }()

    // MARK: Controller's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewDidLoadSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSetup()
    }

    // MARK: IB's Action
    @IBAction func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapAppleSignUp(_ sender: UIButton) {
        // SocialPlatformAuthorizationUtil.appleAuthorization(self, self, self)
    }

    @IBAction func didTapFacebookSignUp(_ sender: UIButton) {
        // SocialPlatformAuthorizationUtil.facebookAuthorization(self)
    }

    @IBAction func didTapGoogleSignUp(_ sender: UIButton) {
        // SocialPlatformAuthorizationUtil.googleAuthorization(self)
    }

    @IBAction func didTapContinue(_ sender: UIButton) {
        debugPrint("Call api or navigate to another controller")
        viewModel.login()
    }

    // MARK: Helper's Method
    fileprivate func viewDidLoadSetup() {
        emailTF.addDoneButtonOnKeyboard()
        emailTF.delegate = self
        passwordTF.addDoneButtonOnKeyboard()
        passwordTF.delegate = self
        emailTF.addTarget(self, action: #selector(textFieldEditingChanged(_ :)), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldEditingChanged(_ :)), for: .editingChanged)
        dataBindingHandler()
    }

    fileprivate func viewWillAppearSetup() { }

    fileprivate func dataBindingHandler() {
        viewModel.credentialsInputErrorMessage.bind { [weak self] in
            self?.authorizationErrorDescLbl.text = $0
        }

        viewModel.isValidEnteredEmail.bind { [weak self] in
            self?.validationErrorIndicationHandler(self?.emailView, $0)
        }

        viewModel.isValidEnteredPassword.bind { [weak self] in
            self?.validationErrorIndicationHandler(self?.passwordView, $0)
        }

        viewModel.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            debugPrint("errorMessage is: ", errorMessage)
            // Handle presenting of error message (e.g. UIAlertController)
        }
    }

    fileprivate func validationErrorIndicationHandler(_ view: UIView?, _ isValid: Bool?) {
        if let view, let isValid {
            if isValid {
                view.borderColor = .label
            } else {
                view.borderColor = .red
            }
        }
    }

    fileprivate func validateCredentialsInput() {
        let email = emailTF.text?.trimmed()
        let pwd = passwordTF.text?.trimmed()
        // Here we ask viewModel to update model with existing credentials from text fields
        viewModel.updateCredentials(email: email, password: pwd)
        // Here we check user's credentials input - if it's correct we call login()
        switch viewModel.credentialsInputStatus() {
        case .correct: continueView.alpha = 1.0
        case .incorrect: continueView.alpha = 0.5
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        validateCredentialsInput()
    }
}
