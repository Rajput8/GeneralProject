import Foundation

class ReceiptUtil {

    typealias ReceiptResponseHandler<T: Decodable> = (Result<T, ReceiptRequestError>) -> Void
    fileprivate static var subscriptionAccountSecretKey = ""
    fileprivate static var appStoreURL = "https://buy.itunes.apple.com/verifyReceipt"
    fileprivate static var sandboxURL = "https://sandbox.itunes.apple.com/verifyReceipt"

    static func getReceiptDetails<T: Decodable>(type: T.Type, _ completion: @escaping ReceiptResponseHandler<T>) {
        guard let receiptData = getReceiptDataViaAppStoreReceiptURL() else { return }
        let parameters = [
            "receipt-data": receiptData.base64EncodedString(),
            "password": subscriptionAccountSecretKey,
            "exclude-old-transactions": true
        ] as [String: Any]
        receiptDetails(parameters, completion)
    }

    fileprivate static func getReceiptDataViaAppStoreReceiptURL() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch { LogHandler.reportLogOnConsole(nil, "Error loading receipt data: \(error.localizedDescription)"); return nil }
    }

    fileprivate static func receiptDetails<T: Decodable>(_ parameters: [String: Any],
                                                         _ completion: @escaping ReceiptResponseHandler<T>) {
        LogHandler.reportLogOnConsole(nil, "^A receipt found. Validating it...")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            if let storeURL = Foundation.URL(string: appStoreURL), let sandboxURL = Foundation.URL(string: sandboxURL) {
                var request = URLRequest(url: storeURL)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                let session = URLSession(configuration: URLSessionConfiguration.default)
                LogHandler.reportLogOnConsole(nil, "^Connecting to Production...")
                let task = session.dataTask(with: request) { data, response, error in
                    // BEGIN of closure #1 - verification with Production
                    let httpResponse = response as? HTTPURLResponse
                    if let receivedData = data, error == nil, httpResponse?.statusCode == 200 {
                        LogHandler.reportLogOnConsole(nil, "^Received 200, verifying data...")
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: receivedData, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, AnyObject>,
                               let status = jsonResponse["status"] as? Int64 {
                                switch status {
                                case 0: // receipt verified in Production
                                    LogHandler.reportLogOnConsole(nil, "^Verification with Production successfull")
                                    LogHandler.reportLogOnConsole(nil, "Production Environment - Case 0: response: \(jsonResponse)")
                                    do {
                                        let resp = try JSONDecoder().decode(T.self, from: receivedData)
                                        completion(.success(resp.self))
                                    } catch {
                                        completion(.failure(.errorMessage(self.parseError(error))))
                                    }

                                case 21007: // Means that our receipt is from sandbox environment, need to validate it there instead
                                    LogHandler.reportLogOnConsole(nil, "^need to repeat evrything with Sandbox")
                                    var request = URLRequest(url: sandboxURL)
                                    request.httpMethod = "POST"
                                    request.httpBody = jsonData
                                    let session = URLSession(configuration: URLSessionConfiguration.default)
                                    LogHandler.reportLogOnConsole(nil, "^Connecting to Sandbox...")
                                    let task = session.dataTask(with: request) { data, response, error in
                                        // BEGIN of closure #2 - verification with Sandbox
                                        let httpResponse = response as? HTTPURLResponse
                                        if let receivedData = data, error == nil, httpResponse?.statusCode == 200 {
                                            LogHandler.reportLogOnConsole(nil, "^Received 200, verifying data...")
                                            do {
                                                if let jsonResponse = try JSONSerialization.jsonObject(with: receivedData, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, AnyObject>,
                                                   let status = jsonResponse["status"] as? Int64 {
                                                    switch status {
                                                    case 0: // receipt verified in Sandbox
                                                        LogHandler.reportLogOnConsole(nil, "^Verification successfull")
                                                        LogHandler.reportLogOnConsole(nil, "Sandbox Environment - Case 0: response: \(jsonResponse)")

                                                        do {
                                                            let resp = try JSONDecoder().decode(T.self, from: receivedData)
                                                            completion(.success(resp.self))
                                                        } catch {
                                                            completion(.failure(.errorMessage(self.parseError(error))))
                                                        }

                                                    default:
                                                        let errMsg = String(format: "default_sandbox_case".localized(), ["\(status)"])
                                                        completion(.failure(.errorMessage(errMsg)))
                                                    }
                                                } else {
                                                    completion(.failure(.errorMessage("failed_serialized_json".localized())))
                                                }
                                            } catch {
                                                let errMsg = String(format: "failed_create_json".localized(), [error.localizedDescription])
                                                completion(.failure(.errorMessage(errMsg)))
                                            }
                                        } else {
                                            let statusCode = "\(httpResponse?.statusCode ?? 500)"
                                            let errorDesc = error?.localizedDescription
                                            let errMsg = String(format: "failed_transactions".localized(), [statusCode, errorDesc])
                                        }
                                    }
                                    // END of closure #2 = verification with Sandbox
                                    task.resume()
                                default:
                                    let errMsg = String(format: "default_production_case".localized(), ["\(status)"])
                                    completion(.failure(.errorMessage(errMsg)))
                                }
                            } else {
                                completion(.failure(.errorMessage("failed_serialized_json".localized())))
                            }
                        } catch {
                            let errMsg = String(format: "failed_create_json".localized(), [error.localizedDescription])
                            completion(.failure(.errorMessage(errMsg)))
                        }
                    } else {
                        let statusCode = "\(httpResponse?.statusCode ?? 500)"
                        let errorDesc = error?.localizedDescription
                        let errMsg = String(format: "failed_transactions".localized(), [statusCode, errorDesc])
                    }
                }
                // END of closure #1 - verification with Production
                task.resume()
            } else {
                completion(.failure(.errorMessage("failed_url_conversion".localized())))
            }
        } catch {
            let errMsg = String(format: "failed_create_json".localized(), [error.localizedDescription])
            completion(.failure(.errorMessage(errMsg)))
        }
    }

    fileprivate static func parseError(_ error: Error) -> String {
        guard let decodingError = error as? DecodingError else { return "Response data not parseable to string" }
        return "We encountered a problem interpreting the response from the server and error is: \(decodingError)"
    }
}
