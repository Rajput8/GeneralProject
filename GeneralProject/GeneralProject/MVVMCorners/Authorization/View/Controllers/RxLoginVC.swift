import UIKit
import RxSwift
import RxCocoa

class RxLoginVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var authorizationErrorDescLbl: UILabel!
    @IBOutlet weak var continueView: UIView!

    // MARK: - Stored Properties
    fileprivate lazy var rxAuthorizationViewModel = { RxAuthorizationViewModel() }()
    fileprivate let disposeBag = DisposeBag()

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
        SocialPlatformAuthorizationUtil.appleAuthorization(self, self, self)
    }

    @IBAction func didTapFacebookSignUp(_ sender: UIButton) {
        SocialPlatformAuthorizationUtil.facebookAuthorization(self)
    }

    @IBAction func didTapGoogleSignUp(_ sender: UIButton) {
        SocialPlatformAuthorizationUtil.googleAuthorization(self)
    }

    @IBAction func didTapContinue(_ sender: UIButton) {
        debugPrint("Call api or navigate to another controller")
    }

    // MARK: Helper's Method
    fileprivate func viewDidLoadSetup() {
        emailTF.addDoneButtonOnKeyboard()
        emailTF.delegate = self
        passwordTF.addDoneButtonOnKeyboard()
        passwordTF.delegate = self
        emailTF.addTarget(self, action: #selector(textFieldEditingChanged(_ :)), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldEditingChanged(_ :)), for: .editingChanged)
        bindSetup()
    }

    fileprivate func viewWillAppearSetup() { }

    func bindSetup() {
        // bind textfields to viewModel for validation and process
        emailTF.rx.text.bind(to: rxAuthorizationViewModel.emailSubject).disposed(by: disposeBag)
        passwordTF.rx.text.bind(to: rxAuthorizationViewModel.passwordSubject).disposed(by: disposeBag)
    }

    fileprivate func validationErrorHandler(_ view: UIView?, _ isValid: Bool?) {
        if let view, let isValid {
            if isValid {
                view.borderColor = .label
            } else {
                view.borderColor = .red
            }
        }
    }
}

extension RxLoginVC: UITextFieldDelegate {
    @objc func textFieldEditingChanged(_ textField: UITextField) {

    }
}
