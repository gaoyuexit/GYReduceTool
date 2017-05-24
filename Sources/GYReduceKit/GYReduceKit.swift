import Foundation
import PathKit

// public 的 struct, 必须提供一个初始化方法
// 因为 struct 的 成员变量不一定是 public 的

// internal 的 struct, 就可以不用提供初始化方法

public struct Foo {
    public init() {
        
    }
    public func bar() {
        print("test")
    }
}

public struct FileInfo {
    
}

public struct ResoucreReduce {

    let projectPath: Path
    let excludedPaths: [Path]
    let resourceExtensions: [String]
    let fileExtensions: [String]
    
    public init(projectPath: String, excludedPaths: [String], resourceExtensions: [String], fileExtensions: [String]) {
        // absolute 转换为绝对路径
        let path = Path(projectPath).absolute()
        self.projectPath = path
        self.excludedPaths = excludedPaths.map{ path + Path($0) }
        self.resourceExtensions = resourceExtensions
        self.fileExtensions = fileExtensions
    }
    
    /// 未使用的资源
    public func unusedResource() -> [FileInfo] {
        fatalError()
    }
    
    /// 使用了的字符串
    func stringInUse() -> [String] {
        fatalError()
    }
    
    /// 搜索的文件夹下使用的资源
    func resourceInUse() -> [String: String] {
        fatalError()
    }
    
    /// 删除
    public func delete() {
        
    }
    
}


