//
//  ParseOptionNameAndValueTests.swift
//  BouncerTests
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

import XCTest
@testable import Bouncer

final class ParseOptionNameAndValueTests: XCTestCase {

    func testParseShortOptionNameWithValue() {
        let (optionName, value) = "-f./VALUE".optionNameAndValue()!
        XCTAssertEqual(optionName, "-f")
        XCTAssertEqual(value, "./VALUE")
    }

    func testParseLongOptionNameWithValue() {
        let (optionName, value) = "--path=./path".optionNameAndValue()!
        XCTAssertEqual(optionName, "--path")
        XCTAssertEqual(value, "./path")
    }

    func testParseInvalidOptionNameWithValue() {
        // White space
        XCTAssertNil("".optionNameAndValue())
        XCTAssertNil(" ".optionNameAndValue())
        XCTAssertNil("  ".optionNameAndValue())
        // Dash
        XCTAssertNil("-".optionNameAndValue())
        XCTAssertNil("--".optionNameAndValue())
        XCTAssertNil("---".optionNameAndValue())
        // Special characters
        XCTAssertNil("-.".optionNameAndValue())
        XCTAssertNil("--.123".optionNameAndValue())
        XCTAssertNil("--1]23".optionNameAndValue())
        // Invalid format
        XCTAssertNil("---flag".optionNameAndValue())
        XCTAssertNil("- -fVALUE".optionNameAndValue())
        XCTAssertNil("- --flag=value".optionNameAndValue())
        XCTAssertNil("--flagvalue".optionNameAndValue())
    }

    static let allTests = [
        ("testParseShortOptionNameWithValue", testParseShortOptionNameWithValue),
        ("testParseLongOptionNameWithValue", testParseLongOptionNameWithValue),
        ("testParseInvalidOptionNameWithValue", testParseInvalidOptionNameWithValue)
    ]
}
