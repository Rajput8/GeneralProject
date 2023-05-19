import Foundation

struct Validator {
    var email: String?
    var password: String?
    var username: String?

    init(with email: String? = nil, password: String? = nil, username: String? = nil) throws {
        // validate email
        if let email = email?.trimmed() {
            guard !EmailPropertyWrapper(email).wrappedValue.isEmpty else {
                throw ValidationError.reason(reason: "email_err".localized(), .email)
            }

            guard !email.isEmpty else { throw ValidationError.empty(.email) }
            self.email = email
        }

        // validate password
        if let pwd = password?.trimmed() {
            guard !pwd.isEmpty else { throw ValidationError.empty(.password) }
            guard ValidatorRegex.isValidPassword(pwd: pwd) else {
                throw ValidationError.invalidWithReason(reason: "invalid_password".localized(), .password)
            }
            self.password = pwd
        }

        // validate username
        if let username = username?.trimmed() {
            guard !username.isEmpty else { throw ValidationError.empty(.username) }
            self.username = username
        }
    }
}

@propertyWrapper
class EmailPropertyWrapper {
    private var emailValue: String
    var wrappedValue: String {
        get { return ValidatorRegex.isValidEmail(email: emailValue) ? emailValue : "" }
        set { emailValue = newValue }
    }
    init(_ email: String) { emailValue = email }
}
