import Foundation

class SessionTaskResponseHandler {

    public static func taskResponseHandler<T: Decodable>(_ requestParams: APIRequestParams,
                                                         _ taskResponse: URLSessionTaskResponse,
                                                         _ type: T.Type) {
        let err = taskResponse.err
        let data = taskResponse.data
        let response = taskResponse.response
        let request = taskResponse.request

        if let err = err {
            let errMessage = err.localizedDescription
            let response = BasicAPIModel.init(false, .connectivity)
            response.errorMessage = errMessage
            SwiftSpinner.hide()
            requestParams.delegate.apiRequestFailure(response.errorMessage ?? "", .connectivity)
            return
        }

        guard let resp = response else {
            // error condition
            let failureResp = BasicAPIModel.init(false, .invalidResponse)
            failureResp.errorMessage = "null_response".localized()
            let errorMessage = failureResp.errorMessage ?? ""
            SwiftSpinner.hide()
            requestParams.delegate.apiRequestFailure(errorMessage, .nullData)
            return
        }

        // check http status codes for errors
        if let errResponse = ResponseValidator.validateResponse(resp) {
            let errorMessage = errResponse.errorMessage ?? ""
            SwiftSpinner.hide()
            requestParams.delegate.apiRequestFailure(errorMessage, .httpError)
            return
        }

        let validationResp = ResponseValidator.validateResponseData(data)
        if let errResponse = validationResp.0 {
            let errorMessage = errResponse.errorMessage ?? ""
            let failureType = errResponse.failureType ?? .unknown
            SwiftSpinner.hide()
            requestParams.delegate.apiRequestFailure(errorMessage, failureType)
            return
        } else {
            guard let respData = validationResp.1 else { return }
            let responseFull = String.init(data: respData, encoding: .utf8)
            do {
                let resp = try JSONDecoder().decode(T.self, from: respData)
                SwiftSpinner.hide()
                APIConstants.currentAPIEndpoint = requestParams.endpoint
                requestParams.delegate.apiRequestSuccess(type: resp.self)
            } catch {
                SwiftSpinner.hide()
                ResponseValidator.parseError(request, responseFull, error, requestParams.delegate)
            }
        }
    }
}
