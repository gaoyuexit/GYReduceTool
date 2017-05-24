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
    
    
    /// 去掉扩展名, 去掉 @2x, @3x
    var plainName: String {
        let p = Path(self)
        /// 去掉扩展名
        var result = p.lastComponentWithoutExtension
        if result.hasSuffix("@2x") || result.hasSuffix("@3x") {
            ///
            result = String(describing: result.utf16.dropLast(3))
        }
        return result
    }
    
    
    
}

