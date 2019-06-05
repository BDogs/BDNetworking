//
//  BDAPIBaseManager.swift
//  BDNetworkForSwift
//
//  Created by 诸葛游 on 2017/4/17.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

//import UIKit
import Foundation

let kBDAPIBaseManagerRequestID = "kBDAPIBaseManagerRequestID"
let kBSUserTokenInvalidNotification = "kBSUserTokenInvalidNotification"
let kBSUserTokenIllegalNotification = "kBSUserTokenIllegalNotification"
let kBSUserTokenNotificationUserInfoKeyRequestToContinue = "kBSUserTokenNotificationUserInfoKeyRequestToContinue"
let kBSUserTokenNotificationUserInfoKeyManagerToContinue = "kBSUserTokenNotificationUserInfoKeyManagerToContinue"


open class BDAPIBaseManager: NSObject {
    
    fileprivate(set) var fetchedRawData: Any? // 网络请求后，没有经过reformer加工的数据
    fileprivate(set) var isNativeDataEmpty: Bool?
    fileprivate(set) var requestList: [Int] = []
    fileprivate(set) var cache: BDCache?
    fileprivate(set) var response: BDDataResponse<Any>?
    
    fileprivate(set) var isReachable: Bool?
    public fileprivate(set) var isLoading: Bool = false
    
    public var error: Error?
    
    public weak var delegate: BDAPIBaseManagerCallBackDelegate? // 回调代理
    public weak var paramSource: BDAPIManagerSourceDelegate? // 请求参数代理，一般为 controller
    public weak var validator: BDAPIManagerValidator? // 验证器
    public weak var interceptor: BDAPIManagerInterceptor? // 拦截器
    
    lazy var child: BDAPIManagerProtocal = {
        assert((self as? BDAPIManagerProtocal) != nil, "\(self) 没有遵循 BDAPIManagerProtocal 协议")
        return self as! BDAPIManagerProtocal
    }()
    
    // MARK: - life cycle
    required override public init() {
        
    }
    
    deinit {
        cancelAllRequests()
        requestList = []
    }
    
    // MARK: - public func
    public func cancelAllRequests() -> Void {
        BDAPIProxy.shareInstance.cancelRequests(requestIdList: requestList)
        requestList.removeAll()
//        if #available(iOS 5.0, *) {
//
////            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
    }
    
    public func cancelARequest(requestId: Int) -> Void {
        guard requestList.contains(requestId) else {
            return
        }
        BDAPIProxy.shareInstance.cancelARequest(requestId: requestId)
        removeRequestIdFromList(requestId: requestId)
//        if #available(iOS 5.0, *) {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
    }
    
    /// 没有传入 reformer 或者 reformer 没有实现协议，那么获取到的就是没有处理过的数据
    public func fetchData(reformer: BDAPIManagerDataReformer?) -> Any {
        var resultData: Any?
        if reformer != nil &&  reformer!.responds(to: #selector(BDAPIManagerDataReformer.reformData(manager:data:))) {
            resultData = reformer?.reformData(manager: self, data: self.fetchedRawData)
        } else {
            resultData = self.fetchedRawData
        }
        return resultData ?? []
    }
    
    // MARK: - calling api
    public func loadData() -> Int {
        let params = paramSource?.paramsForApi(manager: self)
        let requestId = loadDataWithParams(params: params)
        return requestId
    }
    
