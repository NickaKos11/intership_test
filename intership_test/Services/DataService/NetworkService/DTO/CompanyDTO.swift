import Foundation

struct CompanyDTO: Decodable {
    let name: String
    let employees: [EmployeeDTO]
}
