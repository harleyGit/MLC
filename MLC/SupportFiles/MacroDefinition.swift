//
//  MacroDefinition.swift
//  HGSWB
//
//  Created by 黄刚 on 2019/8/22.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

import Foundation

//MARK: 三方SDK
@_exported import RxSwift
@_exported import RxCocoa
@_exported import Moya
@_exported import Alamofire
@_exported import SwiftyJSON
@_exported import ObjectMapper

import SnapKit






//MARK: -- 自定义打印
func HGLog<T>(message: T, file: String = #file, _ line: Int = #line){
    #if DEBUG
    
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName): [\(lien)] - \(message)")
    
    #endif
}
