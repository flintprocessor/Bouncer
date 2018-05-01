//
//  String+Option.swift
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

// MARK: - Option
public extension String {

    /// A Boolean value indicating whether
    /// the string is option name or not by
    /// matching with short and long option name regex.
    public var isOptionName: Bool {
        return match(withRegex: shortOptionNameRegex)
            || match(withRegex: longOptionNameRegex)
    }

    /// A Boolean value indicating whether the string
    /// is option name with value or not by matching
    /// with short and long option name with value regex.
    public var isOptionNameWithValue: Bool {
        return match(withRegex: shortOptionNameWithValueRegex)
            || match(withRegex: longOptionNameWithValueRegex)
    }

    /// Parse option name and value if possible.
    ///
    /// - Returns: Option name and value if it is in correct format.
    public func optionNameAndValue() -> (String, String)? {
        if match(withRegex: shortOptionNameWithValueRegex) {
            let separatorIndex = index(startIndex, offsetBy: 2)
            let optionName = String(prefix(upTo: separatorIndex))
            let value = String(suffix(from: separatorIndex))
            return (optionName, value)
        } else if match(withRegex: longOptionNameWithValueRegex) {
            let separatorIndex = index(of: "=")!
            let optionName = String(prefix(upTo: separatorIndex))
            let value = String(suffix(from: index(separatorIndex, offsetBy: 1)))
            return (optionName, value)
        }
        return nil
    }
}
