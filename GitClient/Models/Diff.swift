//
//  CombinedDiff.swift
//  GitClient
//
//  Created by Makoto Aoyama on 2024/04/07.
//

import Foundation

struct Diff {
    var fileDiffs: [FileDiff]
    var raw: String

    init(raw: String) throws {
        self.raw = raw
        fileDiffs = try ("\n" + raw).split(separator: "\ndiff").map { fileDiffRaw in
            let fileDiff = try FileDiff(raw: String("diff" + fileDiffRaw))
            return fileDiff
        }
    }
}

struct FileDiff: Identifiable {
    var id: String { raw }
    var header: String
    var extendedHeaderLines: [String]
    var fromFileToFileLines: [String]
    var chunks: [Chunk]
    var raw: String

    private static func extractChunks(from lines: [String]) -> [String] {
        var chunks: [String] = []
        var currentChunk: String?

        for line in lines {
            if line.starts(with: "@@") {
                if let hunk = currentChunk {
                    chunks.append(hunk)
                }
                currentChunk = line
            } else {
                currentChunk?.append("\n" + line)
            }
        }

        if let lastHunk = currentChunk {
            chunks.append(lastHunk)
        }

        return chunks
    }

    init(raw: String) throws {
        self.raw = raw
        let splited = raw.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }
        let firstLine = splited.first
        guard let firstLine else {
            throw GenericError(errorDescription: "Parse error for first line in FileDiff")
        }
        header = firstLine
        let fromFileIndex = splited.firstIndex { $0.hasPrefix("--- ") }
        guard let fromFileIndex else {
            print("Parse error for fromFileIndex", raw)
            throw GenericError(errorDescription: "Parse error for fromFileIndex in FileDiff")
        }
        extendedHeaderLines = splited[1..<fromFileIndex].map { String($0) }
        let toFileIndex = splited.lastIndex { $0.hasPrefix("+++ ") }
        guard let toFileIndex else {
            throw GenericError(errorDescription: "Parse error for toFileIndex in FileDiff")
        }
        fromFileToFileLines = splited[fromFileIndex...toFileIndex].map { String($0) }
        chunks = Self.extractChunks(from: splited).map { Chunk(raw: $0) }
    }
}

struct Chunk: Identifiable {
    struct Line: Identifiable {
        enum Kind {
            case removed, added, unchanged
        }
        var id: Int
        var kind: Kind {
            switch raw.first {
            case "-":
                return .removed
            case "+":
                return .added
            case " ":
                return .unchanged
            default:
                return .unchanged
            }
        }
        var raw: String

        init(id: Int, raw: String) {
            self.id = id
            self.raw = raw
        }
    }
    var id: String { raw }
    var lines: [Line]
    var raw: String

    init(raw: String) {
        self.raw = raw
        self.lines = raw.split(separator: "\n").enumerated().map { Line(id: $0.offset, raw: String($0.element)) }
    }
}
