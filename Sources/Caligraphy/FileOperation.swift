// Caligraphy
// FileOperation.swift
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

enum FileOperation {

    @TaskLocal
    static var path: [String] = []

    @TaskLocal
    static var root: URL? = nil

    static var current: URL {
        get throws {
            guard var current = FileOperation.root else {
                throw FileError("No file operation in progress")
            }
            for path in FileOperation.path {
                current = current.appending(path: path, directoryHint: .isDirectory)
            }
            return current
        }
    }

    @discardableResult
    static func perform<T>(
        at root: URL,
        fn: () throws -> T
    ) rethrows -> T {
        try FileOperation.$root.withValue(
            root,
            operation: fn
        )
    }

    @discardableResult
    static func perform<T>(
        at root: URL,
        fn: () async throws -> T
    ) async rethrows -> T {
        try await FileOperation.$root.withValue(
            root,
            operation: fn
        )
    }

    @discardableResult
    static func push<T>(
        _ component: String,
        fn: () throws -> T
    ) rethrows -> T {
        try FileOperation.$path.withValue(
            FileOperation.path + [component],
            operation: fn
        )
    }

    @discardableResult
    static func push<T>(
        _ component: String,
        fn: () async throws -> T
    ) async rethrows -> T {
        try await FileOperation.$path.withValue(
            FileOperation.path + [component],
            operation: fn
        )
    }

}
