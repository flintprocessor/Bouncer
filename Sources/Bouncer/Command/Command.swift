//
//  Command.swift
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

/// Command handler. Arguments are `Program`, `Command`,
/// `[String]`, `[OptionValue]` respectively.
public typealias CommandHandler = (Program, Command, [String], [OptionValue]) -> Void

/// Command represents command argument.
open class Command {

    /// Command name. Sub command can be expressed
    /// as array with two or more strings.
    open let name: [String]
    /// Operand accepting type.
    open let operandType: OperandType
    /// Accepting options.
    open let options: [Option]
    /// Command handler. Block to be executed with valid arguments.
    open let handler: CommandHandler

    /// Construct command.
    ///
    /// - Parameters:
    ///   - name: Command name. Sub command can be expressed
    ///           as array with two or more strings.
    ///   - operandType: Operand accepting type.
    ///   - options: Accepting options.
    ///   - handler: Command handler. Block to be executed with valid arguments.
    public init(name: [String] = [], operandType: OperandType = .none,
                options: [Option] = [], handler: @escaping CommandHandler) {
        self.name = name
        self.operandType = operandType
        self.options = options
        self.handler = handler
    }

    /// Parse and validate arguments for operand and option value.
    ///
    /// - Parameter arguments: Arguments to be parsed.
    /// - Returns: Parsed and validated operand and option value with configuration set.
    /// - Throws: OperandParsingError or OptionParsingError. Validation error.
    open func process(_ arguments: [String]) throws -> ([String], [OptionValue]) {
        let (operands, optionValues) = try parse(arguments)

        if let error = validateOperandsAndReturnErrorIfNeeded(operands) {
            throw error
        }
        if let error = validateContainingRequiredOptionValuesAndReturnErrorIfNeeded(optionValues) {
            throw error
        }

        return (operands, optionValues)
    }

    /// Parse arguments for operand and option value.
    ///
    /// - Parameter arguments: Arguments to be parsed.
    /// - Returns: Parsed operand and option value with configuration set.
    /// - Throws: OptionParsingError with invalid option argument or format.
    open func parse(_ arguments: [String]) throws -> ([String], [OptionValue]) {
        var operands: [String] = []
        var optionValues: [OptionValue] = []

        var optionToCheck: Option?
        for argument in arguments {
            if let currentOption = optionToCheck {
                if argument.isOptionName {
                    switch currentOption.argumentType {
                    case .required:
                        throw OptionParsingError.missingOptionArgument(self, currentOption)
                    case .optional(let defaultValue):
                        optionValues.append(OptionValue(name: currentOption.name, value: defaultValue))
                        optionToCheck = findOption(forArgument: argument)
                    case .none:
                        optionValues.append(OptionValue(name: currentOption.name))
                        optionToCheck = findOption(forArgument: argument)
                    }
                } else {
                    switch currentOption.argumentType {
                    case .required, .optional(_):
                        optionValues.append(OptionValue(name: currentOption.name, value: argument))
                    case .none:
                        optionValues.append(OptionValue(name: currentOption.name))
                        operands.append(argument)
                    }
                    optionToCheck = nil
                }
            } else {
                if argument.isOptionName {
                    optionToCheck = findOption(forArgument: argument)
                } else {
                    operands.append(argument)
                }
            }
        }

        if let optionToCheck = optionToCheck {
            switch optionToCheck.argumentType {
            case .none:
                optionValues.append(OptionValue(name: optionToCheck.name))
            case .optional(let defaultValue):
                optionValues.append(OptionValue(name: optionToCheck.name, value: defaultValue))
            case .required:
                throw OptionParsingError.missingOptionArgument(self, optionToCheck)
            }
        }

        return (operands, optionValues)
    }

    /// Find option for argument.
    ///
    /// - Parameter argument: Argument to find option if it is opton name.
    /// - Returns: Option if exists, nil if argument is not option name or option does not exist.
    open func findOption(forArgument argument: String) -> Option? {
        return options.first { $0 == argument }
    }

    /// Validate operands and return error if needed.
    ///
    /// - Parameter operands: Operands to validate.
    /// - Returns: OperandParsingError if needed.
    open func validateOperandsAndReturnErrorIfNeeded(_ operands: [String]) -> OperandParsingError? {
        switch operandType {
        case .none:
            if !operands.isEmpty {
                return .invalidNumberOfOperands(self, operandType, operands)
            }
        case .equal(let numberOfOperands):
            if operands.count != numberOfOperands {
                return .invalidNumberOfOperands(self, operandType, operands)
            }
        case .optionalEqual(let numberOfOperands):
            if !(operands.isEmpty || operands.count == numberOfOperands) {
                return .invalidNumberOfOperands(self, operandType, operands)
            }
        case .range(let range):
            if !range.contains(operands.count) {
                return .invalidNumberOfOperands(self, operandType, operands)
            }
        }
        return nil
    }

    /// Validate option values and return error if needed.
    ///
    /// - Parameter optionValues: Option values to validate.
    /// - Returns: OptionParsingError if needed.
    open func validateContainingRequiredOptionValuesAndReturnErrorIfNeeded(_ optionValues: [OptionValue]) -> OptionParsingError? {
        var missingOptions: [Option] = []

        for option in options {
            if !option.optional && !optionValues.contains(where: { $0.name == option.name }) {
                missingOptions.append(option)
            }
        }

        if !missingOptions.isEmpty {
            return OptionParsingError.missingOptions(self, missingOptions)
        }

        return nil
    }
}
