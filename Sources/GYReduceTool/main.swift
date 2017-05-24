import Foundation
import CommandLineKit
import Rainbow
import GYReduceKit

/// 该命令行工具为了找出特定目录下的特定扩展名文件中的未使用的图片

let cli = CommandLineKit.CommandLine()

/// shortFlag: "p":  表示 -p     longFlag: "project":  表示 --project   required: false  是否为必须的参数
// 目标路径
let projectOption = StringOption(shortFlag: "p",
                                 longFlag: "project",
                                 helpMessage: "Path to the project.")

// MultiStringOption 字符串数组
// 资源扩展名
let resourceExtensionsOption = MultiStringOption(shortFlag: "r",
                                          longFlag: "resource-extensions",
                                          helpMessage: "Extensions to search.")

// 文件扩展名
let fileExtensionsOption = MultiStringOption(shortFlag: "f",
                                                 longFlag: "file-extensions",
                                                 helpMessage: "File Extensions to search.")

// 不想搜查的目录: 例如pods等
let excludePathsOption = MultiStringOption(shortFlag: "e",
                                     longFlag: "exclude",
                                     helpMessage: "Exclude paths which should not search in.")
// 帮助
let help = BoolOption(shortFlag: "h", longFlag: "help",
                      helpMessage: "Prints a help message.")


cli.addOptions(projectOption, resourceExtensionsOption, fileExtensionsOption, excludePathsOption, help)


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

// 如果有用户输入了help, 打印所有设定的参数
if help.value {
    cli.printUsage()
    exit(EX_OK)
}

// 取出用户输入的参数
// 路径
let project = projectOption.value ?? "."
// 扩展名
let resourceExtensions = resourceExtensionsOption.value ?? ["png", "jpg", "imageset"]
// 文件扩展名
let fileExtensions = fileExtensionsOption.value ?? ["swift", "m", "mm", "xib", "storyboard"]
// 不想搜查的路径
let excludePaths = excludePathsOption.value ?? []




























