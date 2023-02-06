import Foundation

class SessionURLRequest {

    static func urlRequest(_ requestParams: APIRequestParams,
                           _ delegate: APIRequestDelegate? = nil,
                           _ boundary: String? = nil) -> URLRequest? {

        let strURL = "http://dummy.restapiexample.com/api/v1/employees"
        // "https://raw.githubusercontent.com/johncodeos-blog/MVVMiOSExample/main/demo.json"
        // updateEndPoint(requestParams)
        guard let apiUrl = URL.init(string: strURL) else {
            SwiftSpinner.hide()
            delegate?.apiRequestFailure("unexpected_error".localized(), .invalidRequest)
            return nil
        }

        var finalAPIURL = apiUrl

        if let queryParams = requestParams.queryParams {
            let stringDictionary = JsonHandler.stringAnyDictToStringDict(queryParams)
            guard let newURl = finalAPIURL.append(queryParameters: stringDictionary) else {
                SwiftSpinner.hide()
                return nil
            }
            finalAPIURL = newURl
        } else {
            finalAPIURL = apiUrl
        }

        let basicAuth = APIRequestResources.basicAuth(userName: APIConstants.apiKeyID,
                                                      password: APIConstants.apiKeySecret)

        APIConstants.headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Basic \(basicAuth)"
        ]

        var request = URLRequest.init(url: finalAPIURL)
        request.allHTTPHeaderFields = APIConstants.headers

        debugPrint("headers \(APIConstants.headers)")
        debugPrint("finalAPIURL \(finalAPIURL)")
        debugPrint("params \(requestParams.postBody ?? [:])")

        // Assign Method Type
        if let type = requestParams.mediaType {
            request.httpMethod = requestParams.methodType?.rawValue
            request.setValue(type.contentTypeHeader(boundary: boundary), forHTTPHeaderField: "Content-Type")

            if type == .json, let body = requestParams.postBody {
                request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            } else if type == .form, let body = requestParams.postBody as? [String: String] {
                request.httpBody = JsonHandler.stringDictToData(body)
            } else if type == .multipartFormData {

            } else if type == .data {
                request.httpBody = requestParams.requestModelData
            } else { }
        }
        return request
    }

    private static func updateEndPoint(_ requestParams: APIRequestParams) -> String {
        let endPoint = requestParams.endpoint
        return EndpointHandler.apiUrl(endPoint)
    }
}
