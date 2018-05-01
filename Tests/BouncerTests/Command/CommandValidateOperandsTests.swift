//
//  CommandValidateOperandsTests.swift
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

final class CommandValidateOperandsTests: XCTestCase {

    func testValidateNoneOptionWithSuccess() {
        let command = Command(name: ["add"], operandType: .none)

        XCTAssertNil(command.validateOperandsAndReturnErrorIfNeeded([]))
    }

    func testValidateNoneOptionWithFailure() {
        let command = Command(name: ["add"], operandType: .none)

        if let error = command.validateOperandsAndReturnErrorIfNeeded(["operand"]) {
            XCTAssertEqual(error, OperandParsingError.invalidNumberOfOperands(command, .none, ["operand"]))
        } else {
            XCTFail()
        }
    }

    func testValidateEqualOptionWithSuccess() {
        let command = Command(name: ["add"], operandType: .equal(3))

        XCTAssertNil(command.validateOperandsAndReturnErrorIfNeeded(["1", "2", "3"]))
    }

    func testValidateEqualOptionWithFailure() {
        let command = Command(name: ["add"], operandType: .equal(3))

        if let error = command.validateOperandsAndReturnErrorIfNeeded(["1"]) {
            XCTAssertEqual(error, OperandParsingError.invalidNumberOfOperands(command, .equal(3), ["1"]))
        } else {
            XCTFail()
        }
    }

    func testValidateOptionalEqualOptionWithSuccess() {
        let command = Command(name: ["add"], operandType: .optionalEqual(3))

        XCTAssertNil(command.validateOperandsAndReturnErrorIfNeeded(["1", "2", "3"]))
        XCTAssertNil(command.validateOperandsAndReturnErrorIfNeeded([]))
    }

    func testValidateOptionalEqualOptionWithFailure() {
        let command = Command(name: ["add"], operandType: .optionalEqual(3))

        if let error = command.validateOperandsAndReturnErrorIfNeeded(["1"]) {
            XCTAssertEqual(error, OperandParsingError.invalidNumberOfOperands(command, .optionalEqual(3), ["1"]))
        } else {
            XCTFail()
        }
    }

    func testValidateRangeOptionWithSuccess() {
        let command = Command(name: ["add"], operandType: .range(1...4))

        XCTAssertNil(command.validateOperandsAndReturnErrorIfNeeded(["1"]))
        XCTAssertNil(command.validateOperandsAndReturnErrorIfNeeded(["1", "2"]))
        XCTAssertNil(command.validateOperandsAndReturnErrorIfNeeded(["1", "2", "3"]))
        XCTAssertNil(command.validateOperandsAndReturnErrorIfNeeded(["1", "2", "3", "4"]))
    }

    func testValidateRangeOptionWithFailure() {
        let command = Command(name: ["add"], operandType: .range(1...4))

        if let error = command.validateOperandsAndReturnErrorIfNeeded([]) {
            XCTAssertEqual(error, OperandParsingError.invalidNumberOfOperands(command, .range(1...4), []))
        } else {
            XCTFail()
        }
        if let error = command.validateOperandsAndReturnErrorIfNeeded(["1", "2", "3", "4", "5"]) {
            XCTAssertEqual(error, OperandParsingError.invalidNumberOfOperands(command, .range(1...4), ["1", "2", "3", "4", "5"]))
        } else {
            XCTFail()
        }
    }

    static let allTests = [
        ("testValidateNoneOptionWithSuccess", testValidateNoneOptionWithSuccess),
        ("testValidateNoneOptionWithFailure", testValidateNoneOptionWithFailure),
        ("testValidateEqualOptionWithSuccess", testValidateEqualOptionWithSuccess),
        ("testValidateEqualOptionWithFailure", testValidateEqualOptionWithFailure),
        ("testValidateOptionalEqualOptionWithSuccess", testValidateOptionalEqualOptionWithSuccess),
        ("testValidateOptionalEqualOptionWithFailure", testValidateOptionalEqualOptionWithFailure),
        ("testValidateRangeOptionWithSuccess", testValidateRangeOptionWithSuccess),
        ("testValidateRangeOptionWithFailure", testValidateRangeOptionWithFailure)
    ]
}
