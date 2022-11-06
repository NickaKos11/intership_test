import Foundation

struct Employee {
    let name: String
    let phoneNumber: String
    let skills: [String]

    init(from dto: EmployeeDTO) {
        name = dto.name
        phoneNumber = dto.phoneNumber
        skills = dto.skills
    }
}
