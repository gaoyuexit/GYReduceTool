//
//  FileProcess.swift
//  GYReduceTool
//
//  Created by 郜宇 on 2017/6/4.
//
//  用于执行系统命令

import Foundation
import PathKit
// NSTask在swift3中被重名为Process,用来执行系统命令


// 命令行`find`: 
// . 表示当前所在的路径, 这里也可以放其他具体的路径
// find . -name "*.png"
// find . -name "*.png" -or -name "*.swift"
// find . -name "*.png" -or -name "*.swift" -not -path "./result"  -> 忽略的路径
struct FindProcess {
    
    let p: Process
    /// path 路径
    /// extensions: 资源扩展名
    /// excluded: 不想搜查的路径
    init?(path: Path, extensions: [String], excluded: [Path]) {
        p = Process()
        p.launchPath = "/usr/bin/find"
        guard !extensions.isEmpty else { return nil }
        
        var args = [String]()
        args.append(path.string)
        
        for(i, ext) in extensions.enumerated() {
            if i == 0 {
                args.append("(")
            }else {
                args.append("-or")
            }
            args.append("-name")
            args.append("*.\(ext)")
            if i == extensions.count - 1 {
                args.append(")")
            }
        }
        for excludedPath in excluded {
            args.append("-not")
            args.append("-path")
            let filePath = path + excludedPath
            
            guard filePath.exists else { continue }
            
            if filePath.isDirectory {
                args.append("\(filePath.string)/*")
            } else {
                args.append(filePath.string)
            }
        }
        p.arguments = args
        print("p.args:\(args)")
    }
    
    init?(path: String, extensions: [String], excluded: [String]) {
        self.init(path: Path(path), extensions: extensions, excluded: excluded.map { Path($0) })
    }
    
    /// 执行, 返回路径的集合
    func execute() -> Set<String> {
        
        let pipe = Pipe()
        p.standardOutput = pipe
        
        // 读取pip的内容: 就是命令行执行完的输出
        let fileHandler = pipe.fileHandleForReading
        p.launch()
        
        let data = fileHandler.readDataToEndOfFile()
        
        if let string = String(data: data, encoding: .utf8) {
            // 根据 回车换行, 最后一个没有回车符
            return Set(string.components(separatedBy: "\n").dropLast())
        } else {
            return []
        }
    }
}


