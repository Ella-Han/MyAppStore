//
//  Logger.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/20.
//

import Foundation

enum LogLevel: String {
    case i = "ℹ️"
    case w = "⚠️"
    case e = "❗️"
    
    static func convert(string: String) -> LogLevel {
        if string == "e" { return LogLevel.e }
        else if string == "w" { return LogLevel.w }
        else { return LogLevel.i }
    }
}

final class Log: TextOutputStream {
    let ldf = DateFormatter()
    
    public init() {
        ldf.dateFormat = "y-MM-dd H:m:ss.SSSS"
    }
    
    func write(_ string: String) {
        NSLog(string)
    }
}

final class Logger {
    static var log: Log = Log()
    
    static func log(_ logLevel: String, message: String, line: Int = #line, funcName: String = #function) {
        print("\(log.ldf.string(from: Date())) \(LogLevel.convert(string: logLevel).rawValue) [\(funcName):\(line):\(message))]", to: &log)
    }
}

public func LogI(_ message: String, _ arguments: CVarArg..., fileName: String = #file, line: Int = #line, colum: Int = #column, funcName: String = #function) {
    print("\(Logger.log.ldf.string(from: Date())) \(LogLevel.i.rawValue) [\(funcName):\(line):\(message))]", to: &Logger.log)
}

public func LogW(_ message: String, _ arguments: CVarArg..., fileName: String = #file, line: Int = #line, colum: Int = #column, funcName: String = #function) {
    print("\(Logger.log.ldf.string(from: Date())) \(LogLevel.w.rawValue) [\(funcName):\(line):\(message))]", to: &Logger.log)
}

public func LogE(_ message: String, _ arguments: CVarArg..., fileName: String = #file, line: Int = #line, colum: Int = #column, funcName: String = #function) {
    print("\(Logger.log.ldf.string(from: Date())) \(LogLevel.e.rawValue) [\(funcName):\(line):\(message))]", to: &Logger.log)
}