    private func loadDataWithParams(params: [String: Any]?) -> Int {
        var requestId = 0
        
        // 添加 Service 的 extraParmas
        let service = BDServiceFactory.shareInstance.serviceWithIdentifier(identifier: self.child.serviceType())
        // 这里认为 Service 为 nil，它的生成失败是派生类的定义有问题，需要提醒开发者
        assert(service != nil, "service 生成失败")
        let serviceCommonParams = self.reformServiceCommonParams(params: service?.extraParams) ?? [:]
        var reformedParams = self.reformParams(params: params) ?? [:]
        
        for (key, value) in serviceCommonParams {
            reformedParams[key] = value
        }
        
        guard shouldCallAPI(params: reformedParams) else {
            // 拦截器拦截
            return requestId
        }
        
        if self.validator == nil || (self.validator != nil && self.validator!.isRequestParamsCorrect(manager: self, params: reformedParams)) {
            
            if self.child.shouldLoadFromNative() {
                // 去读本地缓存
            }
            
            if self.child.shouldCache() {
                // 有缓存，读取，返回，不需要再进行网络请求了
                return 0
            }
            
            // 网络请求
            if BDNetworkingContext.shared.isReachable {
//                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.isLoading = true
                let httpMethod = self.child.requestType()
                requestId = BDCallAPI(method: httpMethod, params: reformedParams)
                reformedParams[kBDAPIBaseManagerRequestID] = requestId
                afterCallingAPI(params: reformedParams)
                return requestId
            } else {
                failedOnCallingAPI(response: nil, error: BDError.networkIsNotReachable)
                return requestId
            }
        } else {
            // 请求参数验证失败
            failedOnCallingAPI(response: nil, error: BDError.validateFailed(reason: .requestParamsValidateFailed))
            return requestId
        }
    }
    
    // MARK: - api callback
    private func failedOnCallingAPI(response: BDDataResponse<Any>?, error: Error?) -> Void {
        
        self.isLoading = false
        self.response = response
        
        var needCallBack = true
        
        // 集中处理 Service 错误问题，比如token失效要抛通知等
        let service = BDServiceFactory.shareInstance.serviceWithIdentifier(identifier: self.child.serviceType())
        if service as? BDServiceProtocol != nil {
          needCallBack = (service?.child!.shouldCallBackByFailedOnCallingAPI(response: response))!
        }
        
        guard needCallBack else {
            return
        }
        
        let requestId = response == nil ? 0 : response!.requestId
        self.error = error
        removeRequestIdFromList(requestId: requestId)
        
        if let value = self.response?.result.value {
            self.fetchedRawData = value
        } else {
            self.fetchedRawData = self.response?.data
        }

        if beforePerformFail(response: response) {
            self.delegate?.managerCallAPIDidFailed(manager: self)
        }
        afterPerformFail(response: response)
    }
    
    private func successedOnCallingAPI(response: BDDataResponse<Any>) -> Void {
        self.isLoading = false
        self.response = response
        if self.child.shouldLoadFromNative() {
            // 缓存到本地
        }
        
        if let value = self.response?.result.value {
            self.fetchedRawData = value
        } else {
            self.fetchedRawData = self.response?.data
        }
        
        removeRequestIdFromList(requestId: (self.response?.requestId)!)
        
        if (self.validator?.isCallBackCorrect(manager: self, callBackData: self.fetchedRawData))! {
            
            if self.child.shouldCache() {
                // 缓存
            }
            
            if beforePerformSuccess(response: response) {
                if self.child.shouldLoadFromNative() {
                    if response.isCache {
                        self.delegate?.managerCallAPIDidSuccess(manager: self)
                    }
                    
                    if self.isNativeDataEmpty! {
                        self.delegate?.managerCallAPIDidSuccess(manager: self)
                    }
                } else {
                    self.delegate?.managerCallAPIDidSuccess(manager: self)
                }
            }
            afterPerformSuccess(response: response)
        } else {
            failedOnCallingAPI(response: nil, error: BDError.validateFailed(reason: .fetchedRawDataValidateFailed))
        }
    }
    
    // MARK: - func for child
    public func cleanData() -> Void {
        //        self.cache.clean()
        self.fetchedRawData = nil
        self.error = nil
    }
    
