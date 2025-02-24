// Caligraphy
// AccumulateStrokes.swift
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

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
struct AccumulateStrokes<each Accumulated, Next>: Stroke where repeat each Accumulated: Stroke, Next: Stroke {

    // MARK: - Initializers

    init(
        accumulated: repeat each Accumulated,
        next: Next
    ) {
        self.accumulated = (repeat (each accumulated))
        self.next = next
    }

    // MARK: - Stroke

    var content: String? {
        var result: String?
        func append(_ component: String) {
            if let current = result {
                result = current + Caligraphy.separator + component
            } else {
                result = component
            }
        }
        for component in repeat each accumulated {
            if let content = component.content {
                append(content)
            }
        }
        if let content = next.content {
            append(content)
        }
        return result
    }

    // MARK: - Private

    private let accumulated: (repeat (each Accumulated))
    private let next: Next

}
