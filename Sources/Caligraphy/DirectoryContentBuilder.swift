// Caligraphy
// DirectoryContentBuilder.swift
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

/// A result builder for building directory content
@resultBuilder
public enum DirectoryContentBuilder {

    public static func buildExpression(
        _ expression: Directory
    ) -> [Directory.Content] {
        [.directory(expression)]
    }

    public static func buildExpression(
        _ expression: File
    ) -> [Directory.Content] {
        [.file(expression)]
    }

    public static func buildBlock(
        _ components: Directory.Content...
    ) -> [Directory.Content] {
        components
    }

    public static func buildBlock(
        _ components: [Directory.Content]...
    ) -> [Directory.Content] {
        components
            .flatMap(\.self)
    }

    public static func buildEither(
        first component: [Directory.Content]
    ) -> [Directory.Content] {
        component
    }

    public static func buildEither(
        second component: [Directory.Content]
    ) -> [Directory.Content] {
        component
    }

    public static func buildOptional(
        _ component: [Directory.Content]?
    ) -> [Directory.Content] {
        if let component {
            component
        } else {
            []
        }
    }

    public static func buildArray(
        _ components: [[Directory.Content]]
    ) -> [Directory.Content] {
        components
            .flatMap(\.self)
    }

}
