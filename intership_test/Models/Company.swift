import Foundation

struct Company {
    let name: String
    let employess: [Employee]

    init(from dto: CompaniesDTO) {
        name = dto.company.name
        employess = dto.company.employees.map { Employee(from: $0) }
    }
}
