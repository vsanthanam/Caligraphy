// Caligraphy
// Map.swift
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

public extension Stroke {

    /// Map the contents of this stroke into another stroke
    /// - Parameter mapper: The mapper function
    /// - Returns: The mapped stroke
    func map(
        _ mapper: @Sendable @escaping (String) -> String?
    ) -> some Stroke {
        Map(self, mapper)
    }

}

private struct Map<Strokes>: Stroke where Strokes: Stroke {

    // MARK: - Initializers

    init(
        _ strokes: Strokes,
        _ mapper: @Sendable @escaping (String) -> String?
    ) {
        self.strokes = strokes
        self.mapper = mapper
    }

    // MARK: - Stroke

    var content: String? {
        guard let content = strokes.content else {
            return nil
        }
        return mapper(content)
    }

    // MARK: - Private

    private let strokes: Strokes
    private let mapper: @Sendable (String) -> String?
}
