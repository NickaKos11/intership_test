import Foundation

protocol HTTPRequest {
    func execute<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

struct BaseRequest: HTTPRequest {
    func execute<T>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        let session = BaseSession.init().session
        
        let task = session.dataTask(with: url) {data, response, error in
            
            if error != nil {
                completion(.failure(NetworkError.notNet))
                return
            }
            
            guard let _ = response as? HTTPURLResponse else {
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
        session.finishTasksAndInvalidate()
    }
}
