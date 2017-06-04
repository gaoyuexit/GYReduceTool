//
//  Extensions.swift
//  GYReduceTool
//
//  Created by 郜宇 on 2017/5/25.
//
//

import Foundation
import PathKit

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
}

