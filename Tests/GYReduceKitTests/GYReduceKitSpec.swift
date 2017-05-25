import Foundation
// PDD行为测试框架
import Spectre
@testable import GYReduceKit

/// 自己创建的一个测试的入口, 他仍然需要XCTest来启动
public func specGYReduceKit() {

    describe("GYReductKit") {
        $0.describe("Sting Extensions"){
            
            $0.it("should return plain name") {
                let s1 = "image@2x.png"
                let s2 = "user/local/bin/find"
                try expect(s1.plainName) == "image"
                try expect(s2.plainName) == "find"
            }
        }
        
        $0.describe("String Searcher") {
            $0.it("Swift Searcher works") {
                let s1 = "UIImage(name: \"my_image\")"
                let s2 = "ef\"asdf\"as\"d\"fec"
                let s3 = "let name = \"button@2x\""
                
                let search = SwiftSearcher()
                let result = [s1, s2, s3].map{ search.search(in: $0) }
                
                try expect(result[0]) == Set(["my_image"])
                try expect(result[1]) == Set(["asdf", "d"])
                try expect(result[2]) == Set(["button"])

            }
        }
    }
    
    
    
}
