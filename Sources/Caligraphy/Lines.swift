// Caligraphy
// Lines.swift
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

/// A declarative stroke which joins substrokes together using a new line, forming multiple lines of text
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct Lines<Strokes>: Stroke where Strokes: Stroke {

    // MARK: - Initializers

    /// Create a multi-line stroke
    /// - Parameters:
    ///   - count: The number of new lines between each substroke. The default value is `1`
    ///   - strokes: The strokes to assemble into a multi-line stroke
    public init(
        spacing count: Int = 1,
        @Caligraphy strokes: () -> Strokes
    ) {
        self.count = count
        self.strokes = strokes()
    }

    // MARK: - Stroke

    public var body: some Stroke {
        let separator = String(String(repeating: "\n", count: count))
        strokes
            .separatedBy(separator)
    }

    // MARK: - Private

    private let count: Int
    private let strokes: Strokes

}
