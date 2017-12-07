//
//  main.swift
//  CSVExporter
//
//  Created by Wilson Yuan on 2017/12/6.
//  Copyright © 2017年 Being Inc. All rights reserved.
//

import Foundation

let doubleQuote = "\""

func contentsOfFile(_ filePath: String) -> String {
    do {
        return try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
    }
    catch { return "" }
}

func extractStringIdentifierFromTrimmedLine(_ line: String) -> String {
    let indexAfterFirstQuote = line.index(after: line.startIndex)
    let lineWithoutFirstQuote = line[indexAfterFirstQuote...]
    let endIndex = lineWithoutFirstQuote.index(of:"\"")!
    let identifier: Substring.SubSequence = lineWithoutFirstQuote[..<endIndex]
    return String(identifier)
}

/*
 example:
./CSVExporter /Users/Wilson/Documents/Project/SourceTree/GStart-iOS/Game/Game/Resources/zh-Hans.lproj/Localizable.strings /Users/Wilson/Documents/Project/SourceTree/GStart-iOS/strings.csv
 */

func creatCSV() -> Void {
    let inputStringsFilePath = CommandLine.arguments[1]
    let outPutCSVFilePath = CommandLine.arguments[2]
    var csvText = "en, zh-hans\n"
    let stringsArray = contentsOfFile(inputStringsFilePath)
    let stringsText = stringsArray.components(separatedBy: "\n")
        .map    { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
        .filter { $0.hasPrefix(doubleQuote) } //
        .map {
            $0.components(separatedBy: "=")
                .map { extractStringIdentifierFromTrimmedLine($0.trimmingCharacters(in: .whitespaces)) }
                .joined(separator: ",")
        }.joined(separator: "\n")
    
    print("stringsText: \(stringsText) \n\n")
    
    csvText.append(stringsText)
    do {
        try csvText.write(toFile: outPutCSVFilePath, atomically: true, encoding: .utf8)
        print("output path: \(outPutCSVFilePath)")
    } catch {
        print("Failed to create file: \(error)")
    }
}

creatCSV()

