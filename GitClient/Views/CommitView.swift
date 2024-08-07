//
//  CommitView.swift
//  GitClient
//
//  Created by Makoto Aoyama on 2022/10/01.
//

import SwiftUI

struct CommitView: View {
    var diff: String
    var folder: Folder
    @State private var commitMessage = ""
    @State private var error: Error?
    var onCommit: ()->Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                if let diff = try? Diff(raw: diff) {
                    HStack {
                        VStack(alignment: .leading) {
                            DiffView(diff: diff)
                        }
                        .padding()
                        Spacer()
                    }
                } else {
                    Text(diff)
                        .padding()
                }
            }
            .textSelection(.enabled)
            .font(Font.system(.body, design: .monospaced))
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(1)
            .background(Color(NSColor.textBackgroundColor))
            Divider()
            HStack (spacing:0) {
                ZStack {
                    TextEditor(text: $commitMessage)
                        .padding(8)
                    if commitMessage.isEmpty {
                        Text("Enter commit message here")
                            .foregroundColor(.secondary)
                            .allowsHitTesting(false)
                    }
                }
                Divider()
                Button("Commit") {
                    Task {
                        do {
                            try await Process.output(GitAdd(directory: folder.url))
                            try await Process.output(GitCommit(directory: folder.url, message: commitMessage))
                            onCommit()
                        } catch {
                            self.error = error
                        }
                    }
                }
                .keyboardShortcut(.init(.return))
                .errorAlert($error)
                .disabled(commitMessage.isEmpty)
                .padding()
            }
            .frame(height: 100)
            .background(Color(NSColor.textBackgroundColor))
        }
    }
}

struct CommitView_Previews: PreviewProvider {
    static var previews: some View {
        CommitView(diff: """
diff --git a/GitClient/Views/DiffView.swift b/GitClient/Views/DiffView.swift
index 0cd5c16..114b4ae 100644
--- a/GitClient/Views/DiffView.swift
+++ b/GitClient/Views/DiffView.swift
@@ -11,11 +11,25 @@ struct DiffView: View {
     var diff: String

     var body: some View {
-        ScrollView {
-            Text(diff)
-                .font(Font.system(.body, design: .monospaced))
-                .frame(maxWidth: .infinity, alignment: .leading)
-                .padding()
+        ZStack {
+            ScrollView {
+                Text(diff)
+                    .textSelection(.enabled)
+                    .font(Font.system(.body, design: .monospaced))
+                    .frame(maxWidth: .infinity, alignment: .leading)
+                    .padding()
+            }
+            VStack {
+                Spacer()
+                HStack {
+                    Spacer()
+                    Button("Commit") {
+
+                    }
+                    .padding()
+                }
+                .background(.ultraThinMaterial)
+            }
         }
     }
 }
diff --git a/GitClient/Views/DiffView.swift b/GitClient/Views/DiffView.swift
index 0cd5c16..114b4ae 100644
--- a/GitClient/Views/DiffView.swift
+++ b/GitClient/Views/DiffView.swift
@@ -11,11 +11,25 @@ struct DiffView: View {
     var diff: String

     var body: some View {
-        ScrollView {
-            Text(diff)
-                .font(Font.system(.body, design: .monospaced))
-                .frame(maxWidth: .infinity, alignment: .leading)
-                .padding()
+        ZStack {
+            ScrollView {
+                Text(diff)
+                    .textSelection(.enabled)
+                    .font(Font.system(.body, design: .monospaced))
+                    .frame(maxWidth: .infinity, alignment: .leading)
+                    .padding()
+            }
+            VStack {
+                Spacer()
+                HStack {
+                    Spacer()
+                    Button("Commit") {
+
+                    }
+                    .padding()
+                }
+                .background(.ultraThinMaterial)
+            }
         }
     }
 }

""", folder: .init(url: .init(string: "file:///maoyama")!), onCommit: {})
    }
}
