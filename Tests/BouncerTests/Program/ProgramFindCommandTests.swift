//
//  ProgramFindCommandTests.swift
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

final class ProgramFindCommandTests: XCTestCase {

    // MARK: - Root Command
    func testFindRootCommand() {
        let rootCommand = Command()
        let program = Program(commands: [rootCommand])

        do {
            let command = try program.findCommand(forArguments: [])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(rootCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindRootCommandWithOperand() {
        let rootCommand = Command()
        let program = Program(commands: [rootCommand])

        do {
            let command = try program.findCommand(forArguments: ["operand"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(rootCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindRootCommandFromCommands() {
        let rootCommand = Command()
        let initCommand = Command(name: ["init"])
        let initPackageCommand = Command(name: ["init", "package"])
        let helpCommand = Command(name: ["help"])
        let program = Program(commands: [rootCommand, initCommand, initPackageCommand, helpCommand])

        do {
            let command = try program.findCommand(forArguments: [])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(rootCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindRootCommandFromCommandsWithOperand() {
        let rootCommand = Command()
        let initCommand = Command(name: ["init"])
        let initPackageCommand = Command(name: ["init", "package"])
        let helpCommand = Command(name: ["help"])
        let program = Program(commands: [rootCommand, initCommand, initPackageCommand, helpCommand])

        do {
            let command = try program.findCommand(forArguments: ["operand"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(rootCommand))
        } catch {
            XCTFail()
        }
    }

    func testFailToFindRootCommand() {
        let initCommand = Command(name: ["init"])
        let program = Program(commands: [initCommand])

        XCTAssertThrowsError(try program.findCommand(forArguments: []), "Should not find root command.") { error in
            if let error = error as? CommandParsingError {
                XCTAssertEqual(error, .commandNotFound)
            } else {
                XCTFail()
            }
        }
    }

    // MARK: - One Dimentional Command
    func testFindOneDimentionalCommand() {
        let initCommand = Command(name: ["init"])
        let program = Program(commands: [initCommand])

        do {
            let command = try program.findCommand(forArguments: ["init"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindOneDimentionalCommandWithOperand() {
        let initCommand = Command(name: ["init"])
        let program = Program(commands: [initCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindOneDimentionalCommandFromRootCommand() {
        let rootCommand = Command()
        let initCommand = Command(name: ["init"])
        let program = Program(commands: [rootCommand, initCommand])

        do {
            let command = try program.findCommand(forArguments: ["init"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindOneDimentionalCommandFromRootCommandWithOperand() {
        let rootCommand = Command()
        let initCommand = Command(name: ["init"])
        let program = Program(commands: [rootCommand, initCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindOneDimentionalCommandFromCommands() {
        let initCommand = Command(name: ["init"])
        let helpCommand = Command(name: ["help"])
        let program = Program(commands: [initCommand, helpCommand])

        do {
            let command = try program.findCommand(forArguments: ["init"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindOneDimentionalCommandFromCommandsWithOperand() {
        let initCommand = Command(name: ["init"])
        let helpCommand = Command(name: ["help"])
        let program = Program(commands: [initCommand, helpCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindOneDimentionalCommandFromCommandsAndRootCommand() {
        let rootCommand = Command()
        let initCommand = Command(name: ["init"])
        let helpCommand = Command(name: ["help"])
        let program = Program(commands: [rootCommand, initCommand, helpCommand])

        do {
            let command = try program.findCommand(forArguments: ["init"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindOneDimentionalCommandFromCommandsAndRootCommandWithOperand() {
        let rootCommand = Command()
        let initCommand = Command(name: ["init"])
        let helpCommand = Command(name: ["help"])
        let program = Program(commands: [rootCommand, initCommand, helpCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initCommand))
        } catch {
            XCTFail()
        }
    }

    func testFailToFindOneDimentionalCommand() {
        let initCommand = Command(name: ["init"])
        let helpCommand = Command(name: ["help"])
        let program = Program(commands: [initCommand, helpCommand])

        XCTAssertThrowsError(try program.findCommand(forArguments: ["remove", "package"]), "Should not find one dimentional command.") { error in
            if let error = error as? CommandParsingError {
                XCTAssertEqual(error, .commandNotFound)
            } else {
                XCTFail()
            }
        }
    }

    // MARK: - Two Dimentional Command
    func testFindTwoDimentionalCommand() {
        let initPackageCommand = Command(name: ["init", "package"])
        let program = Program(commands: [initPackageCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initPackageCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindTwoDimentionalCommandWithOperand() {
        let initPackageCommand = Command(name: ["init", "package"])
        let program = Program(commands: [initPackageCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package", "name"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initPackageCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindTwoDimentionalCommandFromRootCommand() {
        let rootCommand = Command()
        let initPackageCommand = Command(name: ["init", "package"])
        let program = Program(commands: [rootCommand, initPackageCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initPackageCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindTwoDimentionalCommandFromRootCommandWithOperand() {
        let rootCommand = Command()
        let initPackageCommand = Command(name: ["init", "package"])
        let program = Program(commands: [rootCommand, initPackageCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package", "name"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initPackageCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindTwoDimentionalCommandFromCommands() {
        let initCommand = Command(name: ["init"])
        let initPackageCommand = Command(name: ["init", "package"])
        let removePackageCommand = Command(name: ["remove", "package"])
        let helpCommand = Command(name: ["help"])
        let program = Program(commands: [initCommand, initPackageCommand, removePackageCommand, helpCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initPackageCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindTwoDimentionalCommandFromCommandsWithOperand() {
        let initCommand = Command(name: ["init"])
        let initPackageCommand = Command(name: ["init", "package"])
        let removePackageCommand = Command(name: ["remove", "package"])
        let helpCommand = Command(name: ["help"])
        let program = Program(commands: [initCommand, initPackageCommand, removePackageCommand, helpCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package", "name"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initPackageCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindTwoDimentionalCommandFromCommandsAndRootCommand() {
        let rootCommand = Command()
        let initCommand = Command(name: ["init"])
        let initPackageCommand = Command(name: ["init", "package"])
        let removePackageCommand = Command(name: ["remove", "package"])
        let helpCommand = Command(name: ["help"])
        let program = Program(commands: [rootCommand, initCommand, initPackageCommand, removePackageCommand, helpCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initPackageCommand))
        } catch {
            XCTFail()
        }
    }

    func testFindTwoDimentionalCommandFromCommandsAndRootCommandWithOperand() {
        let rootCommand = Command()
        let initCommand = Command(name: ["init"])
        let initPackageCommand = Command(name: ["init", "package"])
        let removePackageCommand = Command(name: ["remove", "package"])
        let helpCommand = Command(name: ["help"])
        let program = Program(commands: [rootCommand, initCommand, initPackageCommand, removePackageCommand, helpCommand])

        do {
            let command = try program.findCommand(forArguments: ["init", "package", "name"])
            XCTAssertEqual(ObjectIdentifier(command), ObjectIdentifier(initPackageCommand))
        } catch {
            XCTFail()
        }
    }

    static let allTests = [
        ("testFindRootCommand", testFindRootCommand),
        ("testFindRootCommandWithOperand", testFindRootCommandWithOperand),
        ("testFindRootCommandFromCommands", testFindRootCommandFromCommands),
        ("testFindRootCommandFromCommandsWithOperand", testFindRootCommandFromCommandsWithOperand),
        ("testFailToFindRootCommand", testFailToFindRootCommand),
        ("testFindOneDimentionalCommand", testFindOneDimentionalCommand),
        ("testFindOneDimentionalCommandWithOperand", testFindOneDimentionalCommandWithOperand),
        ("testFindOneDimentionalCommandFromRootCommand", testFindOneDimentionalCommandFromRootCommand),
        ("testFindOneDimentionalCommandFromRootCommandWithOperand", testFindOneDimentionalCommandFromRootCommandWithOperand),
        ("testFindOneDimentionalCommandFromCommands", testFindOneDimentionalCommandFromCommands),
        ("testFindOneDimentionalCommandFromCommandsWithOperand", testFindOneDimentionalCommandFromCommandsWithOperand),
        ("testFindOneDimentionalCommandFromCommandsAndRootCommand", testFindOneDimentionalCommandFromCommandsAndRootCommand),
        ("testFindOneDimentionalCommandFromCommandsAndRootCommandWithOperand", testFindOneDimentionalCommandFromCommandsAndRootCommandWithOperand),
        ("testFailToFindOneDimentionalCommand", testFailToFindOneDimentionalCommand),
        ("testFindTwoDimentionalCommand", testFindTwoDimentionalCommand),
        ("testFindTwoDimentionalCommandWithOperand", testFindTwoDimentionalCommandWithOperand),
        ("testFindTwoDimentionalCommandFromRootCommand", testFindTwoDimentionalCommandFromRootCommand),
        ("testFindTwoDimentionalCommandFromRootCommandWithOperand", testFindTwoDimentionalCommandFromRootCommandWithOperand),
        ("testFindTwoDimentionalCommandFromCommands", testFindTwoDimentionalCommandFromCommands),
        ("testFindTwoDimentionalCommandFromCommandsWithOperand", testFindTwoDimentionalCommandFromCommandsWithOperand),
        ("testFindTwoDimentionalCommandFromCommandsAndRootCommand", testFindTwoDimentionalCommandFromCommandsAndRootCommand),
        ("testFindTwoDimentionalCommandFromCommandsAndRootCommandWithOperand", testFindTwoDimentionalCommandFromCommandsAndRootCommandWithOperand)
    ]
}
