//
//  OptionValueArrayIterateTests.swift
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

final class OptionValueArrayIterateTests: XCTestCase {

    func testFindArgument() {
        let path = Option(name: "path", optional: false, argumentType: .required)
        let optionValues = [
            OptionValue(name: "path", value: "."),
            OptionValue(name: "verbose")
        ]

        XCTAssertEqual(optionValues.findArgument(for: path), ".")
    }

    func testFindOptionalArgument() {
        let path = Option(name: "path", optional: true, argumentType: .optional(nil))
        let optionValues = [
            OptionValue(name: "path", value: "."),
            OptionValue(name: "verbose")
        ]

        XCTAssertEqual(optionValues.findArgument(for: path), ".")
    }

    func testNotFindOptionalArgumentWithNoOptionValue() {
        let path = Option(name: "path", optional: true, argumentType: .optional(nil))
        let optionValues = [
            OptionValue(name: "verbose")
        ]

        XCTAssertNil(optionValues.findOptionalArgument(for: path))
    }

    func testNotFindOptionalArgumentWithNoValue() {
        let path = Option(name: "path", optional: true, argumentType: .optional(nil))
        let optionValues = [
            OptionValue(name: "path"),
            OptionValue(name: "verbose")
        ]

        XCTAssertNil(optionValues.findOptionalArgument(for: path))
    }

    func testHavingOption() {
        let verbose = Option(name: "verbose", optional: true, argumentType: .none)
        let optionValues = [
            OptionValue(name: "path", value: "."),
            OptionValue(name: "verbose")
        ]

        XCTAssertTrue(optionValues.have(verbose))
    }

    func testNotHavingOption() {
        let verbose = Option(name: "verbose", optional: true, argumentType: .none)
        let optionValues = [
            OptionValue(name: "path", value: "."),
        ]

        XCTAssertFalse(optionValues.have(verbose))
    }

    static let allTests = [
        ("testFindArgument", testFindArgument),
        ("testFindOptionalArgument", testFindOptionalArgument),
        ("testNotFindOptionalArgumentWithNoOptionValue", testNotFindOptionalArgumentWithNoOptionValue),
        ("testNotFindOptionalArgumentWithNoValue", testNotFindOptionalArgumentWithNoValue),
        ("testHavingOption", testHavingOption),
        ("testNotHavingOption", testNotHavingOption)
    ]
}
