//
//  BranchesView.swift
//  GitClient
//
//  Created by Makoto Aoyama on 2022/10/02.
//

import SwiftUI

struct BranchesView: View {
    var folder: Folder
    var onSelect: ((Branch) -> Void)
    var onSelectMergeInto: ((Branch) -> Void)
    var onSelectNewBranchFrom: ((Branch) -> Void)
    @State private var branches: [Branch] = []
    @State private var error: Error?
    @State private var selectedBranch: Branch?

    var body: some View {
        List(branches, id: \.name) { branch in
            HStack {
                Text(branch.name)
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onSelect(branch)
            }
            .contextMenu {
                if !branch.isCurrent {
                    Button("Marge into \"\(branches.current?.name ?? "")\"") {
                        onSelectMergeInto(branch)
                    }
                }
                Button("New Branch from \"\(branch.name)\"") {
                    onSelectNewBranchFrom(branch)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .task {
            do {
                branches = try await Process.output(GitBranch(directory: folder.url))
            } catch {
                self.error = error
            }
        }
        .frame(width: 300, height: 660)
        .errorAlert($error)
    }
}

struct BranchesView_Previews: PreviewProvider {
    static var previews: some View {
        BranchesView(
            folder: .init(url: .init(string: "file://hoge")!),
            onSelect: { _ in }, 
            onSelectMergeInto: { _ in },
            onSelectNewBranchFrom: { _ in }
        )
    }
}
