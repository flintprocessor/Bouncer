//
//  OptionValue+Array.swift
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

// MARK: - OptionValue
public extension Array where Element: OptionValue {

    /// Find argument for option with forced unwrapping.
    ///
    /// - Parameter option: Option to test against this array.
    /// - Returns: Argument value for option.
    public func findArgument(for option: Option) -> String {
        return findOptionValue(for: option.name)!.value!
    }

    /// Find argument for option optionally.
    ///
    /// - Parameter option: Option to test against this array.
    /// - Returns: Argument value for option if the array has; otherwise, nil.
    public func findOptionalArgument(for option: Option) -> String? {
        return findOptionValue(for: option.name)?.value
    }

    /// Check if array has specific option value for option.
    ///
    /// - Parameter option: Option to test against this array.
    /// - Returns: True if the array has option value for option; otherwise, false.
    public func have(_ option: Option) -> Bool {
        return findOptionValue(for: option.name) != nil
    }

    /// Find option value for option name.
    ///
    /// - Parameter optionName: Option name to check.
    /// - Returns: Option value with the name; if does not exist, nil.
    private func findOptionValue(for optionName: String) -> OptionValue? {
        return first { $0.name == optionName }
    }
}
