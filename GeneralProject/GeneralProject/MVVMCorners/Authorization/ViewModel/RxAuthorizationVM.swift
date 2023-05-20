import Foundation
import RxRelay
import RxSwift

class RxAuthorizationViewModel {

    // Create subjects/observable
    // BehaviorRelay - RxRelay
    // PublishSubject, DisposeBag - RxSwift
    // if data type not set optional, you'll be face error - No exact matches in call to instance method 'bind'
    let emailSubject = BehaviorRelay<String?>(value: "")
    let passwordSubject = BehaviorRelay<String?>(value: "")
    let usernameSubject = BehaviorRelay<String?>(value: "")
    // var isValidEnteredEmail: PublishSubject<Bool>? -- Because optional subjects are not correctly published
    var isValidEnteredEmail = PublishSubject<Bool>()
    var isValidEnteredPassword = PublishSubject<Bool>()
    var credentialsInputErrorMessage = PublishSubject<String>()
    let disposeBag = DisposeBag()

    // Observable - validate email format
    var isValidEmail: Observable<Bool> { return emailSubject.map { $0!.isEmpty } }

    var validatedData: Validator?

    // Observable - combine few conditions
    var credentialsInputStatus: Observable<CredentialsInputStatus> {
        return Observable.combineLatest(emailSubject, passwordSubject, usernameSubject) { email, password, username in
            do {
                self.validatedData = try Validator(with: email, password: password, username: username)
                self.setBehaviorRelayValuesWhenCredentialsInputAreValid()
                self.login()
            } catch let error as ValidationError {
                if let errMessage = error.validationErrorData.errMessage {
                    self.credentialsInputErrorMessage.onNext(errMessage)
                }

                if let errType = error.validationErrorData.errType {
                    if errType == .email {
                        self.isValidEnteredEmail.onNext(false)
                    } else {
                        self.isValidEnteredEmail.onNext(true)
                    }

                    if errType == .password {
                        self.isValidEnteredPassword.onNext(false)
                    } else {
                        self.isValidEnteredPassword.onNext(true)
                    }
                }
                return .incorrect
            } catch {}
            return .correct
        }
    }

    var authorizationButtonStatus: Observable<Bool> {
        credentialsInputStatus.map({
            if $0 == .correct {
                return true
            } else {
                return false
            }
        })
    }

    fileprivate func setBehaviorRelayValuesWhenCredentialsInputAreValid() {
        isValidEnteredEmail.onNext(true)
        isValidEnteredPassword.onNext(true)
        credentialsInputErrorMessage.onNext("")
    }

    func login() {
        let authorizationRequestModel = AuthorizationRequestModel(email: validatedData?.email,
                                                                  password: validatedData?.password,
                                                                  deviceType: 1,
                                                                  deviceToken: "123")
        let modelData = ParamsDataUtil.generateModelData(authorizationRequestModel)
        let requestParams = APIRequestParams(.login, .post, .data, modelData)
        SessionDataTask.dataTask(type: UserLogin.self, requestParams) { _ in }
    }

    func performInAppPurchase() {
        IAPUtil.manager.purchaseProduct(0)
        IAPUtil.manager.performActionAccordingToTransactionState()
    }
}

struct UserLogin: Codable {
    let statusCode: Int?
    let message: String?
}
