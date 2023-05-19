// InAppPurchase - Sandbox credential
// sandeep.iaptesting@gmail.com
// Techwinlabs123$
// Product Identifier: com.Rafaeli.VisionBoard.YearlySubscription
// Bundle identifier: com.Rafaeli.Vision-Board

import StoreKit

class IAPUtil: NSObject {

    static let manager = IAPUtil()
    fileprivate var registeredProducts = [SKProduct]()
    fileprivate var productsRequest = SKProductsRequest()
    var currentTransactionState: ((TransactionState) -> Void)?

    // MARK: - Indicates whether the user is allowed to make payments.
    fileprivate var isAllowedToMakePayments: Bool { return SKPaymentQueue.canMakePayments() }

    // MARK: - Registered Products
    func getRegisteredProducts(_ type: ProductTypes) {
        guard let productIdentifiers = NSSet(objects: type.productIdentifier) as? Set<String> else { return }
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }

    // MARK: - Purchase Product
    func purchaseProduct(_ index: Int) {
        guard registeredProducts.count > 0 else { currentTransactionState?(.emptyProducts); return }
        if isAllowedToMakePayments {
            let registeredProduct = registeredProducts[index]
            let payment = SKPayment(product: registeredProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            currentTransactionState?(.disabled)
        }
    }

    // MARK: - Restore previously completed purchases
    func restoreAlreadyPurchased() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    fileprivate func populateRegisteredProductsDetail() {
        for product in registeredProducts {
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = product.priceLocale
            let price = numberFormatter.string(from: product.price) ?? "00"
            let productDetail = String(format: "in_app_purchase_product_info".localized(),
                                       arguments: [product.localizedDescription, price])
            LogHandler.reportLogOnConsole(nil, "productDetail is: \(productDetail)")
        }
    }

    func performActionAccordingToTransactionState() {
        currentTransactionState = { state in
            switch state {
            case .purchased: LogHandler.reportLogOnConsole(nil, "purchased")
                ReceiptUtil.getReceiptDetails(type: InAppPurchaseReceiptResponse.self) { response in
                    LogHandler.reportLogOnConsole(nil, "Receipt Details")
                    switch response {
                    case .success(let receiptDetails):
                        guard let latestReceiptInfo = receiptDetails.latestReceiptInfo.first else {
                            LogHandler.reportLogOnConsole(nil, "latestReceiptInfo is null")
                            return
                        }
                        LogHandler.reportLogOnConsole(nil, "current status of isTrialPeriod: \(latestReceiptInfo.isTrialPeriod)")
                    case .failure(let error): LogHandler.reportLogOnConsole(nil, error.localizedDescription)
                    }
                }

            case .restored: LogHandler.reportLogOnConsole(nil, "restored")

            case .failed: LogHandler.reportLogOnConsole(nil, "failed")

            default: break
            }
        }
    }
}

extension IAPUtil: SKProductsRequestDelegate, SKPaymentTransactionObserver {

    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard response.products.count > 0 else {
            LogHandler.reportLogOnConsole(nil, "Invalid identifier is: \(response.invalidProductIdentifiers)")
            return
        }
        registeredProducts = response.products
        populateRegisteredProductsDetail()
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for updatedTransaction in transactions {
            switch updatedTransaction.transactionState {
            case .purchasing: LogHandler.reportLogOnConsole(nil, "purchasing")

            case .purchased: LogHandler.reportLogOnConsole(nil, "purchased")
                SKPaymentQueue.default().finishTransaction(updatedTransaction)
                currentTransactionState?(.purchased)

            case .restored: LogHandler.reportLogOnConsole(nil, "restored")
                SKPaymentQueue.default().finishTransaction(updatedTransaction)
                currentTransactionState?(.restored)

            case .failed: LogHandler.reportLogOnConsole(nil, "failed")
                SKPaymentQueue.default().finishTransaction(updatedTransaction)
                currentTransactionState?(.failed)

            default: LogHandler.reportLogOnConsole(nil, "something else... please check")
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) { }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        LogHandler.reportLogOnConsole(nil, "restoreCompletedTransactionsFailedWithError is: \(error.localizedDescription)")
    }

    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        // Hide your loader - Enable interactions here
        LogHandler.reportLogOnConsole(nil, "removedTransactions")
    }

    func requestDidFinish(_ request: SKRequest) { }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        LogHandler.reportLogOnConsole(nil, "didFailWithError is: \(error.localizedDescription)")
    }
}
