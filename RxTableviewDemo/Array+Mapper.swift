//
//  Array+Mapper.swift
//  RxTableviewDemo
//
//  Created by 郭锐 on 2017/1/19.
//  Copyright © 2017年 郭锐. All rights reserved.
//

import Foundation
import ObjectMapper

extension Array {
    func mapObjs<T:Mappable>(type:T.Type) -> [T]? {
        var objects = [T]()
        for object in self {
            if let obj = Mapper<T>().map(JSON: object as! [String : Any]) {
                objects.append(obj)
            }
        }
        return objects.count > 0 ? objects : nil
    }
}
