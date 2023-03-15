//
//  LogSet.swift
//  moneysave
//
//  Created by Bluewave on 2023/03/15.
//

import Foundation
/**
 print() 함수가 DEBUG 플래그일 때만 로그 출력하도록 처리
 - Parameters:
   - object: 출력할 내용
   - filename: 파일명
   - line: 줄 번호
 */
func print( _ object: Any, filename: String = #file, line: Int = #line) {
    // Only allowing in DEBUG mode
//    #if DEBUG
//        Swift.print("\(Date().toDateKoreaTime().toString("yyyy-MM-dd hh:mm:ss.SSS")) [\(getFileName(filePath: filename)):\(line)] \(object)")
//    #endif
    Swift.print("\(Date().toDateKoreaTime().toString("yyyy-MM-dd hh:mm:ss.SSS")) [\(getFileName(filePath: filename)):\(line)] \(object)")
}

/**
 파일 경로에서 파일명만 추출
 - Parameter filePath: 파일 경로
 - Returns: 파일명과 확장자
 */
func getFileName(filePath: String) -> String {
    let components = filePath.components(separatedBy: "/")
    return components.isEmpty ? "" : components.last!
}
