//
//  NetClient.swift
//  RxTableviewDemo
//
//  Created by 郭锐 on 2017/1/19.
//  Copyright © 2017年 郭锐. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

public enum NetError:Swift.Error {
    case HTTPError(NSError)
    case CustomError(Int,String)
    case DataError
    
    func handle() -> NetError {
        
        return self
    }
}

public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
}
extension Request {
    var method: HTTPMethod {
        return .get
    }
}

struct NetClient {
    static let host = "http://api.dagoogle.cn"
    
    static let SUCCESSCODE    = 200
    
    static let RESULT_CODE    = "status"
    static let RESULT_MEG     = "error"
    static let RESULT_DATA    = "data"
    
    static func send<R:Request>(_ r:R) -> Observable<[String:Any]> {
        return Observable<[String:Any]>.create({ (observer) -> Disposable in
            Alamofire.request(URL.init(string: "\(self.host)\(r.path)")!, method: .post, parameters: r.parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response) in
                switch response.result {
                case .success(let res):
                    if let json = res as? [String : Any], let code = json[RESULT_CODE] as? Int, let msg = json[RESULT_MEG] as? String {
                        if code == SUCCESSCODE {
                            observer.onNext(json)
                            observer.onCompleted()
                        }else {
                            observer.onError(NetError.CustomError(code,msg))
                        }
                    }else{
                        observer.onError(NetError.DataError)
                    }
                case .failure(let error as NSError):
                    observer.onError(NetError.HTTPError(error).handle())
                default:break
                }
            }
            return Disposables.create {
            }
        })
    }
}
