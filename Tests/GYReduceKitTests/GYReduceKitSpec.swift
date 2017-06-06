import Foundation
// PDD行为测试框架
import Spectre
@testable import GYReduceKit
import PathKit

/// 自己创建的一个测试的入口, 他仍然需要XCTest来启动
public func specGYReduceKit() {

    
    /// 可以使用 #file 获取当前文件的路径(即: GYReduceKitSpec.swift的路径) 类似于 #line 获取行数
    let fixtures = Path(#file).parent().parent() + "Fixtures"
    
    
    describe("GYReductKit") {
    
        // 测试plainName
        $0.describe("Sting Extensions"){
            
            $0.it("should return plain name") {
                let s1 = "image@2x.tmp"
                let s2 = "user/local/bin/find"
                let s3 = "image@3x.png"
                let s4 = "local.host.jpg"
                
                let exts = ["png", "jpg"]
                
                try expect(s1.plainName(extensions: exts)) == "image@2x.tmp"
                try expect(s2.plainName(extensions: exts)) == "find"
                try expect(s3.plainName(extensions: exts)) == "image"
                try expect(s4.plainName(extensions: exts)) == "local.host"
            }
        }
        // 测试 SwiftSearcher
        $0.describe("String Searcher") {
            
            $0.it("Swift Searcher works") {
                let s1 = "UIImage(name: \"my_image\")"
                let s2 = "ef\"asdf\"as\"d\"fec"
                let s3 = "let name = \"button@2x\""
                let s4 = "test string: \"local.png\""
                let s5 = "test string: \"local.host\""
                
                let search = SwiftSearcher(extensions: ["png", "jpg"])
                let result = [s1, s2, s3, s4, s5].map{ search.search(in: $0) }
                
                try expect(result[0]) == Set(["my_image"])
                try expect(result[1]) == Set(["asdf", "d"])
                try expect(result[2]) == Set(["button"])
                try expect(result[3]) == Set(["local"])
                try expect(result[4]) == Set(["local.host"])
            }
        }
        // 测试 GYReduceKit中的方法
        $0.describe("GYReduceKit Function") {
            $0.it("should find used strings in swift") {
                let path = fixtures + "FileStringSearcher"
                let resourceReduce = ResoucreReduce(projectPath: path.string,
                                                    excludedPaths: [],
                                                    resourceExtensions: ["png", "jpg"],
                                                    fileExtensions: ["swift"])
                let result = resourceReduce.allUsedStringNames()
                let expected: Set<String> = ["common.login",
                                             "common.logout",
                                             "live_btn_connect",
                                             "live_btn_connect",
                                             "name-key",
                                             "无法支持"]
                
                try expect(result) == expected
            }
        }
        
        // 测试FindProcess
        $0.describe("FindProcess") {
            
            $0.it("should get proper files") {
                let project = fixtures + "FindProcess"
                let process = FindProcess(path: project.string, extensions: ["swift"], excluded: [])
                let result = process?.execute()
                let expected = Set(["Folder1/ignore_ext.swift"].map { (project + $0).string })
                try expect(result) == expected
            }
            
            $0.it("should get proper files with exclude pattern") {
                let project = fixtures + "FindProcess"
                let process = FindProcess(path: project.string, extensions: ["png", "jpg"], excluded: ["Folder1/Ignore", "Folder2/ignore_file.jpg"])
                let result = process?.execute()
                let expected = Set(["file1.png", "Folder1/file2.png", "Folder1/SubFolder/file3.jpg", "Folder2/file4.jpg"].map { (project + $0).string })
                try expect(result) == expected
            }
        }
        
        
        
        
        
    }
    
    
    
}
