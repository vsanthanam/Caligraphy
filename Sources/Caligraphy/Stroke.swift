// Caligraphy
// Stroke.swift
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

/// A stroke is a templatizable component of a string.
///
/// When using the ``Caligraphy`` result builder, you must provide instances of types that conform to `Stroke`. You may also use strings directly,
///
/// When implementing the `Stroke` protocol, you may choose to implement it imperatively by implementing the ``content`` property, or declaratively using other `Stroke`-conforming types by implementing the ``body`` property. You should implement only one of these when conforming to `Stroke`, not both.
///
/// For example, imagine a `Human` model, which needs to introduce itself to users by producing a string.
/// You could make it conform imperatively by implementing `content` like this:
///
/// ```swift
/// struct Human: Stroke {
///
///     let name: String
///     let int: Int
///
///     var content: String? {
///         var result = "Hello! My name is \(name), and I am \(age) years old"
///         if age < 18 {
///             result += "\nI am a child"
///         } else {
///             result += "\nI am a senior citzen"
///         }
///         result += "\nNice to meet you!"
///     }
///
/// }
/// ```
///
/// The same model could be implemented declaratively like this:
///
/// ```swift
/// struct Human: Stroke {
///
///     let name: String
///     let age: Int
///
///     var body: some Stroke {
///         "Hello! My name is \(name), and I am \(age) years old"
///          if age < 18 {
///             "I am a child"
///          } else if age >= 65 {
///             "I am a senior citizen"
///          }
///          "Nice to meet you!"
///     }
/// }
/// ```
///
/// Strokes are composable, and can be combined with other strokes to form complex, multi-line strings. For example:
///
/// ```swift
/// struct Introduce: Stroke {
///
///     init(
///         _ humans: [Human],
///         filterChildren: Bool = true
///     ) {
///         self.humans = humans
///     }
///
///     let humans: [Human]
///     let filerChildren: Bool
///
///     var body: some Stroke {
///         for human in humans {
///             if human.age > 18 {
///                 "Let me introduce you to \(human.name)"
///                 human
///                     .prefixLines(with: ">> ")
///                     .tabbed()
///             }
///         }
///     }
/// }
///
/// let introductions = Introduce([
///     Human(name: "Bob", age: 12),
///     Human(name: "Jane", age: 29),
///     Human(name: "Mary", age: 68)
/// ])
/// ```
///
/// You can initialize a string from a `Stroke` using a library provided String initialilizer:
///
/// ```swift
/// let str = String(introductions)
/// print(str)
///
/// // Prints out the following:
/// //
/// // Let me introduce you to Jane
/// //     >> Hello! My name is Jane
/// //     >> Nice to meet you!
/// // Let me introduce you to Mary
/// //     >> Hello! My name is Mary
/// //     >> I am a senior citizen
/// //     >> Nice to meet you!
/// ```
///
/// ## Topics
///
/// ### Requirements
///
/// - ``Body``
/// - ``content``
/// - ``body``
///
/// ### Operators
///
/// - ``map(_:)``
/// - ``indented(_:)``
/// - ``prefixLines(with:)``
/// - ``separatedBy(_:)``
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public protocol Stroke: Sendable {

    /// The type body of the stroke, if the stroke is declarative
    ///
    /// Typically, you should not explicitly specify this type when implementing the `Stroke` protocol.
    /// Instead use the opaque type `some Stroke`, which will be provided to the compiler by the ``Caligraphy`` result builder when implementing ``body``
    /// If your Stroke is designed to be imperative, the default value of `Never` is good enough.
    associatedtype Body: Stroke = Never

    /// The body of the stroke
    ///
    /// You should implement either this propertly, or ``content`` if you want your stroke to be imperative
    ///
    /// - Warning: Do not invoke `body` on a stroke. This behavior is undefined and result in a fatal error.
    @Caligraphy
    var body: Body { get }

    /// The content of the strope
    ///
    /// You should implement either this property, or ``body`` if you want your stroke to be declarative
    var content: String? { get }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public extension Stroke {

    var body: Never {
        fatalError(
            """
            Do not invoke `body` directly. This is unsafe. It is only designed to called internally by the framework.
            """
        )
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public extension Stroke where Body: Stroke {

    var content: String? {
        body.content
    }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
extension Never: Stroke {}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public extension Stroke where Self: RawRepresentable, RawValue == String {

    var content: String? { rawValue }

}

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public extension Stroke where Self: CustomStringConvertible {

    var content: String? { description }

}
