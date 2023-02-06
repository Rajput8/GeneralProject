import Foundation

class ValidatorRegex {
    public static func isValidPassword(pwd: String) -> Bool {
        return checkRegEx(for: pwd, regEx: "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$")
    }

    public static func isValidEmail(email: String) -> Bool {
        return checkRegEx(for: email, regEx: "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$")
    }

    private static func checkRegEx(for string: String, regEx: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: string)
    }
}
