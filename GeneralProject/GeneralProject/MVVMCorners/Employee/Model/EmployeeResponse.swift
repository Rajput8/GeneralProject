import Foundation
import RxDataSources

// MARK: - EmployeeResponse
struct EmployeeResponse: Codable {
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

// MARK: - ListResponse
struct ListResponse: Codable {
    let data: ListData?
}

// MARK: - ListData
struct ListData: Codable {
    let name: String?
    let email: String?
    let categories: [Category]?
}

// MARK: - Category
struct Category: Codable {
    let name: String?
    var products: [Product]?
}

// MARK: - Product
struct Product: Codable {
    let name: String?
    let location: String?
}

extension Category: SectionModelType {
    var items: [Product] {
        return products ?? []
    }

    typealias Items = [Product]
    init(original: Category, items: Items) {
        self = original
        self.products = items
    }
}
