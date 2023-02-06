import UIKit

class SessionDataTask {

    public static func dataTask<T: Decodable>(type: T.Type, _ requestParams: APIRequestParams) {

        guard let request = SessionURLRequest.urlRequest(requestParams) else {
            SwiftSpinner.hide()
            requestParams.delegate.apiRequestFailure("unexpected_error".localized(), .invalidRequest)
            return
        }
        // SwiftSpinner.show("Please wait", animated: true)
        let strURL = APIRequestResources.requestURL(request: request)
        Monitor().startMonitoring { [ ] connection, reachable in
            let reachableStatus = Monitor.getCurrentConnectivityStatus(connection, reachable: reachable)
            if reachableStatus == .yes {
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    LogHandler.responseLog(strURL, data, response, error)
                    let taskResponse = URLSessionTaskResponse.init(request, data, response, error)
                    SessionTaskResponseHandler.taskResponseHandler(requestParams, taskResponse, T.self)
                })
                task.resume()
            } else {
                SwiftSpinner.hide()
                APIRequestResources.remoteErrorAlert("no_internet_connection".localized(),
                                                     "device_connected_with_internet_warning".localized())
            }
        }
    }
}
