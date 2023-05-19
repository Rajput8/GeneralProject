import Foundation

// MARK: - InAppPurchaseReceiptResponse
struct InAppPurchaseReceiptResponse: Codable {
    let status: Int
    let environment: String
    let receipt: Receipt
    let pendingRenewalInfo: [PendingRenewalInfo]
    let latestReceipt: String
    let latestReceiptInfo: [LatestReceiptInfo]

    enum CodingKeys: String, CodingKey {
        case status, environment, receipt
        case pendingRenewalInfo = "pending_renewal_info"
        case latestReceipt = "latest_receipt"
        case latestReceiptInfo = "latest_receipt_info"
    }
}

// MARK: - LatestReceiptInfo
struct LatestReceiptInfo: Codable {
    let expiresDate: String
    let expiresDateMS: String
    let expiresDatePst, inAppOwnershipType: String
    let isInIntroOfferPeriod, isTrialPeriod: String
    let originalPurchaseDate: String
    let originalPurchaseDateMS: String
    let originalPurchaseDatePst: String
    let originalTransactionID: String
    let productID, purchaseDate: String
    let purchaseDateMS: String
    let purchaseDatePst: String
    let quantity: String
    let subscriptionGroupIdentifier: String?
    let transactionID, webOrderLineItemID: String

    enum CodingKeys: String, CodingKey {
        case expiresDate = "expires_date"
        case expiresDateMS = "expires_date_ms"
        case expiresDatePst = "expires_date_pst"
        case inAppOwnershipType = "in_app_ownership_type"
        case isInIntroOfferPeriod = "is_in_intro_offer_period"
        case isTrialPeriod = "is_trial_period"
        case originalPurchaseDate = "original_purchase_date"
        case originalPurchaseDateMS = "original_purchase_date_ms"
        case originalPurchaseDatePst = "original_purchase_date_pst"
        case originalTransactionID = "original_transaction_id"
        case productID = "product_id"
        case purchaseDate = "purchase_date"
        case purchaseDateMS = "purchase_date_ms"
        case purchaseDatePst = "purchase_date_pst"
        case quantity
        case subscriptionGroupIdentifier = "subscription_group_identifier"
        case transactionID = "transaction_id"
        case webOrderLineItemID = "web_order_line_item_id"
    }
}

// MARK: - PendingRenewalInfo
struct PendingRenewalInfo: Codable {
    let autoRenewProductID: String
    let autoRenewStatus, expirationIntent, isInBillingRetryPeriod, originalTransactionID: String?
    let productID: String

    enum CodingKeys: String, CodingKey {
        case autoRenewProductID = "auto_renew_product_id"
        case autoRenewStatus = "auto_renew_status"
        case expirationIntent = "expiration_intent"
        case isInBillingRetryPeriod = "is_in_billing_retry_period"
        case originalTransactionID = "original_transaction_id"
        case productID = "product_id"
    }
}

// MARK: - Receipt
struct Receipt: Codable {
    let adamID, appItemID: Int
    let applicationVersion: String
    let bundleID: String
    let downloadID: Int
    let inApp: [LatestReceiptInfo]
    let originalApplicationVersion, originalPurchaseDate: String
    let originalPurchaseDateMS: String
    let originalPurchaseDatePst, receiptCreationDate: String
    let receiptCreationDateMS: String
    let receiptCreationDatePst, receiptType, requestDate: String
    let requestDateMS: String
    let requestDatePst: String
    let versionExternalIdentifier: Int

    enum CodingKeys: String, CodingKey {
        case adamID = "adam_id"
        case appItemID = "app_item_id"
        case applicationVersion = "application_version"
        case bundleID = "bundle_id"
        case downloadID = "download_id"
        case inApp = "in_app"
        case originalApplicationVersion = "original_application_version"
        case originalPurchaseDate = "original_purchase_date"
        case originalPurchaseDateMS = "original_purchase_date_ms"
        case originalPurchaseDatePst = "original_purchase_date_pst"
        case receiptCreationDate = "receipt_creation_date"
        case receiptCreationDateMS = "receipt_creation_date_ms"
        case receiptCreationDatePst = "receipt_creation_date_pst"
        case receiptType = "receipt_type"
        case requestDate = "request_date"
        case requestDateMS = "request_date_ms"
        case requestDatePst = "request_date_pst"
        case versionExternalIdentifier = "version_external_identifier"
    }
}
