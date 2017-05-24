// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "GYReduceTool",
    targets: [
        // GYReduceKit 这个库没有依赖
        Target(name: "GYReduceKit", dependencies: []),
        // 主程序可执行文件的 依赖是`GYReduceKit`, 我们需要在主程序中用到`GYReduceKit`这个库的方法
        Target(name: "GYReduceTool", dependencies: ["GYReduceKit"])
    ],
    dependencies: [
        // 用于获取用户输入的参数
        .Package(url: "https://github.com/jatoben/CommandLine","3.0.0-pre1"),
        // 用户参数高亮显示  majorVersion: 2 表示 所有的2点几的版本都是可以接受的
        .Package(url: "https://github.com/onevcat/Rainbow", majorVersion: 2),
        // 简单操作路径的这个库 (版本号: 0.8.0)   majorVersion: 主要版本 , 次要版本: minor
        .Package(url: "https://github.com/kylef/PathKit", majorVersion: 0, minor: 8)
    ]
)
