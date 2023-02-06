import Foundation

enum ValidationError: Error {
    case empty(_: ValidatorType)
    case invalid(_: ValidatorType)
    case invalidWithReason(reason: String, _: ValidatorType)
    case isMatch(_: ValidatorType, ValidatorType)
    case isNotMatch(_: ValidatorType, ValidatorType)
    case reason(reason: String, _: ValidatorType)

    var validationErrorData: ValidationErrorData {
        switch self {
        case .empty(let validatorType):
            let errMessage = String(format: "empty_err_msg".localized(), arguments: [validatorType.typeRawValue])
            return ValidationErrorData(errMessage: errMessage, errType: validatorType)

        case .invalid(let validatorType):
            let errMessage = String(format: "invalid_err_msg".localized(), arguments: [validatorType.typeRawValue])
            return ValidationErrorData(errMessage: errMessage, errType: validatorType)

        case .invalidWithReason(let reason, let validatorType):
            let attr = "\(validatorType.typeRawValue)"
            let reason = "\(reason)"
            let errMessage = String(format: "invalid_with_reason_err_msg".localized(), arguments: [attr, reason])
            return ValidationErrorData(errMessage: errMessage, errType: validatorType)

        case .isMatch(let firstValidatorType, let secondValidatorType):
            let errMessage = "\(firstValidatorType.typeRawValue), \(secondValidatorType.typeRawValue)"
            return ValidationErrorData(errMessage: errMessage)

        case .isNotMatch(let firstValidatorType, let secondValidatorType):
            let firstAttrName = firstValidatorType.typeRawValue
            let secondAttrName = secondValidatorType.typeRawValue
            let errMessage = String(format: "password_not_matched".localized(), arguments: [firstAttrName, secondAttrName])
            return ValidationErrorData(errMessage: errMessage)

        case .reason(let reason, let validatorType):
            return ValidationErrorData(errMessage: reason, errType: validatorType)
        }
    }
}

struct ValidationErrorData {
    var errMessage: String?
    var errType: ValidatorType?
}

enum CredentialsInputStatus {
    case correct
    case incorrect
}
