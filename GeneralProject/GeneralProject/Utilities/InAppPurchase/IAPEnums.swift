import Foundation

enum TransactionState {
    case disabled
    case restored
    case purchased
    case failed
    case emptyProducts

    var message: String {
        switch self {
        case .disabled: return "disable_purchase_in_device".localized()
        case .restored: return "restored_purchase".localized()
        case .purchased: return "bought_purchase".localized()
        case .failed: return "transactions_failed".localized()
        case .emptyProducts: return "empty_products".localized()
        }
    }
}

enum ProductTypes: String {
    case yearlySubscription
    case monthlySubscription

    var productIdentifier: String {
        switch self {
        case .yearlySubscription: return "com.general.project.YearlySubscription"
        case .monthlySubscription: return "com.general.project.MonthlySubscription"
        }
    }
}

enum ReceiptRequestError: Error {
    case missingAccountSecret
    case invalidSession
    case noActiveSubscription
    case invalidURL
    case other(Error)
    case errorMessage(_ errorDesc: String?)
}
