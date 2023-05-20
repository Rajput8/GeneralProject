import Foundation

class AuthorizationViewModel {

    var credentialsInputErrorMessage: ObservableUtil<String> = ObservableUtil("")
    var isValidEnteredEmail: ObservableUtil<Bool> = ObservableUtil(false)
    var isValidEnteredPassword: ObservableUtil<Bool> = ObservableUtil(false)
    var errorMessage: ObservableUtil<String?> = ObservableUtil(nil)

    fileprivate var email = ""
    fileprivate var password = ""

    // Here our model notify that was updated
    private var credentials = AuthorizationRequestModel() {
        didSet {
            email = credentials.email ?? ""
            password = credentials.password ?? ""
        }
    }

    // Here we update our model
    func updateCredentials(email: String? = nil, password: String? = nil) {
        credentials.email = email
        credentials.password = password
    }

    func credentialsInputStatus() -> CredentialsInputStatus {
        do {
            _ = try Validator(with: email, password: password)
            setObservableValuesWhenCredentialsInputAreValid()
        } catch let error as ValidationError {
            if let errMessage = error.validationErrorData.errMessage {
                credentialsInputErrorMessage.value = errMessage
            }

            if let errType = error.validationErrorData.errType {
                if errType == .email {
                    isValidEnteredEmail.value = false
                } else {
                    isValidEnteredEmail.value = true
                }

                if errType == .password {
                    isValidEnteredPassword.value = false
                } else {
                    isValidEnteredPassword.value = true
                }
            }
            return .incorrect
        } catch {}
        return .correct
    }

    fileprivate func setObservableValuesWhenCredentialsInputAreValid() {
        isValidEnteredEmail.value = true
        isValidEnteredPassword.value = true
        credentialsInputErrorMessage.value = ""
    }

    func login() {
        self.errorMessage.value = "error.localizedDescription"
    }
}
