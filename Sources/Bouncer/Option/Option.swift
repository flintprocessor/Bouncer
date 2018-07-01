//
//  Option.swift
//  Bouncer
//
//  Copyright (c) 2018 Jason Nam (https://jasonnam.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// Option represents option argument.
/// Configurations on this class are used to parse arguments.
open class Option {

    /// Option name.
    public let name: String
    /// Short option name.
    public let shortName: Character?
    /// A Boolean value if this option is optional for the command.
    public let optional: Bool
    /// Argument accepting type.
    public let argumentType: OptionArgumentType

    /// Construct option.
    ///
    /// - Parameters:
    ///   - name: Option name. For example, `verbose`, `path` or `help`.
    ///   - shortName: Short option name. For example, `v`, `p` or `h`.
    ///   - optional: A Boolean value if this option is optional for the command.
    ///   - argumentType: Argument accepting type.
    public init(name: String, shortName: Character? = nil,
                optional: Bool, argumentType: OptionArgumentType) {
        self.name = name
        self.shortName = shortName
        self.optional = optional
        self.argumentType = argumentType
    }

    /// Returns a Boolean value indicating whether
    /// the argument matches with specified option configuration.
    ///
    /// - Parameter
    ///   - option: Option to test.
    ///   - argument: Argument to test against the option.
    /// - Returns: True if the argument matches with option configuration; otherwise, false.
    static public func ==(option: Option, argument: String) -> Bool {
        if argument.match(withRegex: shortOptionNameRegex) {
            return option.shortName != nil ? argument == "-\(option.shortName!)" : false
        } else if argument.match(withRegex: longOptionNameRegex) {
            return option.name == argument.dropFirst(2)
        }
        return false
    }
}
