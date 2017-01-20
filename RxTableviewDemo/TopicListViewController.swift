//
//  TopicListViewController.swift
//  RxTableviewDemo
//
//  Created by 郭锐 on 2017/1/19.
//  Copyright © 2017年 郭锐. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import RxDataSources
import PullToRefreshSwift

class TopicListViewController: UIViewController, RefreshScrollViewProtocol {
    internal var scrollView: UIScrollView {
        return tableView
    }

    fileprivate lazy var tableView = UITableView.init(frame: CGRect.zero, style: .plain)
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TopicModel>>()
    fileprivate let viewModel = TopicListViewModel.init()
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        tableView.addPullRefresh { [weak self] () in
            self?.viewModel.reloadData()
        }
        tableView.addPushRefresh { [weak self] () in
            self?.viewModel.loadMoreData()
        }
        
        dataSource.configureCell = { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = "\(item.title ?? "")"
            return cell!
        }
        
        viewModel.result?
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        viewModel.refresh.asObservable().subscribe(onNext: { (status) in
            self.refreshStatus(status: status)
        }).addDisposableTo(disposeBag)
        
        tableView.startPullRefresh()
    }
}


public protocol RefreshScrollViewProtocol {
    var scrollView: UIScrollView { get }
    func refreshStatus(status:RefreshStatus)
}
extension RefreshScrollViewProtocol where Self: UIViewController {
    func refreshStatus(status:RefreshStatus){
        switch status {
        case .PullSuccess:
            self.scrollView.stopPullRefreshEver()
        case .PushSuccess:
            self.scrollView.stopPushRefreshEver()
        case .PullFailure:
            self.scrollView.stopPullRefreshEver()
        case .PushFailure:
            self.scrollView.stopPushRefreshEver()
        case .NoMoreData :
            self.scrollView.stopPushRefreshEver(false)
        case .Unknown:break
        }
    }
}
