// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "GYReduceTool",
    dependencies: [
        // 用于获取用户输入的参数
        .Package(url: "https://github.com/jatoben/CommandLine","3.0.0-pre1"),
        // 用户参数高亮显示  majorVersion: 2 表示 所有的2点几的版本都是可以接受的
        .Package(url: "https://github.com/onevcat/Rainbow", majorVersion: 2)
    ]
)
