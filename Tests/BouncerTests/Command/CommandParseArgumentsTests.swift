//
//  CommandParseArgumentsTests.swift
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

final class CommandParseArgumentsTests: XCTestCase {

    func testParseOperands() {
        let command = Command()

        do {
            let (operands, optionValues) = try command.parse(["1", "2", "3"])
            XCTAssertEqual(operands, ["1", "2", "3"])
            XCTAssertTrue(optionValues.isEmpty)
        } catch {
            XCTFail()
        }
    }

    func testParseNoneArgumentOptionValue() {
        let help = Option(name: "help", optional: true, argumentType: .none)
        let command = Command(options: [help])

        do {
            let (operands, optionValues) = try command.parse(["--help"])
            XCTAssertTrue(operands.isEmpty)
            XCTAssertTrue(optionValues.have(help))
            XCTAssertNil(optionValues.findOptionalArgument(for: help))
        } catch {
            XCTFail()
        }
    }

    func testParseNoneArgumentOptionValueWithArguments() {
        let help = Option(name: "help", optional: true, argumentType: .none)
        let command = Command(options: [help])

        do {
            let (operands, optionValues) = try command.parse(["1", "--help", "2", "3"])
            XCTAssertEqual(operands, ["1", "2", "3"])
            XCTAssertTrue(optionValues.have(help))
            XCTAssertNil(optionValues.findOptionalArgument(for: help))
        } catch {
            XCTFail()
        }
    }

    func testParseNoneArgumentOptionValueWithOtherOption() {
        let help = Option(name: "help", optional: true, argumentType: .none)
        let command = Command(options: [help])

        do {
            let (operands, optionValues) = try command.parse(["1", "--help", "--other", "2", "3"])
            XCTAssertEqual(operands, ["1", "2", "3"])
            XCTAssertTrue(optionValues.have(help))
            XCTAssertNil(optionValues.findOptionalArgument(for: help))
        } catch {
            XCTFail()
        }
    }

    func testParseOptionalArgumentOptionValueWithoutArgument() {
        let help = Option(name: "help", optional: true, argumentType: .optional(nil))
        let command = Command(options: [help])

        do {
            let (operands, optionValues) = try command.parse(["--help"])
            XCTAssertTrue(operands.isEmpty)
            XCTAssertTrue(optionValues.have(help))
            XCTAssertNil(optionValues.findOptionalArgument(for: help))
        } catch {
            XCTFail()
        }
    }

    func testParseOptionalArgumentOptionValueWithArgument() {
        let help = Option(name: "help", optional: true, argumentType: .optional(nil))
        let command = Command(options: [help])

        do {
            let (operands, optionValues) = try command.parse(["--help", "me"])
            XCTAssertTrue(operands.isEmpty)
            XCTAssertTrue(optionValues.have(help))
            XCTAssertEqual(optionValues.findOptionalArgument(for: help), "me")
        } catch {
            XCTFail()
        }
    }

    func testParseOptionalDefaultArgumentOptionValueWithoutArgument() {
        let help = Option(name: "help", optional: true, argumentType: .optional("me"))
        let command = Command(options: [help])

        do {
            let (operands, optionValues) = try command.parse(["--help"])
            XCTAssertTrue(operands.isEmpty)
            XCTAssertTrue(optionValues.have(help))
            XCTAssertEqual(optionValues.findOptionalArgument(for: help), "me")
        } catch {
            XCTFail()
        }
    }

    func testParseOptionalDefaultArgumentOptionValueWithArgument() {
        let help = Option(name: "help", optional: true, argumentType: .optional("me"))
        let command = Command(options: [help])

        do {
            let (operands, optionValues) = try command.parse(["--help", "her"])
            XCTAssertTrue(operands.isEmpty)
            XCTAssertTrue(optionValues.have(help))
            XCTAssertEqual(optionValues.findOptionalArgument(for: help), "her")
        } catch {
            XCTFail()
        }
    }

