//
//  OptionCompareWithArgumentTests.swift
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

final class OptionCompareWithArgumentTests: XCTestCase {

    func testCompareLongNameOptionWithValidArguments() {
        let option = Option(name: "flag", optional: false, argumentType: .none)

        XCTAssertTrue(option == "--flag")
    }

    func testCompareLongNameOptionWithInvalidArguments() {
        let option = Option(name: "flag", optional: false, argumentType: .none)

        // White space
        XCTAssertFalse(option == "")
        XCTAssertFalse(option == " ")
        XCTAssertFalse(option == "  ")
        // Dash
        XCTAssertFalse(option == "-")
        XCTAssertFalse(option == "--")
        XCTAssertFalse(option == "---")
        // Special characters
        XCTAssertFalse(option == "-.")
        XCTAssertFalse(option == "--.123")
        XCTAssertFalse(option == "--1]23")
        // Invalid format
        XCTAssertFalse(option == "--flags")
        XCTAssertFalse(option == "- -f")
        XCTAssertFalse(option == "- --flag")
        // Wrong command
        XCTAssertFalse(option == "-b")
        XCTAssertFalse(option == "-abc")
        XCTAssertFalse(option == "--beta")
    }

    func testCompareShortNameOptionWithValidArguments() {
        let option = Option(name: "flag", shortName: "f", optional: false, argumentType: .none)

        XCTAssertTrue(option == "--flag")
        XCTAssertTrue(option == "-f")
    }

    func testCompareShortNameOptionWithInvalidArguments() {
        let option = Option(name: "flag", shortName: "f", optional: false, argumentType: .none)

        // White space
        XCTAssertFalse(option == "")
        XCTAssertFalse(option == " ")
        XCTAssertFalse(option == "  ")
        // Dash
        XCTAssertFalse(option == "-")
        XCTAssertFalse(option == "--")
        XCTAssertFalse(option == "---")
        // Special characters
        XCTAssertFalse(option == "-.")
        XCTAssertFalse(option == "--.123")
        XCTAssertFalse(option == "--1]23")
        // Invalid format
        XCTAssertFalse(option == "--flags")
        XCTAssertFalse(option == "- -f")
        XCTAssertFalse(option == "- --flag")
        // Wrong command
        XCTAssertFalse(option == "-b")
        XCTAssertFalse(option == "-abc")
        XCTAssertFalse(option == "--beta")
    }

    static let allTests = [
        ("testCompareLongNameOptionWithValidArguments", testCompareLongNameOptionWithValidArguments),
        ("testCompareLongNameOptionWithInvalidArguments", testCompareLongNameOptionWithInvalidArguments),
        ("testCompareShortNameOptionWithValidArguments", testCompareShortNameOptionWithValidArguments),
        ("testCompareShortNameOptionWithInvalidArguments", testCompareShortNameOptionWithInvalidArguments)
    ]
}
