import Foundation
import PathKit
import Rainbow

// public 的 struct, 必须提供一个初始化方法
// 因为 struct 的 成员变量不一定是 public 的
// internal 的 struct, 就可以不用提供初始化方法


enum FileType {
    case swift
    case objc
    case xib
    
    init?(ext: String) {
        switch ext.lowercased() {
        case "swift": self = .swift
        case "m", "mm": self = .objc
        case "xib", "storyboard": self = .xib
        default: return nil
        }
    }
    /// 根据不同的文件类型, 返回不同的searcher
    ///
    /// - Parameter extensions: 需要查询的扩展名 "png", "jpg"...
    /// - Returns: 对应的searcher
    func searcher(extensions: [String]) -> StringSearcher {
        switch self {
        case .swift: return SwiftSearcher(extensions: extensions)
        case .objc: return OBJCSearcher(extensions: extensions)
        case .xib: return XIBSearcher(extensions: extensions)
        }
    }
}

public enum GYReduceError: Error {
    /// 没有输入资源扩展
    case noResourceExtension
    /// 没有输入文件扩展
    case noFileExtension
}


public struct FileInfo {
    
    public let path: Path
    public let size: Int
    
    init(path: String) {
        self.path = Path(path)
        self.size = self.path.size
    }
}

public struct ResoucreReduce {

    let projectPath: Path
    let excludedPaths: [Path]
    let resourceExtensions: [String]
    let fileExtensions: [String]
    
    public init(projectPath: String, excludedPaths: [String], resourceExtensions: [String], fileExtensions: [String]) {
        // absolute 转换为绝对路径
        let path = Path(projectPath).absolute()
        // 路径
        self.projectPath = path
        // 不想搜查的路径
        self.excludedPaths = excludedPaths.map{ path + Path($0) }
        // 资源扩展名
        self.resourceExtensions = resourceExtensions
        // 文件扩展名
        self.fileExtensions = fileExtensions
    }
    
    /// 未使用的资源
    /// 抛出错误的写法
    public func unusedResources() throws -> [FileInfo] {
        guard !resourceExtensions.isEmpty else {
            throw GYReduceError.noResourceExtension
        }
        guard !fileExtensions.isEmpty else {
            throw GYReduceError.noFileExtension
        }
        let resource = allResources()
        let allStrings = allUsedStringNames()
        
        //找到所有未使用的图片的路径 -> 再转化 FileInfo
        return ResoucreReduce.filterUnused(from: resource, used: allStrings).map(FileInfo.init)
    }

    /// 所有使用了的图片名称 返回集合<可以去掉重复名称>
    func allUsedStringNames() -> Set<String> {
        return usedStringNames(at: projectPath)
    }
    
    
    /// 查找路径下所有使用过的图片名称
    ///
    /// - Parameter path: 路径
    /// - Returns: 图片名称集合
    func usedStringNames(at path: Path) -> Set<String> {
        guard let subPaths = try? path.children() else {
            print("Path reading error. \(path)".red)
            return []
        }
        var result = [String]()
        for subPath in subPaths {
            // 点开头的文件名字, 说明是隐藏文件,跳过
            if subPath.lastComponent.hasPrefix("."){ continue }
            // 不想搜查的路径, 跳过
            if excludedPaths.contains(subPath) { continue }
            // 如果是文件夹, 用递归的方式重复调用该方法
            if subPath.isDirectory {
                result.append(contentsOf: usedStringNames(at: subPath))
            } else {
                //文件
                let fileExt = subPath.extension ?? ""
                // 如果文件的扩展名不在我们搜索的范围, 跳过
                guard fileExtensions.contains(fileExt) else { continue }
                let searcher: StringSearcher
                if let fileType = FileType(ext: fileExt) {
                    searcher = fileType.searcher(extensions: resourceExtensions)
                }else{
                    searcher = GeneralSearcher(extensions: resourceExtensions)
                }
                // 读取文件的内容
                let content =  (try? subPath.read()) ?? ""
                result.append(contentsOf: searcher.search(in: content))
            }
            
        }
        return Set(result)
    }
    
    
    /// 搜索的文件夹下所有使用的资源
    func allResources() -> [String: String] {
        guard let process = FindProcess(path: projectPath, extensions: resourceExtensions, excluded: excludedPaths) else { return [:] }
        
        let found = process.execute()
        var result = [String: String]()
        // 默认忽略的资源扩展名, 因为这里面会有重复的
        let regularDirExtensions = ["imageset", "launchimage", "appiconset", "bundle"]
        let nonDirExtensions = resourceExtensions.filter { !regularDirExtensions.contains($0) }
        
        // 遍历搜索到的资源路径
        fileLoop: for file in found {
            let dirPath = regularDirExtensions.map{".\($0)/"}
            // 如果搜到的资源文件后缀为: xxx.imageset/xxx.
            // 两层循环, 跳到最外层的循环 用标签
            for dir in dirPath where file.contains(dir) { continue fileLoop }
            
            // 如果文件夹目录是 /image.png/icon@2x.png
            // image.png 名字不符合规则的目录, 跳过
            let filePath = Path(file)
            if let ext = filePath.extension, filePath.isDeletable && nonDirExtensions.contains(ext) {
                continue
            }
            
            let key = file.plainName(extensions: resourceExtensions)
            if let existing = result[key] {
                // 找到重复名称的图片, 警告用户, 架构不合理
                print("Found a duplicated file key: \(key), Existing: \(existing)".yellow.bold)
                continue
            }
            result[key] = file
        }
        return result
    }
    
    /// 从所有资源文件中过滤出所有未使用过的字符串
    static func filterUnused(from all: [String: String], used: Set<String>) -> Set<String> {
        let unusedPairs = all.filter { key, _  in
            return !used.contains(key) &&
                   !used.contains { $0.similarPatternWithNumberIndex(other: key) }
        }
        return Set( unusedPairs.map{ $0.value } )
    }
    
    
    /// 删除
    static public func delete(_ unusedFiles: [FileInfo]) -> [(FileInfo, Error)] {
        var failed = [(FileInfo, Error)]()
        for file in unusedFiles {
            do{
                try file.path.delete()
            }catch {
                failed.append((file, error))
            }
        }
        return failed
    }
    
}





