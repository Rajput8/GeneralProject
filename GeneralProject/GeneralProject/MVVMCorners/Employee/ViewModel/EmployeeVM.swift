import Foundation

class EmployeesViewModel {

    var employeesData: ObservableUtil<[EmployeeData]> = ObservableUtil([])

    func getEmpDataAPI() {
        let requestParams = APIRequestParams(.login, .post)
        SessionDataTask.dataTask(type: EmployeeResponse.self, requestParams) { response in
            switch response {
            case .success(let empResp):
                guard let empData = empResp.data else { return }
                // Usuage 1
                self.employeesData.value = empData
                // Usuage 2 - This approache doesn't function well.
                // self.employeesData = ObservableUtil(empData)

            case .failure(let error):
                LogHandler.reportLogOnConsole(nil, error.localizedDescription)
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
