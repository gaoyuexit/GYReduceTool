//
//  Extensions.swift
//  GYReduceTool
//
//  Created by 郜宇 on 2017/5/25.
//
//

import Foundation
import PathKit


// 数字正则
let digitalRegex = try! NSRegularExpression(pattern: "(\\d+)", options: .caseInsensitive)

extension String {
    
    var fullRange: NSRange {
        /// utf16.count: string的这个utf16.count = NSString的lenth
        return NSMakeRange(0, utf16.count)
    }

    
    /// 资源路径拿出最后的组成部分,并去掉扩展名, 去掉 @2x, @3x
    ///
    /// - Parameter extensions: 希望去掉的文件的扩展名
    /// - Returns: 最终去掉扩展名, @2x, @3x的名字
    func plainName(extensions: [String]) -> String {
        let p = Path(self.lowercased())
        var result: String
        if let ext = p.extension, extensions.contains(ext) {
            result = p.lastComponentWithoutExtension
        }else{
            result = p.lastComponent
        }
        // 检查是否有@2x, @3x
        if result.hasSuffix("@2x") || result.hasSuffix("@3x") {
            result = String(describing: result.utf16.dropLast(3))
        }
        return result
    }
    
    /// 资源路径拿出最后的组成,并去掉扩展名, 去掉 @2x, @3x
    /**
    var plainName: String {
        // 全转换成小写
        let p = Path(self.lowercased())
        /// 去掉扩展名
        var result = p.lastComponentWithoutExtension
        if result.hasSuffix("@2x") || result.hasSuffix("@3x") {
            ///
            result = String(describing: result.utf16.dropLast(3))
        }
        return result
    }
    */
    
    
    /// 判断 帧动画图片
    // 相似的模式
    // other:  image01, image02...
    // 找数字, 取最后一个结果
    // 是否相似 other: 图片名称
    // 即: 如果other中有数字, 则取数字前的前缀, 和数字后的后缀 分别和原来的string作比较
    func similarPatternWithNumberIndex(other: String) -> Bool {
        
        let matches = digitalRegex.matches(in: other, options: [], range: other.fullRange)
        guard matches.count >= 1 else { return false }
        
        let lastMatch = matches.last!
        let digitalRange = lastMatch.rangeAt(1)
        
        var prefix: String? //前缀
        var suffix: String? //后缀
        
        let digitalLocation = digitalRange.location
        if digitalLocation != 0 {
            let index = other.index(other.startIndex, offsetBy: digitalLocation)
            prefix = other.substring(to: index)
        }
        // NSMaxRange = location + lenth
        let digitalMaxRange = NSMaxRange(digitalRange)
        if digitalMaxRange < other.utf16.count {
            let index = other.index(other.startIndex, offsetBy: digitalMaxRange)
            suffix = other.substring(from: index)
        }
        switch (prefix, suffix) {
        case (nil, nil): return false //图片名字只有数字
            // case let 的意思, 如果 prefix有值, 则把结果放到p中
        // 如果prefix, suffix都有值, 就会进入这个判断, 他们的值在 p, s中
        case (let p?, let s?): return hasPrefix(p) && hasSuffix(s)
        case (let p?, nil): return hasPrefix(p)
        case (nil, let s?): return hasSuffix(s)
        }
        
    }
}

extension Path {
    // 路径中文件/文件夹的大小
    var size: Int {
        if isDirectory {
            let childrenPaths = try? children()
            return (childrenPaths ?? []).reduce(0){ $0 + $1.size }
        }else{
            // 隐藏文件
            if lastComponent.hasPrefix(".") { return 0 }
            let attr = try? FileManager.default.attributesOfItem(atPath: absolute().string)
            if let num = attr?[.size] as? NSNumber {
                return num.intValue
            }else {
                return 0
            }
        }
    }
}





