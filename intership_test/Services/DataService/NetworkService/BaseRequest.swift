import Foundation

protocol HTTPRequest {
    func execute<T: Decodable>(
        url: URL,
        session: URLSession,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

struct BaseRequest: HTTPRequest {

    func execute<T>(
        url: URL,
        session: URLSession,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) where T: Decodable {
        let task = session.dataTask(with: url) {data, response, error in

            if error != nil {
                completion(.failure(NetworkError.notNet))
                return
            }

            if response as? HTTPURLResponse == nil {
                return completion(.failure(NetworkError.emptyResponseError))
            }

            guard let unwrappedData = data else {
                completion(.failure(NetworkError.emptyDataError))
                return
            }

            guard let result = try? JSONDecoder().decode(
                T.self,
                from: unwrappedData
            ) else {
                completion(.failure(NetworkError.parsingError))
                return
            }
            completion(.success(result))
        }
        task.resume()
    }
}
