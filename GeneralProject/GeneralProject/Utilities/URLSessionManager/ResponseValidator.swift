import Foundation
import UIKit

class ResponseValidator {

    static func validateResponse(_ response: URLResponse) -> BasicAPIModel? {
        if let httpResponse = response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            if statusCode != 200 {
                let errMessage = "server_err".localized()
                let response = BasicAPIModel.init(false, .httpError)
                response.errorMessage = errMessage
                return response
            }
        }
        return nil
    }

    static func validateResponseData(_ responseData: Data?) -> (BasicAPIModel?, Data?) {
        guard responseData != nil else {
            let errMessage = "null_data_in_response".localized()
            let response = BasicAPIModel.init(false, .invalidResponse)
            response.errorMessage = errMessage
            return (response, nil)
        }
        return (nil, responseData)
    }

    static func parseError(_ request: URLRequest, _ responseFull: String?, _ error: Error, _ delegate: APIRequestDelegate?) {
        var errDesc = "full response: \(responseFull ?? "response data not parseable to string")"
        if let err = error as? DecodingError { errDesc = "\(err)" }
        debugPrint("\(errDesc)")
        delegate?.apiRequestFailure("parse_error_message".localized(), .parsingError)
    }
}
