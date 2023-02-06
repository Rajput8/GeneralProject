import Foundation

enum ValidatorType {
    case email
    case password
    case username

    var typeRawValue: String {
        switch self {
        case .email: return "email"
        case .password: return "password"
        case .username: return "username"
        }
    }
}
