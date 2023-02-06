import Foundation
import RxSwift
import RxCocoa

class EmployeesViewModel {

    var employeesData: ObservableUtil<[EmployeeData]> = ObservableUtil([])

    func getEmpDataAPI() {
        let requestParams = APIRequestParams(.login, self, nil, nil)
        SessionDataTask.dataTask(type: EmployeeModel.self, requestParams)
    }

    func numberOfRowsInSection() -> Int {
        return employeesData.value.count
    }

    func cellForRowAt(at indexPath: IndexPath) -> EmployeeData? {
        return employeesData.value[indexPath.row]
    }
}

// MARK: APIRequest Delegate
extension EmployeesViewModel: APIRequestDelegate {
    func apiRequestFailure(_ errorMessage: String, _ failureType: APIFailureTypes) {
        debugPrint("error message is: \(errorMessage) and failureType is: \(failureType)")
    }

    func apiRequestSuccess<T>(type: T) where T: Decodable {
        if let empResp = type as? EmployeeModel {
            DispatchQueue.main.async {
                guard let empData = empResp.data else { return }
                // Usuage 1
                self.employeesData.value = empData
                // Usuage 2 - This approache doesn't function well.
                // self.employeesData = ObservableUtil(empData)
            }
        }
    }
}
