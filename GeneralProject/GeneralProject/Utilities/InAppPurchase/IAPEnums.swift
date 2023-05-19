import Foundation

enum TransactionState {
    case disabled
    case restored
    case purchased
    case failed
    case emptyProducts

    var message: String {
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        case .failed: return "Transactions failed"
        case .emptyProducts: return "No registered products"
        }
    }
}

enum ProductTypes: String {
    case yearlySubscription
    case monthlySubscription

    var productIdentifier: String {
        switch self {
        case .yearlySubscription: return "com.Rafaeli.VisionBoard.YearlySubscription"
        case .monthlySubscription: return "com.Rafaeli.VisionBoard.YearlySubscription"
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
