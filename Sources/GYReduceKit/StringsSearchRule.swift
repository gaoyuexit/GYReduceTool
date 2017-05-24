//
//  StringsSearchRule.swift
//  GYReduceTool
//
//  Created by 郜宇 on 2017/5/25.
//
//

import Foundation

/// 字符串搜索者
protocol StringSearcher {
    func search(in content: String) -> Set<String>
}

/// 正则规则的字符串搜索者
protocol RegexStringSearcher: StringSearcher {
    // 只需要一个规则
    var patterns: [String] { get }
}


extension RegexStringSearcher {
    // RegexStringSearcher默认实现StringSearcher的协议
    // 找出符合条件的图片名称(去掉扩展名, 去掉@2x,@3x)
    func search(in content: String) -> Set<String> {
        
        var result = Set<String>()
        
        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                print("Failed to create regular expression: \(pattern)")
                continue
            }
            let matches = regex.matches(in: content, options: [], range: content.fullRange)
            /// match : [NSTextCheckingResult]
            /// NSTextCheckingResult 第一个参数为位置, 第二个参数为匹配到的结果
            /// rangeAt(1) 为结果的range
            for checkingResult in matches {
                let range = checkingResult.rangeAt(1)
                // 提取的内容
                let extracted = NSString(string: content).substring(with: range)
                result.insert(extracted.plainName)
            }
        }
        return result
    }
}



