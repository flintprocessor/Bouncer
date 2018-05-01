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
        let (optionNameArgument, value) = "-f./VALUE".optionNameArgumentAndValue()!
        XCTAssertEqual(optionNameArgument, "-f")
        XCTAssertEqual(value, "./VALUE")
    }

    func testParseLongOptionNameWithValue() {
        let (optionNameArgument, value) = "--path=./path".optionNameArgumentAndValue()!
        XCTAssertEqual(optionNameArgument, "--path")
        XCTAssertEqual(value, "./path")
    }

    func testParseInvalidOptionNameWithValue() {
        // White space
        XCTAssertNil("".optionNameArgumentAndValue())
        XCTAssertNil(" ".optionNameArgumentAndValue())
        XCTAssertNil("  ".optionNameArgumentAndValue())
        // Dash
        XCTAssertNil("-".optionNameArgumentAndValue())
        XCTAssertNil("--".optionNameArgumentAndValue())
        XCTAssertNil("---".optionNameArgumentAndValue())
        // Special characters
        XCTAssertNil("-.".optionNameArgumentAndValue())
        XCTAssertNil("--.123".optionNameArgumentAndValue())
        XCTAssertNil("--1]23".optionNameArgumentAndValue())
        // Invalid format
        XCTAssertNil("---flag".optionNameArgumentAndValue())
        XCTAssertNil("- -fVALUE".optionNameArgumentAndValue())
        XCTAssertNil("- --flag=value".optionNameArgumentAndValue())
        XCTAssertNil("--flagvalue".optionNameArgumentAndValue())
    }

    static let allTests = [
        ("testParseShortOptionNameWithValue", testParseShortOptionNameWithValue),
        ("testParseLongOptionNameWithValue", testParseLongOptionNameWithValue),
        ("testParseInvalidOptionNameWithValue", testParseInvalidOptionNameWithValue)
    ]
}
