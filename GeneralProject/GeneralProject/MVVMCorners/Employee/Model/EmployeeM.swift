import Foundation

// MARK: - EmployeeModel
struct EmployeeModel: Decodable {
    let status: String?
    let data: [EmployeeData]?
}

// MARK: - Datum
struct EmployeeData: Codable {
    let id: Int?
    let employeeName: String?
    let employeeSalary, employeeAge: Int?
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case employeeName = "employee_name"
        case employeeSalary = "employee_salary"
        case employeeAge = "employee_age"
        case profileImage = "profile_image"
    }
}

// typealias EmployeeModel = [EmployeeData]
