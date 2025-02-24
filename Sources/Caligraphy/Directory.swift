// Caligraphy
// Directory.swift
//
// MIT License
//
// Copyright (c) 2023 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

/// A directory, containing files or subdirectories
public struct Directory: Sendable {

    /// Create a directory
    /// - Parameters:
    ///   - name: The name of the directory
    ///   - content: The directory's content
    public init(
        _ name: String,
        @DirectoryContentBuilder content: () -> [Content]
    ) {
        self.init(
            name,
            content()
        )
    }

    /// Create a directory
    /// - Parameters:
    ///   - name: The name of the directory
    ///   - content: The directory's content
    public init(
        _ name: String,
        _ content: [Content]
    ) {
        self.name = name
        self.content = content
    }

    // MARK: - API

    /// The name of the directory
    public let name: String

    /// The directory's content
    public private(set) var content: [Content]

    /// Create a new directory by appending additional content to this one
    /// - Parameter content: The content to append
    /// - Returns: The new directory
    public func appendingContent(
        _ content: [Directory.Content]
    ) -> Directory {
        .init(name, self.content + content)
    }

    /// Create a new directory by appending additional content to this one
    /// - Parameter additionalContent: The content to append
    /// - Returns: The new directory
    public func appendingContent(
        @DirectoryContentBuilder additionalContent: () -> [Content]
    ) -> Directory {
        appendingContent(additionalContent())
    }

    /// Append additional content to the directory
    /// - Parameter content: The content to append to the directory
    public mutating func appendContent(
        _ content: [Content]
    ) {
        self.content += content
    }

    /// Append additional content to the directory
    /// - Parameter additionalContent: The content to append to the directory
    public mutating func appendContent(
        @DirectoryContentBuilder additionalContent: () -> [Content]
    ) {
        appendContent(additionalContent())
    }

    /// The types of content in a directory
    public enum Content: Sendable {

        /// A file
        case file(File)

        /// A subdirectory
        case directory(Directory)

    }

    /// Write the directory to disk
    /// - Parameters:
    ///   - root: The file URL where the directory should be written to
    ///   - encoding: The string encoding to use for file content
    public func writeToDisk(
        at root: URL,
        encoding: String.Encoding = .utf8
    ) async throws {
        try await FileOperation.perform(at: root) {
            try await writeToDisk(encoding: encoding)
        }
    }

    // MARK: - Private

    @discardableResult
    func writeToDisk(
        encoding: String.Encoding = .utf8
    ) async throws -> URL {
        let fileNames = content
            .compactMap { content in
                switch content {
                case let .file(file):
                    file.fullName
                case .directory:
                    nil
                }
            }
        if Set(fileNames).count != fileNames.count {
            throw FileError("Duplicate file names found in directory \(name)")
        }
        let directoryNames = content
            .compactMap { content -> String? in
                switch content {
                case .file:
                    nil
                case let .directory(directory):
                    directory.name
                }
            }
        if Set(directoryNames).count != fileNames.count {
            throw FileError("Duplicate sub-directory names found in directory \(name)")
        }
        let directory = try FileOperation.current.appending(
            path: name,
            directoryHint: .isDirectory
        )
        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: false
        )
        try Task.checkCancellation()
        try await withThrowingTaskGroup(of: URL.self) { group in
            for content in content {
                group.addTask {
                    try await FileOperation.push(name) {
                        switch content {
                        case let .directory(directory):
                            try await directory.writeToDisk(encoding: encoding)
                        case let .file(file):
                            try await file.writeToDisk(encoding: encoding)
                        }
                    }
                }
            }
            do {
                for try await url in group {
                    print("Wrote \(url.absoluteString) to disk")
                }
            } catch {
                group.cancelAll()
                throw error
            }
        }
        return directory
    }

}
