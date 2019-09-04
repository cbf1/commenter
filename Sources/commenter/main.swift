import Foundation

do {
    let config = try Config(version: "Commenter version \(VERSION)")
    let commenter = Commenter(owner: config.owner,
                              repo: config.repo,
                              token: config.token,
                              issue: config.issue,
                              id: config.id,
                              comment: config.comment)
    try commenter.execute()
} catch {
    var standardError = FileHandle.standardError
    print("\(error)", to: &standardError)
    guard let error = error as? FatalError else { exit(-1) }
    exit(error.exitStatus)
}
