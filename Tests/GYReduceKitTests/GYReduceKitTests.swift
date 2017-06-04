import XCTest

@testable import GYReduceKit
/// @testable: 因为GYReduceKit和GYReduceKitTests是两个模块, 所以GYReduceKitTests只能使用GYReduceKit中的public方法, 不能是用默认的`internal`方法, 使用了这个命令以后就可以使用`internal`方法了

/**
    XCTest 测试规则:
    在Tests的bundle中会寻找所有以Tests结尾的XCTestCase的子类
    然后去逐个运行里面以小写test开头的方法
 */

class GYReduceKitTests: XCTestCase {
    
    // 一般的测试
    func testStringPlainNameExtension() {
        let s1 = "image@2x.png"
        let s2 = "user/local/bin/find"
        XCTAssertEqual(s1.plainName(extensions: ["png"]), "image")
        XCTAssertEqual(s2.plainName(extensions: ["png"]), "find")
    }
    
    // PDD测试的入口, 需要XCTest来启动
    func testGYReductKitSpecs() {
        specGYReduceKit()
    }
}




