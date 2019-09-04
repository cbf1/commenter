internal struct GitHubCommentInteractor {

    private struct Comment: Codable {
        let body: String
    }

    public let owner: String
    public let repo: String
    public let token: String

    private let issues: String
    private let github: GitHubInteractor

    public init(owner: String, repo: String, token: String) {

        self.owner = owner
        self.repo = repo
        self.token = token

        issues = "/repos/\(owner)/\(repo)/issues"
        github = GitHubInteractor(token: token)
    }

    public func comments(for issue: Int) throws -> [[String: Any]] {
        let response = try github.get("\(issues)/\(issue)/comments")
        guard let comments = response as? [[String: Any]] else { throw FatalError.invalidResponseFormat }
        return comments
    }

    public func comment(on issue: Int, body: String) throws {
        try github.post("\(issues)/\(issue)/comments", payload: Comment(body: body))
    }

    public func update(comment: Int, body: String) throws {
        try github.patch("\(issues)/comments/\(comment)", payload: Comment(body: body))
    }
}
