import Foundation
import RxSwift

/// 네트워크 요청을 처리하는 싱글톤 클래스입니다.
/// 재사용 가능한 URLSession을 사용하여 데이터를 가져옵니다.
class NetworkManager {
    /// 공유 인스턴스
    static let shared = NetworkManager()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        session = URLSession(configuration: config)

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)

            if let date = Self.iso8601WithFractionalSeconds.date(from: value) {
                return date
            }

            if let date = Self.iso8601.date(from: value) {
                return date
            }

            if let date = Self.serverDateFormatter.date(from: value) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(value)"
            )
        }
    }

    private static let iso8601WithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    private static let serverDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    // MARK: - Async/Await 버전
    
    /// 지정된 URL에서 JSON 데이터를 비동기적으로 가져와 디코딩합니다.
    /// - Parameters:
    ///   - url: JSON 데이터를 가져올 URL
    ///   - type: 디코딩할 타입
    /// - Returns: 디코딩된 객체
    /// - Throws: 네트워크 오류, HTTP 오류, 또는 디코딩 오류
    func fetch<T: Decodable>(from url: URL, type: T.Type) async throws -> T {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }
    
    // MARK: - RxSwift 버전
    
    /// 지정된 URL에서 JSON 데이터를 Observable로 가져와 디코딩합니다.
    /// - Parameters:
    ///   - url: JSON 데이터를 가져올 URL
    ///   - type: 디코딩할 타입
    /// - Returns: 디코딩된 객체를 방출하는 Observable
    func fetchObservable<T: Decodable>(from url: URL, type: T.Type) -> Observable<T> {
        return Observable.create { observer in
            let task = self.session.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    observer.onError(URLError(.badServerResponse))
                    return
                }
                do {
                    let decoded = try self.decoder.decode(T.self, from: data)
                    observer.onNext(decoded)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    // MARK: - Escaping 클로저 버전
    
    /// 지정된 URL에서 JSON 데이터를 completion handler로 가져와 디코딩합니다.
    /// - Parameters:
    ///   - url: JSON 데이터를 가져올 URL
    ///   - type: 디코딩할 타입
    ///   - completion: 결과를 처리할 클로저 (Result<T, Error>)
    func fetch<T: Decodable>(with url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            do {
                let decoded = try self.decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


/*
// Async/Await 버전
Task {
    do {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let todo: Todo = try await NetworkManager.shared.fetch(from: url, type: Todo.self)
        print(todo)
    } catch {
        print("Error: \(error)")
    }
}

// RxSwift 버전
NetworkManager.shared.fetchObservable(from: url, type: Todo.self)
    .subscribe(onNext: { todo in
        print(todo)
    }, onError: { error in
        print("Error: \(error)")
    })
    .disposed(by: disposeBag)

// Escaping 클로저 버전
NetworkManager.shared.fetch(with: url, type: Todo.self) { result in
    switch result {
    case .success(let todo):
        print(todo)
    case .failure(let error):
        print("Error: \(error)")
    }
}
*/
