//
//  Status.swift
//  GitClient
//
//  Created by Makoto Aoyama on 2024/09/06.
//

import Foundation

struct Status {
    var untrackedFiles: [String]
    var untrackedFilesShortStat: String {
        if untrackedFiles.isEmpty {
            return ""
        } else if untrackedFiles.count == 1 {
            return "1 untracked file"
        } else {
            return "\(untrackedFiles.count) untracked files"
        }
    }
}