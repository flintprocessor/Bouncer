<div align="center"><img src="/Assets/logo.svg" width="300" /></div>
<h1 align="center">
  <b>Bouncer</b>
  <br>
  <a href="https://travis-ci.org/flintbox/Bouncer"><img src="https://travis-ci.org/flintbox/Bouncer.svg?branch=master" alt="Build Status" /></a>
  <a href="https://github.com/flintbox/Bouncer/releases"><img src="https://img.shields.io/github/release/flintbox/Bouncer.svg" alt="GitHub release" /></a>
  <a href="https://swift.org/package-manager"><img src="https://img.shields.io/badge/Swift%20PM-compatible-orange.svg" alt="Swift Package Manager" /></a>
  <a href="https://github.com/flintbox/Bouncer/blob/master/LICENSE"><img src="https://img.shields.io/github/license/mashape/apistatus.svg" alt="license" /></a>
</h1>

*Command line argument parser. Bouncer does **all the heavy lifting** for you. Dive into **business logic** in no time.*

**Table of Contents**
- [Synopsis](#synopsis)
- [Installation](#installation)
- [Component](#component)
  - [Option](#option)
  - [Operand](#operand)
  - [Command](#command)
  - [Program](#program)
- [Example](#example)
- [Contribute](#contribute)

## Synopsis

Parse

```shell
git-mock init . -q --bare --separate-git-dir=../git_dir --shared --template ../template/git-template
```

and grab values.

```swift
let directory         = operands[optional: 0]
let quiet             = optionValues.have(quietOption)
let bare              = optionValues.have(bareOption)
let templateDirectory = optionValues.findOptionalArgument(for: templateOption)
let gitDirectory      = optionValues.findOptionalArgument(for: separateGitDirOption)
let shared            = optionValues.findOptionalArgument(for: sharedOption)
```

## Installation

Add Bouncer to `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/flintbox/Bouncer.git", from: "1.0.0")
]
```

Now import!

```swift
import Bouncer

let program = Program(commands: [])
```

## Component

### [Option](https://github.com/flintbox/Bouncer/blob/master/Sources/Bouncer/Option/Option.swift)

Configuration for option like `--path`, `-h`, `--path ./temp` or `-p./temp`. Check regular expressions for matching option in [`OptionNameRegex.swift`](https://github.com/flintbox/Bouncer/blob/master/Sources/Bouncer/Option/OptionNameRegex.swift).

Property | Type | Description
-------- | ---- | -----------
`name` | `String` | Name of option (`[[:alnum:]\-]+`).
`shortName` | `Character?` | Short name of option.
`optional` | `Bool` | If option is optional or not for the command. Used for validation.
`argumentType` | [`OptionArgumentType`](https://github.com/flintbox/Bouncer/blob/master/Sources/Bouncer/Option/OptionArgumentType.swift) | Option argument type. None, optional, optional with default value or required.

### Operand

Basically, all of arguments following command are operands. Of course, except options and option arguments.

### [Command](https://github.com/flintbox/Bouncer/blob/master/Sources/Bouncer/Command/Command.swift)

Configuration for command.

Property | Type | Description
-------- | ---- | -----------
`name` | `[String]` | Name of the command. Sub command can be easily expressed like `["container", "start"]`.
`operandType` | [`OperandType`](https://github.com/flintbox/Bouncer/blob/master/Sources/Bouncer/Command/OperandType.swift) | Operand type. Define command accepts how many operands.
`options` | `[Option]` | Available options.
`handler` | `CommandHandler` | This block will be called with validated operands and option values. There are extensions for getting specific values from [operand value array](https://github.com/flintbox/Bouncer/blob/master/Sources/Bouncer/OperandValue/OperandValue+Array.swift) and [option value array](https://github.com/flintbox/Bouncer/blob/master/Sources/Bouncer/OptionValue/OptionValue+Array.swift).

### [Program](https://github.com/flintbox/Bouncer/blob/master/Sources/Bouncer/Program/Program.swift)

Program is initialized with commands. Use program object to parse and run command.

## Example

### [Init.swift](https://github.com/flintbox/Bouncer/blob/master/Sources/git-mock/init/Init.swift)

```swift
import Bouncer

let quietOption =          Option(name: "quiet", shortName: "q", optional: true, argumentType: .none)
let bareOption =           Option(name: "bare", optional: true, argumentType: .none)
let templateOption =       Option(name: "template", optional: true, argumentType: .required)
let separateGitDirOption = Option(name: "separate-git-dir", optional: true, argumentType: .required)
let sharedOption =         Option(name: "shared", optional: true, argumentType: .optional("group"))

let initCommand = Command(
    name: ["init"],
    operandType: .optionalEqual(1),
    options: [quietOption, bareOption, templateOption, separateGitDirOption, sharedOption]
) { program, command, operands, optionValues in
    let directory = operands[optional: 0]
    let quiet = optionValues.have(quietOption)
    let bare = optionValues.have(bareOption)
    let templateDirectory = optionValues.findOptionalArgument(for: templateOption)
    let gitDirectory = optionValues.findOptionalArgument(for: separateGitDirOption)
    let shared = optionValues.findOptionalArgument(for: sharedOption)
    print(
        """

            init command <https://git-scm.com/docs/git-init>

            directory    : \(directory ?? "nil")
            quiet        : \(quiet)
            bare         : \(bare)
            template dir : \(templateDirectory ?? "nil")
            git dir      : \(gitDirectory ?? "nil")
            shared       : \(shared ?? "nil")

        """
    )
}
```

### [main.swift](https://github.com/flintbox/Bouncer/blob/master/Sources/git-mock/main.swift)

```swift
import Bouncer

let program = Program(commands: [initCommand])

let arguments = Array(CommandLine.arguments.dropFirst())
try? program.run(withArguments: arguments)
```

### Case 1

#### Input

```shell
git-mock init .
```

#### Output

```shell
init command <https://git-scm.com/docs/git-init>

directory    : .
quiet        : false
bare         : false
template dir : nil
git dir      : nil
shared       : nil
```

### Case 2

#### Input

```shell
git-mock init repository/dir --shared --template=../template --separate-git-dir ../.git --bare
```

#### Output

```shell
init command <https://git-scm.com/docs/git-init>

directory    : repository/dir
quiet        : false
bare         : true
template dir : ../template
git dir      : ../.git
shared       : group
```

## Contribute

If you have good idea or suggestion? Please, don't hesitate to open a pull request or send me an [email](mailto:contact@jasonnam.com).

Hope you enjoy building command line tool with Bouncer!
