//
//  Program.swift
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

/// Program has information for parsing
/// arguments and execute related handler.
open class Program {

    /// Available commands.
    open let commands: [Command]

    /// Construct program.
    ///
    /// - Parameter commands: Available commands.
    public init(commands: [Command]) {
        self.commands = commands
    }

    /// Parse arguments and run handler.
    ///
    /// - Parameter arguments: Arguments. Usually, arguments user input.
    /// - Throws: CommandParsingError, OperandParsingError or OptionParsingError.
    open func run(withArguments arguments: [String]) throws {
        let command = try findCommand(forArguments: arguments)
        let (operands, optionValues) = try command.process(arguments)
        command.handler(self, command, operands, optionValues)
    }

    /// Find command for arguments.
    ///
    /// - Parameter arguments: Arguments to test against available commands.
    /// - Returns: Matching command.
    /// - Throws: CommandParsingError. Command not found.
    open func findCommand(forArguments arguments: [String]) throws -> Command {
        let sortedCommands = commands.sorted { $0.name.count > $1.name.count }
        if let matchingCommand = sortedCommands.first(where: { arguments.starts(with: $0.name) }) {
            return matchingCommand
        }
        throw CommandParsingError.commandNotFound
    }
}
