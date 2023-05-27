import Foundation
import RxSwift
import RxCocoa
import RxRelay

class RxEmployeeViewModel {

    var employeesData = BehaviorRelay<[EmployeeData]>(value: [])
    var categoriesListData = BehaviorRelay<[Category]>(value: [])
    var isRequestHasErr = BehaviorRelay<Bool>(value: false)
    var requestErrMessage = BehaviorRelay<String?>(value: nil)
    var disposeBag = DisposeBag()

    var errorMessage: Driver<String?> {
        return requestErrMessage.asDriver()
    }

    func getEmpDataAPI() {
        let requestParams = APIRequestParams(.login, .post)
        SessionDataTask.dataTask(type: EmployeeResponse.self, requestParams) { response in
            switch response {
            case .success(let resp):
                guard let data = resp.data else { return }
                self.isRequestHasErr.accept(false)
                self.employeesData.accept(data)
            case .failure(let error):
                self.isRequestHasErr.accept(true)
                self.requestErrMessage.accept(error.localizedDescription)
            }
        }
    }

    func getListFromJson() {
        guard let listData = HelperUtil.loadDataFromJson(),
              let categoriesData = listData.data?.categories else { return }
        self.categoriesListData.accept(categoriesData)
    }

    func uploadMediaContent() {
        let image = UIImage(named: "appLogo")
        if let imageData = image?.pngData() {
            let params = ["type": 1, "serial_number": 1]
            let multipartParams = MultipartMediaRequestParams(filename: "appLogo", data: imageData, keyname: .media, contentType: .imagePNG)
            let requestParams = APIRequestParams(.updateProfilePic, .post, .multipartFormData, nil, params, [multipartParams])
            SessionUploadTask.uploadTask(type: ImageUpload.self, requestParams) { response in
                switch response {
                case .success(let resp):
                    LogHandler.reportLogOnConsole(nil, "resp is: \(resp)")
                case .failure(let error):
                    self.isRequestHasErr.accept(true)
                    self.requestErrMessage.accept(error.localizedDescription)
                }
            }
        }
    }

    func numberOfRowsInSection() -> Int {
        return employeesData.value.count
    }

    func cellForRowAt(at indexPath: IndexPath) -> EmployeeData? {
        return employeesData.value[indexPath.row]
    }
}

struct ImageUpload: Codable {
    let statusCode: Int?
    let success, profilePic: String?

    enum CodingKeys: String, CodingKey {
        case statusCode
        case success
        case profilePic = "profile_pic"
    }
}
