import UIKit

class LogHandler {

    public static func responseLog(_ urlString: String, _ data: Data?, _ response: URLResponse?, _ err: Error?) {
        if let err = err {  // this doesn't include 4xx and 5xx errors
            debugPrint("error: \(err.localizedDescription); \(urlString)")
            let errMessage = err.localizedDescription
            SwiftSpinner.hide()
            debugPrint("_RESPONSE_ _ERROR_ : %@ %@", urlString, errMessage)
            return
        }

        guard let resp = response else {
            SwiftSpinner.hide()
            debugPrint("_RESPONSE_ _NULL_ Null response object for url : %@", urlString)
            return
        }

        let responseDesc = "\(resp)"
        _ = responseDesc.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
        if let respData = data {
            if let JSONString = String(data: respData, encoding: String.Encoding.utf8) { print("JSONString \(JSONString)") }
        }
    }

    static func requestLog(_ request: URLRequest) { return requestLog(request, nil) }

    static func requestLog(_ request: URLRequest, _ data: Data?) {
        var requestBodyString = ""
        var requestBodyData = ""
        if let requestBodyData = request.httpBody { requestBodyString = String(decoding: requestBodyData, as: UTF8.self) }
        if let bodyData = data { requestBodyData = String(decoding: bodyData, as: UTF8.self) }
        NSLog("\(request.httpMethod ?? "") \(request) _HEADERS_ \(String(describing: request.allHTTPHeaderFields)) _BODY_ \(requestBodyString)")
        if !requestBodyData.isEmpty { debugPrint("_DATA_ \(requestBodyData)") }
    }
}