    /// 在参数验证之前，可以重载或遵循协议实现这个方法，进行请求参数修正
    /// 使用场景举例：
    /// 1.请求分页需要的 page_size 和 page_number 参数，可以通过 reformParams 让 APIManager 自己管理
    /// 2.特定的 API 需要额外的公共参数的时候
    /// 3.有一些 API 是根据传递的参数来决定执行逻辑的，本质上它们是不同的 API，针对不同的执行逻辑派生不同的名字的 APIManager，然后在 reformParams 里提供决定执行逻辑的参数，降低代码的耦合度
    @objc open func reformParams(params: [String: Any]?) -> [String: Any]? {
        let childIMP = (self.child as? NSObject)?.method(for: #selector(reformParams(params:)))
        let selfIMP = self.method(for: #selector(reformParams(params:)))
        if childIMP == selfIMP {
            // 重写 reformParams: 并调用[super reformParams:params] 就会走这个方法，那么子类中的 return 就不会有意义了
            return params
        } else {
            // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
            // 如果child是另一个对象，就会跑到这里
            let result = self.child.reformParams(params: params)
            return result != nil ? result! : params
        }
    }
    
    @objc open func reformServiceCommonParams(params: [String: Any]?) -> [String: Any]? {
        let childIMP = (self.child as? NSObject)?.method(for: #selector(reformServiceCommonParams(params:)))
        let selfIMP = self.method(for: #selector(reformServiceCommonParams(params:)))
        if childIMP == selfIMP {
            // 继承
            return params
        } else {
            // 非继承，并遵循 BDAPIManagerProtocal
            let result = self.child.reformServiceCommonParams(params: params)
            return result ?? params
        }
    }
    
    
//    public func shouldCache() -> Bool {
//        return BDNetworkingConfiguration.shouldCache
//    }
    
    // MARK: - private func
    private func BDCallAPI(method: BDAPIRequestType, params: [String : Any]? = nil) -> Int {
        let requestId = BDAPIProxy.shareInstance.callApi(serviceIdentifier: self.child.serviceType(), relativeUrl: self.child.relativeUrl(), params: params, method: method, encodingType: self.child.encodingType) { (response) in
//            UIApplicatbbion.shared.isNetworkActivityIndicatorVisible = false
            if response.result.isSuccess {
                self.successedOnCallingAPI(response: response)
            } else {
                self.failedOnCallingAPI(response: response, error: response.result.error)
            }
        }
        return requestId
    }
    
    private func removeRequestIdFromList(requestId: Int) -> Void {
        let index = requestList.index(of: requestId)
        guard index != nil else {
            return
        }
        requestList.remove(at: index!)
    }
    
    // MARK: - func for interceptor
    /*
     拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
     当两种情况共存的时候，子类重载的方法##一定要调用一下super##
     然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
     
     子类中的重载，写法例子：
     override func text() -> Bool {
     return false && super.text()
     }
     
     notes:
     正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
     但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
     所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
     装饰者模式？
     */
    
    /// 只有返回 true 才会继续调用 API
    public func shouldCallAPI(params: [String: Any]?) -> Bool {
        if self.interceptor !== self && self.interceptor != nil {
            return self.interceptor!.shouldCallAPI(manager: self, params: params)
        } else {
            return true
        }
    }
    
    public func afterCallingAPI(params: [String: Any]?) -> Void {
        if self !== self.interceptor && self.interceptor != nil {
            self.interceptor?.afterCallingAPI(manager: self, params: params)
        }
    }
    
    public func beforePerformFail(response:BDDataResponse<Any>?) -> Bool {
        var result = true
        if self !== self.interceptor && self.interceptor != nil {
            result = self.interceptor!.beforePerformFail(manager: self, response: response)
        }
        return result
    }
    
    public func afterPerformFail(response:BDDataResponse<Any>?) -> Void {
        if self !== self.interceptor && self.interceptor != nil {
            self.interceptor!.afterPerformFail(manager: self, response: response)
        }
    }
    
    public func beforePerformSuccess(response:BDDataResponse<Any>?) -> Bool {
        var result = true
        if self !== self.interceptor && self.interceptor != nil {
            result = self.interceptor!.beforePerformSuccess(manager: self, response: response)
        }
        return result
    }
    
    public func afterPerformSuccess(response:BDDataResponse<Any>?) -> Void {
        if self !== self.interceptor && self.interceptor != nil {
            self.interceptor!.afterPerformSuccess(manager: self, response: response)
        }
    }
}

/// BDAPIBaseManager 的派生类必须遵守的协议
public protocol BDAPIManagerProtocal: NSObjectProtocol {
    func relativeUrl() -> String
    func serviceType() -> String
    func requestType() -> BDAPIRequestType
    func shouldCache() -> Bool
    // optional
    func reformParams(params: [String: Any]?) -> [String: Any]?
    func reformServiceCommonParams(params: [String: Any]?) -> [String: Any]?
    func shouldLoadFromNative() -> Bool
    func extraHttpHeaderFields() -> [String: String]
    
    var encodingType: BDParameterEncoding { get }
    
    
    //        func cleanData() -> Void
    //    func loadData(params: [String: Any]?) -> Int
}

extension BDAPIManagerProtocal {
    public func extraHttpHeaderFields() -> [String: String] {
        return [:]
    }
    
    public var encodingType: BDParameterEncoding {
        get {
            return .json
        }
    }
    
}

/// 请求结果回调
public protocol BDAPIBaseManagerCallBackDelegate: NSObjectProtocol {
    func managerCallAPIDidSuccess(manager: BDAPIBaseManager) -> Void
    func managerCallAPIDidFailed(manager: BDAPIBaseManager) -> Void
}

public protocol BDAPIManagerSourceDelegate: NSObjectProtocol {
    func paramsForApi(manager: BDAPIBaseManager) -> [String: Any]?
}

/* 验证器，用于验证API的返回或者调用API的参数是否正确
 使用场景：
 当我们确认一个api是否真正调用成功时，要看的不光是status，还有具体的数据内容是否为空。由于每个api中的内容对应的key都不一定一样，甚至于其数据结构也不一定一样，因此对每一个api的返回数据做判断是必要的，但又是难以组织的。
 为了解决这个问题，manager有一个自己的validator来做这些事情，一般情况下，manager的validator可以就是manager自身。
 
 1.有的时候可能多个api返回的数据内容的格式是一样的，那么他们就可以共用一个validator。
 2.有的时候api有修改，并导致了返回数据的改变。在以前要针对这个改变的数据来做验证，是需要在每一个接收api回调的地方都修改一下的。但是现在就可以只要在一个地方修改判断逻辑就可以了。
 3.有一种情况是manager调用api时使用的参数不一定是明文传递的，有可能是从某个变量或者跨越了好多层的对象中来获得参数，那么在调用api的最后一关会有一个参数验证，当参数不对时不访问api，同时自身的errorType将会变为CTAPIManagerErrorTypeParamsError。这个机制可以优化我们的app。
 
 4.特殊场景：租房发房，用户会被要求填很多参数，这些参数都有一定的规则，比如邮箱地址或是手机号码等等，我们可以在validator里判断邮箱或者电话是否符合规则，比如描述是否超过十个字。从而manager在调用API之前可以验证这些参数，通过manager的回调函数告知上层controller。避免无效的API请求。加快响应速度，也可以多个manager共用.
 */
public protocol BDAPIManagerValidator: NSObjectProtocol {
    /*
     针对 API 返回数据进行验证：
     通过判断 API 是否返回关键字段，来决定本次 API 调用是否成功，对 API 返回的脏数据做一些预防
     所有的 callback 数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
     因为判断逻辑都在这里做掉了。
     而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放到回调到controller的delegate方法里面去做。
     */
    func isCallBackCorrect(manager: BDAPIBaseManager, callBackData: Any?) -> Bool
    /// 针对调用 API 的参数进行验证
    func isRequestParamsCorrect(manager: BDAPIBaseManager, params: [String: Any]?) -> Bool
}

/// 拦截器
/// 内部拦截：在继承的子类中重载父类拦截方法进行拦截，可以做到尽可能小范围地影响业务逻辑，避免过多的耦合
/// 外部拦截：通过拦截对象挂代理进行拦截，可以做到相同的处理逻辑在一个拦截器内进行处理，提高集成度，减少维护成本
public protocol BDAPIManagerInterceptor: NSObjectProtocol {
    func beforePerformSuccess(manager: BDAPIBaseManager, response: BDDataResponse<Any>?) -> Bool
    func afterPerformSuccess(manager: BDAPIBaseManager, response:BDDataResponse<Any>?) -> Void
    
    func beforePerformFail(manager: BDAPIBaseManager, response:BDDataResponse<Any>?) -> Bool
    func afterPerformFail(manager: BDAPIBaseManager, response:BDDataResponse<Any>?) -> Void
    
    func shouldCallAPI(manager: BDAPIBaseManager, params: [String: Any]?) -> Bool
    func afterCallingAPI(manager: BDAPIBaseManager, params: [String: Any]?) -> Void
}



