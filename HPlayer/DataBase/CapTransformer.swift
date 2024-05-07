//
//  CapTransformer.swift
//  HPlayer
//
//  Created by HF on 2024/3/3.
//

import Foundation
class CapTransformer: NSSecureUnarchiveFromDataTransformer {
   
   // 定义静态属性name，方便使用
   static let name = NSValueTransformerName(rawValue: String(describing: CapTransformer.self))
   
   // 重写allowedTopLevelClasses，确保Model在允许的类列表中
   override static var allowedTopLevelClasses: [AnyClass] {
       return [NSArray.self, AVCaption.self] // NSArray.self 也要加上，不然不能在数组中使用！
   }
   
   // 定义Transformer转换器注册方法
   public static func defaultConfig() {
       let transformer = CapTransformer()
       ValueTransformer.setValueTransformer(transformer, forName: name)
   }
}
