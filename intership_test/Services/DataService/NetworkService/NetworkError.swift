import Foundation
enum NetworkError: String, Error {
    case notNet = "Отсутствует подключение к сети."
    case emptyResponseError = "Не удалось получить данные с сервера."
    case emptyDataError = "Данные отсутствуют."
    case parsingError = "Не удалось получить данные."
    case failed = "Неизвестная ошибка."
}
