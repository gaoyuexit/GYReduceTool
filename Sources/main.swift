import Foundation
import CommandLineKit
import Rainbow


let cli = CommandLineKit.CommandLine()

/// shortFlag: "p":  表示 -p     longFlag: "project":  表示 --project   required: false  是否为必须的参数
let projectOption = StringOption(shortFlag: "p",
                                 longFlag: "project",
                                 helpMessage: "Path to the project.")

// MultiStringOption 字符串数组
let resourceExtensionsOption = MultiStringOption(shortFlag: "r",
                                          longFlag: "resource-extensions",
                                          helpMessage: "Extensions to search.")

let fileExtensionsOption = MultiStringOption(shortFlag: "f",
                                                 longFlag: "file-extensions",
                                                 helpMessage: "File Extensions to search.")


let help = BoolOption(shortFlag: "h", longFlag: "help",
                      helpMessage: "Prints a help message.")


cli.addOptions(projectOption, resourceExtensionsOption, fileExtensionsOption, help)


// Rainbow:  用户参数高亮显示
cli.formatOutput = { s, type in
    var str: String
    switch(type) {
    case .error:
        str = s.red.bold
    case .optionFlag:
        str = s.green.underline
    case .optionHelp:
        str = s.blue
    default:
        str = s
    }
    return cli.defaultFormat(s: str, type: type)
}


do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

// 如果有用户输入了help, 打印所有的参数
if help.value {
    cli.printUsage()
    exit(EX_OK)
}












