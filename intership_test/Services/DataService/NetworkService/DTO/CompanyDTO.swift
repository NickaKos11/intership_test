import Foundation

struct CompanyDTO: Codable {
    let name: String
    let employees: [EmployeeDTO]
}
