import Foundation

struct CompaniesDTO: Decodable {
    let company: CompanyDTO
}

struct CompanyDTO: Decodable {
    let name: String
    let employees: [EmployeeDTO]
}

struct EmployeeDTO: Decodable {
    let name: String
    let phoneNumber: String
    let skills: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone_number"
        case skills
    }
}
