//
//  TopicModel.swift
//  RxTableviewDemo
//
//  Created by 郭锐 on 2017/1/19.
//  Copyright © 2017年 郭锐. All rights reserved.
//

import UIKit
import ObjectMapper

class TopicModel: Mappable{
    var news_id: String?
    var title: String?
    var top_image: String?
    var text_image0: String?
    var text_image1: String?
    var source: String?
    var content: String?
    var digest: String?
    var reply_count: String?
    var edit_time: Int?
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        news_id <- map["news_id"]
        title <- map["title"]
        top_image <- map["top_image"]
        text_image0 <- map["text_image0"]
        text_image1 <- map["text_image1"]
        source <- map["source"]
        content <- map["content"]
        digest <- map["digest"]
        reply_count <- map["reply_count"]
        edit_time <- map["edit_time"]
    }

}
