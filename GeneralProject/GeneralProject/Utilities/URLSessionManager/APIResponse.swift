import Foundation

class APIResponse {

    static func responseHandler<T: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ completion: APIConstants.Handler<T>) {
        guard let response = response as? HTTPURLResponse, let data, error == nil else {
            completion(.failure(.errorMessage("null_data_in_response".localized())))
            return
        }

        guard 200 ... 299 ~= response.statusCode else {
            if response.statusCode == 401 { // Unauthorize user
                DispatchQueue.main.async { if let destVC = R.storyboard.main.loginVC() { HelperUtil.shared.makeRootVC(destVC) } }
            } else {
                decodeResponse(type: T.self, data, completion, false)
            }
            return
        }
        decodeResponse(type: T.self, data, completion, true)
    }

    fileprivate static func decodeResponse<T: Decodable>(type: T.Type, _ data: Data, _ completion: APIConstants.Handler<T>, _ isSuccess: Bool) {
        do {
            switch isSuccess {
            case true:
                let resp = try JSONDecoder().decode(T.self, from: data)
                if let basicResponse = resp as? APIBasicResponse { showingSuccessOrErrorMessage(basicResponse) }
                completion(.success(resp.self))
            case false:
                let resp = try JSONDecoder().decode(APIBasicResponse.self, from: data)
                showingSuccessOrErrorMessage(resp)
                completion(.failure(.errorMessage(resp.message ?? "")))
            }
        } catch {
            let parseError = APIRequestResources.shared.parseError(error)
            completion(.failure(.errorMessageWithError(error, parseError)))
        }
    }

    /// Showing toast either for success's or error's message
    /// Sometime we get only api response structure as APIBasicResponse, ex: when we perform follow action, against follow action we get success message i.e. Your follow request sent to User.
    /// Above mentioned scenarion we showing Toast with 'Your follow request sent to User ' message
    /// Sometime we get error. Then we'll show Toast according to that.
    fileprivate static func showingSuccessOrErrorMessage(_ resp: APIBasicResponse) {
        HelperUtil.shared.getVisibleVC { visibleVC in
            Toast.show(message: resp.message ?? "", controller: visibleVC)
        }
    }
}

// MARK: - APIBasicResponse
struct APIBasicResponse: Codable {
    let status: Int?
    let message: String?
}
