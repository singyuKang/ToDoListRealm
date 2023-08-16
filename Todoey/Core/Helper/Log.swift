//
//  Log.swift
//  Todoey
//
//  Created by 강신규 on 2023/08/10.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

class Log {
    static func print(_ file: String = #file, _ function: String = #function, _ line: Int = #line, message: Any? = "") {
        
        var fileName = (file as NSString).lastPathComponent
        fileName = fileName.components(separatedBy: ".").first ?? ""
        
        var printLog = "\(fileName) - \(function) [\(line)]"
        
        if let msg = message {
            printLog += " : \(msg)"
        }
        
        NSLog("\(printLog)")
    }
}
