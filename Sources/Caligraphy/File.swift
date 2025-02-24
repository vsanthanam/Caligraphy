// Caligraphy
// File.swift
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

/// A model that represents a text file
public struct File: Sendable {

    // MARK: - Initializers

    /// Create a file
    /// - Parameters:
    ///   - name: The name of the file
    ///   - fileExtension: The file extension, if any
    ///   - content: The contents of the file
    public init(
        _ name: String,
        fileExtension: String? = nil,
        content: String
    ) {
        self.name = name
        self.fileExtension = fileExtension
        self.content = content
    }

    /// Create a file
    /// - Parameters:
    ///   - name: The name of the file
    ///   - fileExtension: The file extension, if any
    ///   - content: The contents of the file, if any
    public init(
        _ name: String,
        fileExtension: String? = nil,
        @Caligraphy content: () -> some Stroke
    ) {
        self.init(
            name,
            fileExtension: fileExtension,
            content: String(content: content)
        )
    }

    // MARK: - API

    /// The name of the file
    public let name: String

    /// The file extension
    public let fileExtension: String?

    /// The contents of the file
    public private(set) var content: String

    /// Create a new file by appending content to this one
    /// - Parameter content: The additional content to append to the file
    /// - Returns: The new file
    public func appendingContent(
        _ content: String
    ) -> File {
        .init(
            name,
            fileExtension: fileExtension,
            content: self.content + content
        )
    }

    /// Create a new file by appending content to this one
    /// - Parameter additionalContent: The additional content to append to the file
    /// - Returns: The new file
    public func appendingContent(
        @Caligraphy additionalContent: () -> some Stroke
    ) -> File {
        appendingContent(
            String(
                content: additionalContent
            )
        )
    }

    /// Appending additional content to the file
    /// - Parameter content: The additional content to append to the file
    public mutating func appendContent(
        _ content: String
    ) {
        self.content += content
    }

    /// Appending additional content to the file
    /// - Parameter additionalContent: The additional content to append to the file
    public mutating func appendContent(
        @Caligraphy additionalContent: () -> some Stroke
    ) {
        appendContent(
            String(
                content: additionalContent
            )
        )
    }

    /// Write the file to disk
    /// - Parameters:
    ///   - destination: The destination file URL
    ///   - encoding: The string encoding
    /// - Returns: The URL that the file was written to
    @discardableResult
    public func writeToDisk(
        at destination: URL,
        encoding: String.Encoding = .utf8
    ) async throws -> URL {
        guard destination.isFileURL else {
            throw FileError("Parent URL is not file URL")
        }
        try content.write(
            to: destination,
            atomically: false,
            encoding: encoding
        )
        try Task.checkCancellation()
        return destination
    }

    // MARK: - Private

    @discardableResult
    func writeToDisk(
        encoding: String.Encoding = .utf8
    ) async throws -> URL {
        let destination = try FileOperation.current.appending(
            path: fullName,
            directoryHint: .notDirectory
        )
        return try await writeToDisk(at: destination, encoding: encoding)
    }

    var fullName: String {
        if let fileExtension {
            name + "." + fileExtension
        } else {
            name
        }
    }
}

struct FileError: Error, CustomStringConvertible {

    init(_ message: String) {
        self.message = message
    }

    let message: String

    var description: String { message }

}
