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
        .Package(url: "https://github.com/kylef/PathKit", majorVersion: 0, minor: 8),
        // PDD测试驱动开发框架: 上面的`PathKit`已经集成了这个框架, 但是为了保证以后`PathKit`会不会删除他, 所以我们自己也依赖这个框架来进行测试, 因为用到test中, 我们应该只添加到 `testDependencies`中, 但是swift3还不支持, 暂且写到这里
        .Package(url: "https://github.com/kylef/Spectre.git", majorVersion: 0, minor: 7)
    ],
    // 在Tests中新建了一个文件夹, swift package manager会尝试为他创建一个module, 我们让packageManager不要管`exclude`
    exclude: ["Tests/Fixtures"]
)
