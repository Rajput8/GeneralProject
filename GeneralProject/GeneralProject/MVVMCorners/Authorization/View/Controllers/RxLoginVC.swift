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
    @IBOutlet weak var continueBtn: UIButton!

    // MARK: - Stored Properties
    fileprivate lazy var viewModel = { RxAuthorizationViewModel() }()
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
        // SocialPlatformAuthorizationUtil.appleAuthorization(self, self, self)
    }

    @IBAction func didTapFacebookSignUp(_ sender: UIButton) {
        // SocialPlatformAuthorizationUtil.facebookAuthorization(self)
    }

    @IBAction func didTapGoogleSignUp(_ sender: UIButton) {
        // SocialPlatformAuthorizationUtil.googleAuthorization(self)
    }

    @IBAction func didTapContinue(_ sender: UIButton) {
        viewModel.login()
    }

    @IBAction func didTapInAppPurchase(_ sender: Any) {
        viewModel.performInAppPurchase()
    }

    // MARK: Helper's Method
    fileprivate func viewDidLoadSetup() {
        emailTF.addDoneButtonOnKeyboard()
        emailTF.delegate = self
        passwordTF.addDoneButtonOnKeyboard()
        passwordTF.delegate = self
        // Note: Due to use of FRP approach below implemented approach is not appropriate.
        // emailTF.addTarget(self, action: #selector(textFieldEditingChanged(_ :)), for: .editingChanged)
        // passwordTF.addTarget(self, action: #selector(textFieldEditingChanged(_ :)), for: .editingChanged)
        dataBindingHandler()
    }

    fileprivate func viewWillAppearSetup() { }

    func dataBindingHandler() {
        // bind textfields to viewModel for validation and process
        emailTF.rx.text.bind(to: viewModel.emailSubject).disposed(by: disposeBag)
        passwordTF.rx.text.bind(to: viewModel.passwordSubject).disposed(by: disposeBag)
        passwordTF.rx.text.bind(to: viewModel.usernameSubject).disposed(by: disposeBag)

        _ = viewModel.credentialsInputErrorMessage.bind(onNext: { errorMessage in
            self.authorizationErrorDescLbl.text = errorMessage
        })

        // Note: we have different way to handle publish subject
        // #Way - 1
        _ = viewModel.isValidEnteredEmail.bind { isValid in
            self.validationErrorIndicationHandler(self.emailView, isValid)
        }

        /*
         // Way - 2
         rxAuthorizationViewModel.isValidEnteredEmail.asObservable()
         .subscribe(onNext: { [weak self] (isValid) in
         self?.validationErrorIndicationHandler(self?.emailView, isValid)
         })
         .disposed(by: disposeBag)

         // Way - 3
         rxAuthorizationViewModel.isValidEnteredEmail.asObserver().subscribe { isValid in
         self.validationErrorIndicationHandler(self.emailView, isValid)
         }.disposed(by: disposeBag)
         */

        viewModel.isValidEnteredPassword.asObserver().subscribe { isValid in
            self.validationErrorIndicationHandler(self.passwordView, isValid)
        }.disposed(by: disposeBag)

        // check if form has fulfil conditions to enable submit button
        // Note: Because binding is not implemented,
        // validateCredentialsInput1 & validateCredentialsInput2 are not functional.
        // These techniques are available in textFieldEditingChanged.
        // However, since we're employing a FRP method rather than a native one, this is not a sensible policy.
        // validateCredentialsInput3()
        validateCredentialsInput4()
    }

    fileprivate func validateCredentialsInput1() {
        _ = viewModel.isValidEmail.map { status in
            if status {
                self.continueView.alpha = 1.0
            } else {
                self.continueView.alpha = 0.5
            }
        }
    }

    fileprivate func validateCredentialsInput2() {
        _ = viewModel.isValidEmail
            .map({ $0 })
            .subscribe(onNext: { isValid in
                if isValid {
                    self.continueView.alpha = 1.0
                } else {
                    self.continueView.alpha = 0.5
                }
            })
            .disposed(by: disposeBag)
    }

    fileprivate func validateCredentialsInput3() {
        // Note: bind(to: _) this clsoure is not giving so much liberty to handle
        // error according to end user friendly environment.
        // The best course of action is to utilise the bind(onNext: _) clsoure.
        // rxAuthorizationViewModel.isValidEmail.bind(to: continueView.rx.isHidden).disposed(by: disposeBag)
        _ = viewModel.isValidEmail.bind { isValid in
            if isValid {
                self.continueView.alpha = 1.0
            } else {
                self.continueView.alpha = 0.5
            }
        }
    }

    fileprivate func validateCredentialsInput4() {
        _ = viewModel.credentialsInputStatus.bind(onNext: { credentialsInputStatus in
            switch credentialsInputStatus {
            case .correct: self.continueView.alpha = 1.0
            case .incorrect: self.continueView.alpha = 0.5
            }
        })

        // check if form has fulfil conditions to enable continue button
        _ = viewModel.authorizationButtonStatus.bind(to: continueBtn.rx.isEnabled).disposed(by: disposeBag)
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
}

extension RxLoginVC: UITextFieldDelegate {
    @objc func textFieldEditingChanged(_ textField: UITextField) { }
}
