import Foundation

struct Employee {
    let name: String
    let phoneNumber: String
    let skills: [String]
    
    init(from dto: EmployeeDTO) {
        self.name = dto.name
        self.phoneNumber = dto.phoneNumber
        self.skills = dto.skills
    }
}
