//
//  CommandValidateOptionValuesTests.swift
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

final class CommandValidateOptionValuesTests: XCTestCase {

    func testContainsAllOptionValues() {
        let path = Option(name: "path", optional: false, argumentType: .required)
        let verbose = Option(name: "verbose", optional: true, argumentType: .none)
        let help = Option(name: "help", optional: true, argumentType: .none)
        let command = Command(options: [path, verbose, help])

        XCTAssertNil(command.validateContainingRequiredOptionValuesAndReturnErrorIfNeeded([
            OptionValue(name: "path", value: "."),
            OptionValue(name: "verbose"),
            OptionValue(name: "help")
        ]))
    }

    func testContainsAllRequiredOptionValues() {
        let path = Option(name: "path", optional: false, argumentType: .required)
        let verbose = Option(name: "verbose", optional: true, argumentType: .none)
        let help = Option(name: "help", optional: true, argumentType: .none)
        let command = Command(options: [path, verbose, help])

        XCTAssertNil(command.validateContainingRequiredOptionValuesAndReturnErrorIfNeeded([
            OptionValue(name: "path", value: "."),
            OptionValue(name: "help")
        ]))
    }

    func testNotContainsRequiredOptionValues() {
        let path = Option(name: "path", optional: false, argumentType: .required)
        let branch = Option(name: "branch", optional: false, argumentType: .required)
        let verbose = Option(name: "verbose", optional: true, argumentType: .none)
        let help = Option(name: "help", optional: true, argumentType: .none)
        let command = Command(options: [path, branch, verbose, help])

        if let error = command.validateContainingRequiredOptionValuesAndReturnErrorIfNeeded([OptionValue(name: "help")]) {
            XCTAssertEqual(error, OptionParsingError.missingOptions(command, [path, branch]))
        } else {
            XCTFail()
        }
    }

    func testNotContainsAllOfRequiredOptionValues() {
        let path = Option(name: "path", optional: false, argumentType: .required)
        let branch = Option(name: "branch", optional: false, argumentType: .required)
        let verbose = Option(name: "verbose", optional: true, argumentType: .none)
        let help = Option(name: "help", optional: true, argumentType: .none)
        let command = Command(options: [path, branch, verbose, help])

        let optionValues = [OptionValue.init(name: "path", value: "."), OptionValue(name: "help")]
        if let error = command.validateContainingRequiredOptionValuesAndReturnErrorIfNeeded(optionValues) {
            XCTAssertEqual(error, OptionParsingError.missingOptions(command, [branch]))
        } else {
            XCTFail()
        }
    }

    static let allTests = [
        ("testContainsAllOptionValues", testContainsAllOptionValues),
        ("testContainsAllRequiredOptionValues", testContainsAllRequiredOptionValues),
        ("testNotContainsRequiredOptionValues", testNotContainsRequiredOptionValues),
        ("testNotContainsAllOfRequiredOptionValues", testNotContainsAllOfRequiredOptionValues)
    ]
}
