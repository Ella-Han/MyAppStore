//
//  DisplayUtility.swift
//  MyAppStore
//
//  Created by 한아름 on 2021/03/21.
//

import Foundation

final class DisplayUtility {
    static func number(num: Int) -> String {
        let length = String(num).count
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        if length >= 9 {
            return formatter.string(from: NSNumber(value: Float(num)/100000000.0))! + "억"
        } else if length >= 5 {
            return formatter.string(from: NSNumber(value: Float(num)/10000.0))! + "만"
        } else if length > 3 {
            return formatter.string(from: NSNumber(value: Float(num)/1000.0))! + "천"
        } else {
            return String(num)
        }
    }
    
    static func commaNumber(num: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: num)) ?? ""
    }
    
    static func fileSize(byteString: String) -> String {
        guard let byteCount = Int64(byteString) else { return "" }
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: byteCount)
    }
}
