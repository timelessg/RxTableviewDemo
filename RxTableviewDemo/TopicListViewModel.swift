//
//  TopicListViewModel.swift
//  RxTableviewDemo
//
//  Created by 郭锐 on 2017/1/19.
//  Copyright © 2017年 郭锐. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

public enum RefreshStatus: Int {
    case PushSuccess
    case PushFailure
    case PullSuccess
    case PullFailure
    case NoMoreData
    case Unknown
}

class TopicListViewModel: NSObject {
    fileprivate var loadData = PublishSubject<Int>()
    fileprivate var page:Int = 1
    fileprivate var dataSource = [SectionModel<String, TopicModel>]()
    public var result:Observable<[SectionModel<String, TopicModel>]>?
    public var refresh:Variable<RefreshStatus> = Variable(.Unknown)
    
    override init() {
        super.init()
        
        result = loadData.flatMapLatest({ [weak self] (p) -> Observable<[SectionModel<String, TopicModel>]> in
            return NetClient.send(TopicApi.topic(page: p)).map({ (x) -> [SectionModel<String, TopicModel>] in
                if let topicsArray = x["data"] as? [[String:Any]], let topics = topicsArray.mapObjs(type: TopicModel.self) {
                    if p == 1 {
                        self?.dataSource = [SectionModel(model: "", items: topics)]
                        self?.refresh.value = .PullSuccess
                        return (self?.dataSource)!
                    }else{
                        self?.dataSource += [SectionModel(model: "", items: topics)]
                        self?.refresh.value = .PushSuccess
                        return (self?.dataSource)!
                    }
                }else{
                    if p != 1 {
                        self?.page -= 1
                        self?.refresh.value = .PushFailure
                    }else {
                        self?.refresh.value = .PullFailure
                    }
                }
                return [SectionModel(model: "", items: [])]
            }).catchErrorJustReturn([SectionModel(model: "", items: [])])
        })
    }
    
    func reloadData() {
        page = 1
        loadData.onNext(page)
    }
    
    func loadMoreData() {
        page += 1
        loadData.onNext(page)
    }
}