    func testParseRequiredArgumentOptionValueWithoutArgument() {
        let help = Option(name: "help", optional: true, argumentType: .required)
        let command = Command(options: [help])

        XCTAssertThrowsError(try command.parse(["--help"]), "help option does not have argument.") { error in
            if let error = error as? OptionParsingError {
                switch error {
                case .missingOptionArgument(let errorCommand, let errorOption):
                    XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(errorCommand))
                    XCTAssertEqual(help, errorOption)
                default:
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        }
    }

    func testParseRequiredArgumentOptionValueWithOtherOption() {
        let help = Option(name: "help", optional: true, argumentType: .required)
        let command = Command(options: [help])

        XCTAssertThrowsError(try command.parse(["--help", "--other"]), "help option does not have argument.") { error in
            if let error = error as? OptionParsingError {
                switch error {
                case .missingOptionArgument(let errorCommand, let errorOption):
                    XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(errorCommand))
                    XCTAssertEqual(help, errorOption)
                default:
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        }
    }

    func testParseRequiredArgumentOptionValueWithArgument() {
        let help = Option(name: "help", optional: true, argumentType: .required)
        let command = Command(options: [help])

        do {
            let (operands, optionValues) = try command.parse(["--help", "her"])
            XCTAssertTrue(operands.isEmpty)
            XCTAssertTrue(optionValues.have(help))
            XCTAssertEqual(optionValues.findArgument(for: help), "her")
        } catch {
            XCTFail()
        }
    }

    func testIgnoreUnsupportedOption() {
        let help = Option(name: "help", optional: true, argumentType: .required)
        let command = Command(options: [])

        do {
            let (operands, optionValues) = try command.parse(["--help", "her"])
            XCTAssertEqual(operands, ["her"])
            XCTAssertTrue(optionValues.isEmpty)
            XCTAssertFalse(optionValues.have(help))
        } catch {
            XCTFail()
        }
    }

    func testParseMultipleOperandsAndOptionValues() {
        let help = Option(name: "help", optional: true, argumentType: .none)
        let path = Option(name: "path", optional: true, argumentType: .required)
        let level = Option(name: "level", optional: true, argumentType: .optional("1"))
        let username = Option(name: "username", optional: true, argumentType: .optional(nil))
        let option = Option(name: "option", optional: true, argumentType: .optional(nil))
        let command = Command(options: [help, path, level, username, option])

        do {
            let (operands, optionValues) = try command.parse(["1", "--help", "2", "--path", ".", "3", "--level", "--username"])
            XCTAssertEqual(operands, ["1", "2", "3"])
            XCTAssertTrue(optionValues.have(help))
            XCTAssertEqual(optionValues.findArgument(for: path), ".")
            XCTAssertEqual(optionValues.findOptionalArgument(for: level), "1")
            XCTAssertNil(optionValues.findOptionalArgument(for: username))
            XCTAssertNil(optionValues.findOptionalArgument(for: option))
        } catch {
            XCTFail()
        }
    }

    static let allTests = [
        ("testParseOperands", testParseOperands),
        ("testParseNoneArgumentOptionValue", testParseNoneArgumentOptionValue),
        ("testParseNoneArgumentOptionValueWithArguments", testParseNoneArgumentOptionValueWithArguments),
        ("testParseNoneArgumentOptionValueWithOtherOption", testParseNoneArgumentOptionValueWithOtherOption),
        ("testParseOptionalArgumentOptionValueWithoutArgument", testParseOptionalArgumentOptionValueWithoutArgument),
        ("testParseOptionalArgumentOptionValueWithArgument", testParseOptionalArgumentOptionValueWithArgument),
        ("testParseOptionalDefaultArgumentOptionValueWithoutArgument", testParseOptionalDefaultArgumentOptionValueWithoutArgument),
        ("testParseOptionalDefaultArgumentOptionValueWithArgument", testParseOptionalDefaultArgumentOptionValueWithArgument),
        ("testParseRequiredArgumentOptionValueWithoutArgument", testParseRequiredArgumentOptionValueWithoutArgument),
        ("testParseRequiredArgumentOptionValueWithOtherOption", testParseRequiredArgumentOptionValueWithOtherOption),
        ("testParseRequiredArgumentOptionValueWithArgument", testParseRequiredArgumentOptionValueWithArgument),
        ("testIgnoreUnsupportedOption", testIgnoreUnsupportedOption),
        ("testParseMultipleOperandsAndOptionValues", testParseMultipleOperandsAndOptionValues)
    ]
}
