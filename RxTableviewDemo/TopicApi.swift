//
//  TopicApi.swift
//  RxTableviewDemo
//
//  Created by 郭锐 on 2017/1/19.
//  Copyright © 2017年 郭锐. All rights reserved.
//

import UIKit

enum TopicApi:Request {
    case topic(page:Int)
}
extension TopicApi {
    var path: String {
        switch self {
        case .topic(_):
            return "/news/get-news"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .topic(let page):
            return ["tableNum":page,"pagesize":10,"callback":"?","justList":"1"]
        }
    }
}
