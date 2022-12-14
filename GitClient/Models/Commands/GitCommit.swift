//
//  GitCommit.swift
//  GitClient
//
//  Created by Makoto Aoyama on 2022/10/01.
//

import Foundation

struct GitCommit: Git {
    typealias OutputModel = String
    var arguments: [String] {
        [
            "commit",
            "-m",
            message,
        ]
    }
    var directory: URL
    var message: String

    func parse(for stdOut: String) -> String {
        stdOut
    }
}
