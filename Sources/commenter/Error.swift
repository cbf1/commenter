internal enum FatalError: Error, CustomStringConvertible {

    case argumentParsingFailed(error: Error)
    case missingRequiredOption(option: String)
    case invalidRequest(path: String)
    case jsonEncodingFailed(type: Any.Type)
    case networkRequestDidNotComplete
    case invalidStatusCode(statusCode: Int?)
    case networkRequestFailed(error: Error)
    case jsonParsingFailed(error: Error)
    case invalidResponseFormat

    public var description: String {
        switch self {
        case let .argumentParsingFailed(error):
            return "Argument Parsing Failed: \(error)"
        case let .missingRequiredOption(option):
            return "Argument Parsing Failed: required option \(option)"
        case let .invalidRequest(path):
            return "Invalid Request: \(path)"
        case let .jsonEncodingFailed(type):
            return "Encoding Failed: \(type)"
        case .networkRequestDidNotComplete:
            return "Network Request Did Not Complete"
        case let .invalidStatusCode(statusCode):
            guard let statusCode = statusCode else { return "Invalid Status Code: nil" }
            return "Invalid Status Code: \(statusCode)"
        case let .networkRequestFailed(error):
            return "Network Request Failed: \(error)"
        case let .jsonParsingFailed(error):
            return "Parsing Failed: \(error)"
        case .invalidResponseFormat:
            return "Invalid Response Format"
        }
    }

    public var exitStatus: Int32 {
        switch self {
        case .argumentParsingFailed:
            return 1
        case .missingRequiredOption:
            return 2
        case .invalidRequest:
            return 3
        case .jsonEncodingFailed:
            return 4
        case .networkRequestDidNotComplete:
            return 5
        case .invalidStatusCode:
            return 6
        case .networkRequestFailed:
            return 7
        case .jsonParsingFailed:
            return 8
        case .invalidResponseFormat:
            return 9
        }
    }
}
