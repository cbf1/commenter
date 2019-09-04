import Foundation

internal struct GitHubInteractor {

    private enum Method: String {
        case GET, POST, PATCH
    }

    public let token: String

    private let urlSession: URLSession = .shared

    public func get(_ path: String) throws -> Any {
        return try perform(request(path))
    }

    public func post<T: Encodable>(_ path: String, payload: T) throws {
        try perform(request(path, method: .POST, body: encode(payload)))
    }

    public func patch<T: Encodable>(_ path: String, payload: T) throws {
        try perform(request(path, method: .PATCH, body: encode(payload)))
    }

    private func encode<T: Encodable>(_ payload: T) throws -> Data {
        do {
            return try JSONEncoder().encode(payload)
        } catch {
            throw FatalError.jsonEncodingFailed(type: type(of: payload))
        }
    }

    private func request(_ path: String, method: Method = .GET, body: Data? = nil) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        guard let url = components.url else { throw FatalError.invalidRequest(path: path) }
        var request = URLRequest(url: url)
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.httpMethod = "\(method)"
        request.httpBody = body
        return request
    }

    @discardableResult
    private func perform(_ request: URLRequest) throws -> Any {
        var result: Result<Data, FatalError> = .failure(.networkRequestDidNotComplete)
        let semaphone = DispatchSemaphore(value: 0)
        urlSession.dataTask(with: request) { data, response, error in
            defer { semaphone.signal() }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                result = .failure(.invalidStatusCode(statusCode: nil))
                return
            }
            guard (200..<300).contains(statusCode) else {
                result = .failure(.invalidStatusCode(statusCode: statusCode))
                return
            }
            if let data = data {
                result = .success(data)
            } else if let error = error {
                result = .failure(.networkRequestFailed(error: error))
            }
        }.resume()
        semaphone.wait()
        switch result {
        case let .success(data):
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                throw FatalError.jsonParsingFailed(error: error)
            }
        case let .failure(error):
            throw error
        }
    }
}
