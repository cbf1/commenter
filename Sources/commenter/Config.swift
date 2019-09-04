import Foundation
import SPMUtility

internal struct Config {

    private enum Option {
        static let owner: String = "--owner"
        static let repo: String = "--repo"
        static let token: String = "--token"
        static let issue: String = "--issue"
        static let id: String = "--id"
        static let comment: String = "--comment"
    }

    public let owner: String
    public let repo: String
    public let token: String
    public let issue: Int
    public let id: String?
    public let comment: String

    public init(version versionInformation: String, arguments: [String] = Array(CommandLine.arguments[1...])) throws {

        let parser = ArgumentParser(usage: "[OPTIONS]", overview: "GitHub Commenter")

        let versionArgument = parser.add(option: "--version",
                                         shortName: "-v",
                                         kind: Bool.self,
                                         usage: "Version")

        let ownerArgument = parser.add(option: Option.owner,
                                       kind: String.self,
                                       usage: "Owner")

        let repoArgument = parser.add(option: Option.repo,
                                      kind: String.self,
                                      usage: "Repository")

        let tokenArgument = parser.add(option: Option.token,
                                       kind: String.self,
                                       usage: "Token")

        let issueArgument = parser.add(option: Option.issue,
                                       kind: Int.self,
                                       usage: "Issue")

        let idArgument = parser.add(option: Option.id,
                                    kind: String.self,
                                    usage: "Identifier")

        let commentArgument = parser.add(option: Option.comment,
                                         kind: String.self,
                                         usage: "Comment")

        let result: ArgumentParser.Result

        do {
            result = try parser.parse(arguments)
        } catch {
            throw FatalError.argumentParsingFailed(error: error)
        }

        if let version = result.get(versionArgument), version {
            print(versionInformation)
            exit(0)
        }

        guard let owner = result.get(ownerArgument) else {
            throw FatalError.missingRequiredOption(option: Option.owner)
        }

        guard let repo = result.get(repoArgument) else {
            throw FatalError.missingRequiredOption(option: Option.repo)
        }

        guard let token = result.get(tokenArgument) else {
            throw FatalError.missingRequiredOption(option: Option.token)
        }

        guard let issue = result.get(issueArgument) else {
            throw FatalError.missingRequiredOption(option: Option.issue)
        }

        self.owner = owner
        self.repo = repo
        self.token = token
        self.issue = issue
        self.id = result.get(idArgument)

        if let comment = result.get(commentArgument) {
            self.comment = comment
        } else {
            guard let comment = readLine() else {
                throw FatalError.missingRequiredOption(option: Option.comment)
            }
            self.comment = comment
        }
    }
}
