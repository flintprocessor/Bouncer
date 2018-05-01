//
//  OptionNameWithValueValidationTests.swift
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

final class OptionNameWithValueValidationTests: XCTestCase {

    func testValidOptionNameWithValue() {
        XCTAssertTrue("-fVALUE".isOptionNameWithValue)
        XCTAssertTrue("-1value".isOptionNameWithValue)
        XCTAssertTrue("-p./path".isOptionNameWithValue)
        XCTAssertTrue("--flag=value".isOptionNameWithValue)
        XCTAssertTrue("--flag123=VALUE".isOptionNameWithValue)
        XCTAssertTrue("--path=./path".isOptionNameWithValue)
    }

    func testInvalidOptionNameWithValue() {
        // White space
        XCTAssertFalse("".isOptionNameWithValue)
        XCTAssertFalse(" ".isOptionNameWithValue)
        XCTAssertFalse("  ".isOptionNameWithValue)
        // Dash
        XCTAssertFalse("-".isOptionNameWithValue)
        XCTAssertFalse("--".isOptionNameWithValue)
        XCTAssertFalse("---".isOptionNameWithValue)
        // Special characters
        XCTAssertFalse("-.".isOptionNameWithValue)
        XCTAssertFalse("--.123".isOptionNameWithValue)
        XCTAssertFalse("--1]23".isOptionNameWithValue)
        // Invalid format
        XCTAssertFalse("---flag".isOptionNameWithValue)
        XCTAssertFalse("- -fVALUE".isOptionNameWithValue)
        XCTAssertFalse("- --flag=value".isOptionNameWithValue)
    }

    static let allTests = [
        ("testValidOptionNameWithValue", testValidOptionNameWithValue),
        ("testInvalidOptionNameWithValue", testInvalidOptionNameWithValue)
    ]
}
