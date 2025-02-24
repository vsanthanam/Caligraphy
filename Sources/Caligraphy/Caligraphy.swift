// Caligraphy
// Caligraphy.swift
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

/// A declarative API for building strings
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@resultBuilder
public enum Caligraphy {

    /// An implementation detail of the `@Caligraphy` result builder.
    ///
    /// This type method is used to support string expressions.
    ///
    /// - Important: Do not call this method directly. It's designed to be invoked only by compiler-synthesized code produced when using the `@Caligraphy` result builder
    public static func buildExpression(
        _ expression: some StringProtocol
    ) -> StringStroke {
        StringStroke(expression)
    }

    /// An implementation detail of the `@Caligraphy` result builder.
    ///
    /// This type method is used to support ``Stroke`` expressions.
    ///
    /// - Important: Do not call this method directly. It's designed to be invoked only by compiler-synthesized code produced when using the `@Caligraphy` result builder
    public static func buildExpression<T>(
        _ expression: T
    ) -> T where T: Stroke {
        expression
    }

    /// An implementation detail of the `@Caligraphy` result builder.
    ///
    /// This type method is used to accumulate strokes together, sequentially.
    ///
    /// - Important: Do not call this method directly. It's designed to be invoked only by compiler-synthesized code produced when using the `@Caligraphy` result builder
    public static func buildPartialBlock<T>(
        first: T
    ) -> T where T: Stroke {
        first
    }

    /// An implementation detail of the `@Caligraphy` result builder.
    ///
    /// This type method is used to accumulate strokes together, sequentially.
    ///
    /// - Important: Do not call this method directly. It's designed to be invoked only by compiler-synthesized code produced when using the `@Caligraphy` result builder
    public static func buildPartialBlock<each Accumulated, Next>(
        accumulated: repeat each Accumulated,
        next: Next
    ) -> some Stroke where repeat each Accumulated: Stroke, Next: Stroke {
        AccumulateStrokes(
            accumulated: repeat each accumulated,
            next: next
        )
    }

    /// An implementation detail of the `@Caligraphy` result builder.
    ///
    /// This type method is used to support `if else` control flow.
    ///
    /// - Important: Do not call this method directly. It's designed to be invoked only by compiler-synthesized code produced when using the `@Caligraphy` result builder
    public static func buildEither<First, Second>(
        first component: First
    ) -> _EitherStroke<First, Second> where First: Stroke, Second: Stroke {
        .first(component)
    }

    /// An implementation detail of the `@Caligraphy` result builder.
    ///
    /// This type method is used to support `if else` control flow.
    ///
    /// - Important: Do not call this method directly. It's designed to be invoked only by compiler-synthesized code produced when using the `@Caligraphy` result builder
    public static func buildEither<First, Second>(
        second component: Second
    ) -> _EitherStroke<First, Second> where First: Stroke, Second: Stroke {
        .second(component)
    }

    /// An implementation detail of the `@Caligraphy` result builder.
    ///
    /// This type method is used to support `if` control flow
    ///
    /// - Important: Do not call this method directly. It's designed to be invoked only by compiler-synthesized code produced when using the `@Caligraphy` result builder
    @Caligraphy
    public static func buildOptional<T>(
        _ component: T?
    ) -> some Stroke where T: Stroke {
        if let component {
            component
        } else {
            SkipStroke()
        }
    }

    /// An implementation detail of the `@Caligraphy` result builder.
    ///
    /// This type method is used to support `for` loops.
    ///
    /// - Important: Do not call this method directly. It's designed to be invoked only by compiler-synthesized code produced when using the `@Caligraphy` result builder
    public static func buildArray<T>(
        _ components: [T]
    ) -> some Stroke where T: Stroke {
        StrokeList(components)
    }

    /// An implementation detail of the `@Caligraphy` result builder.
    ///
    /// This type method is used to support availability checks.
    ///
    /// - Important: Do not call this method directly. It's designed to be invoked only by compiler-synthesized code produced when using the `@Caligraphy` result builder
    public static func buildLimitedAvailability(
        _ component: some Stroke
    ) -> AnyStroke {
        AnyStroke(component)
    }

    @TaskLocal
    static var separator: String = "\n"

}
