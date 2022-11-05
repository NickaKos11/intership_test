import Foundation

protocol CompanyDataCacheServiceProtocol {
    func saveAll(
        data: CompaniesDTO,
        completion: @escaping (Result<CompaniesDTO, Error>) -> Void
    )

    func loadAll(
        completion: @escaping (Result<Company, Error>) -> Void
    )
}

final class CompanyDataCacheService: CompanyDataCacheServiceProtocol {

    private let concurrentQueue: DispatchQueue
    private let completionQueue: DispatchQueue

    private let fileName: String

    init(
        completionQueue: DispatchQueue = DispatchQueue.main,
        concurrentQueue: DispatchQueue = DispatchQueue(
            label: "concurrentQueue",
            attributes: .concurrent
        ),
        fileName: String = Strings.fileName
    ) {
        self.concurrentQueue = concurrentQueue
        self.completionQueue = completionQueue
        self.fileName = fileName
    }

    func saveAll(
        data: CompaniesDTO,
        completion: @escaping (Result<CompaniesDTO, Error>
        ) -> Void) {
        concurrentQueue.async {[weak self] in

            guard let self = self else {
                return
            }

            do {
                let fileURL = self.getPath(to: self.fileName)
                let result = try JSONEncoder().encode(data)
                try result.write(to: fileURL)
                self.completionQueue.async {
                    completion(.success(data))
                }
            } catch {
                self.completionQueue.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func loadAll(
        completion: @escaping (Result<Company, Error>) -> Void
    ) {
        concurrentQueue.async { [weak self] in

            guard let self = self else {
                return
            }

            do {
                let fileURL = self.getPath(to: self.fileName)
                let data = try Data(contentsOf: fileURL)
                let result = try JSONDecoder().decode(
                    CompaniesDTO.self,
                    from: data
                )
                self.completionQueue.async {
                    completion(.success(Company(from: result)))
                }
            } catch {
                self.completionQueue.async {
                    completion(.failure(error))
                }
            }
        }
    }

    private func getPath(to file: String) -> URL {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = documentDirectoryURL.appendingPathComponent(file)
        return fileUrl
    }
}

private enum Strings {
    static let fileName = "company.json"
}
