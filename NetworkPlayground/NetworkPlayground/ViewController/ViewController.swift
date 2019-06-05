//
//  ViewController.swift
//  NetworkPlayground
//
//  Created by 诸葛游 on 2019/3/28.
//  Copyright © 2019 品驰医疗. All rights reserved.
//

import Cocoa
//import os.log

class ViewController: NSViewController {
    
    @IBOutlet weak var tokenApiMenu: NSMenu!
    @IBOutlet weak var serviceMenu: NSMenu!
    
    @IBOutlet weak var routeInputtingTextField: NSTextField!
    
    @IBOutlet weak var serviceNoteTextField: NSTextField!
    
    @IBOutlet weak var environmentSelectPopUpButton: NSPopUpButton!
    
    @IBOutlet var responseTextView: NSTextView!
    
    @IBOutlet weak var reachableIndicatorView: NSView!
    
    
    @IBOutlet weak var paramList: NSTableView!
    
//    @IBOutlet var paramTextView: NSTextView!
    
    var isOnline = false {
        didSet {
            BDNetworkingContext.shared.isOnline = isOnline
            environmentSelectPopUpButton.isHidden = isOnline
            
            updateServiceNoteDisplay()
        }
    }
    
    var isReachable: Bool = false {
        didSet {
            reachableIndicatorView.layer?.backgroundColor = isReachable ? NSColor.green.cgColor : NSColor.red.cgColor
        }
    }
    
    
    let environmentCodes: [BDNetworkingEnvironmentCode] = [.develep, .testing, .production]
    
    var selectedService: BDService = PLPythonServer()
    var selectedTokenApiManager: BDAPIBaseManager = UserLoginByCodeAPIManager()
    
    var paramSource: [[String: String]] = [["type":"String"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeServiceMenu()
        initializeTokenApiMenu()
        
        BDNetworkingContext.shared.listen { [weak self] (isReachable) in
            self?.isReachable = isReachable
        }
        
        BDNetworkingContext.shared.accessToken = selectedUserSetting.setting[BDNetworkingContext.shared.environmentCode]?.token
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: - Method
    func initializeServiceMenu() -> Void {
        let servicesNames = fetchServiceNames()
        let serviceMenuItems = reformServerMenuItems(titles: servicesNames)
        serviceMenu.items = serviceMenuItems
        serviceMenu.update()
    }
    
    func initializeTokenApiMenu() -> Void {
        let names = fetchApiManagerNames()
        let items = reformTokenApiMenuItems(titles: names)
        tokenApiMenu.items = items
        tokenApiMenu.update()
    }
    
    func fetchApiManagerNames() -> [String] {
        var result = userSettings.map { (arg0) -> String in
            let (key, _) = arg0
            return key
        }

        result.removeAll { (element) -> Bool in
            return element.isEmpty
        }
        return result
    }
    
    func reformTokenApiMenuItems(titles: [String]) -> [NSMenuItem] {
        var items: [NSMenuItem] = []
        var topIndex = 0
        
        for element in titles {
            if element == "PLPythonServer" {
                topIndex = titles.firstIndex(of: element) ?? 0
            }
            let item = NSMenuItem(title: element, action: #selector(tokenApiDidSelect(sender:)), keyEquivalent: element)
            items.append(item)
        }
        
        if topIndex != 0 {
            let temp = items[0]
            items[0] = items[topIndex]
            items[topIndex] = temp
        }
        
        return items
    }

    
    func fetchServiceNames() -> [String] {
        let manager = FileManager.default
        let path = "/Users/zhugeyou/Desktop/MyGitHub/BDNetworking/NetworkCustomSetting/CustomServices"
        guard let direnum = manager.enumerator(atPath: path) else { return [] }
        
        var fileNamesArr: [String] = []
        while let element = direnum.nextObject() as? String {
            
            if element.hasSuffix(".swift") {
                if let fileName = element.components(separatedBy: "/").last {
                    fileNamesArr.append(fileName.replacingOccurrences(of: ".swift", with: ""))
                }
            }
        }
        
        return fileNamesArr
    }
    
    func reformServerMenuItems(titles: [String]) -> [NSMenuItem] {
        var items: [NSMenuItem] = []
        var topIndex = 0
        
        for element in titles {
            if element == "PLPythonServer" {
                topIndex = titles.firstIndex(of: element) ?? 0
            }
            let item = NSMenuItem(title: element, action: #selector(serviceDidSelected(sender:)), keyEquivalent: element)
            items.append(item)
        }
        
        if topIndex != 0 {
            let temp = items[0]
            items[0] = items[topIndex]
            items[topIndex] = temp
        }
        
        return items
    }
    
    func updateServiceNoteDisplay() -> Void {
        serviceNoteTextField.stringValue = selectedService.apiBaseUrl ?? ""
    }
    
    func updateResponseDisplay(content: String) -> Void {
        responseTextView.string = content
    }
    
    
    // MARK: - Event
    
    @IBAction func paramAddingAction(_ sender: NSButton) {
        paramSource.append(["type":"String"])
        paramList.reloadData()
    }
    
    @IBAction func requestButtonDidClicked(_ sender: NSButtonCell) {
        let service = selectedService
        let t = type(of: service)
        let identifier = "\(t)"
        let relativeUrl = routeInputtingTextField.stringValue
        guard !relativeUrl.isEmpty else {
            return
        }
        var param: [String: Any] = [:]
        
        for temp in paramSource {
            if let key = temp["key"], let value = temp["value"], let type = temp["type"] {
                if type == "Int" {
                    param[key] = Int(value)
                } else {
                    param[key] = value
                }
            }
        }

        requestWithParam(param: param, relativeUrl: relativeUrl, identifier: identifier)
    }
    
    func requestWithParam(param: [String: Any], relativeUrl: String, identifier: String) -> Void {
        let _ = BDAPIProxy.shareInstance.callApi(serviceIdentifier: identifier, relativeUrl: relativeUrl, params: param, method: .post, encodingType: .json) { [weak self] (response) in
            let result = response.result.value as AnyObject
            guard !result.isKind(of: NSNull.self) else { return }
            if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: []), let json = String(data: jsonData, encoding: .utf8)  {
                self?.updateResponseDisplay(content: json)
            } else {
                self?.updateResponseDisplay(content: result.description ?? "error")
            }
            
        }
    }
    
    func requestWithParamJson(paramJson: String) -> Void {
        guard let data = paramJson.data(using: .utf8) else { return }
        
        guard let param = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: Any] else { return }
    }
    
    @IBAction func isOnlineSwitchAction(_ sender: NSButton) {
        isOnline = sender.state.rawValue == 1
    }
    
    @IBAction func environmentSelectedAction(_ sender: NSPopUpButton) {
        BDNetworkingContext.shared.environmentCode = sender.indexOfSelectedItem
        updateServiceNoteDisplay()
    }
    
    @objc func tokenApiDidSelect(sender: NSMenuItem) -> Void {
        let name = sender.title
        guard var appName = Bundle(for: BDServiceFactory.self).object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return
        }
        
        appName = appName.replacingOccurrences(of: "-", with: "_")
        
        selectedUserSetting = (name, userSettings[name]) as! (apiManagerName: String, setting: [Int : PLUserInfo])
        BDNetworkingContext.shared.accessToken = selectedUserSetting.setting[BDNetworkingContext.shared.environmentCode]?.token
        if let clz = NSClassFromString(appName + "." + name) as? BDAPIBaseManager.Type {
            let manager = clz.init()
            
            manager.delegate = self
            manager.paramSource = self
            selectedTokenApiManager = manager

        }
    }
    
    @objc func serviceDidSelected(sender: NSMenuItem) -> Void {
        let serviceName = sender.title
        guard var appName = Bundle(for: BDServiceFactory.self).object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return
        }

        appName = appName.replacingOccurrences(of: "-", with: "_")
        
        if let clz = NSClassFromString(appName + "." + serviceName) as? BDService.Type {
            let service = clz.init()
            selectedService = service
            updateServiceNoteDisplay()
        }
    }
    
    @IBAction func fetchTokenAction(_ sender: NSButton) {
        let _ = selectedTokenApiManager.loadData()
    }
    
    @IBAction func autoCreatingClickedAction(_ sender: Any) {
        self.performSegue(withIdentifier: "APIManagerCreating", sender: ["isAuto": true])
        self.performSegue(withIdentifier: "DataReformerCreating", sender: ["isAuto": true])

    }
    
    // MARK: - Api Call Back
    func callUserLoginByCodeAPIManagerDidSuccess(manager: UserLoginByCodeAPIManager) -> Void {
    
        let result = manager.fetchData(reformer: nil) as AnyObject
        if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: []), let json = String(data: jsonData, encoding: .utf8)  {
            updateResponseDisplay(content: json)
        } else {
            updateResponseDisplay(content: result.description ?? "error")
        }
        
        if let info = (result as? [String: Any])?["data"] as? [String: Any] {
            let token = info["token"] as? String
            BDNetworkingContext.shared.accessToken = token
            selectedUserSetting.setting[BDNetworkingContext.shared.environmentCode]?.token = token
//            PLUserInfo.save(infos: userSettings)
        }
    }
    
    func callUserLoginByCodeAPIManagerDidFailed(manager: UserLoginByCodeAPIManager) -> Void {
        
    }
    
    // MARK: - PLFDLoginAPIManager
    func callPLFDLoginAPIManagerDidSuccess(manager: PLFDLoginAPIManager) -> Void {
        let result = manager.fetchData(reformer: nil) as AnyObject
        if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: []), let json = String(data: jsonData, encoding: .utf8)  {
            updateResponseDisplay(content: json)
        } else {
            updateResponseDisplay(content: result.description ?? "error")
        }
        
        if let info = (result as? [String: Any])?["data"] as? [String: Any] {
            let token = info["token"] as? String
            BDNetworkingContext.shared.accessToken = token
            selectedUserSetting.setting[BDNetworkingContext.shared.environmentCode]?.token = token
            PLUserInfo.save(info: selectedUserSetting)
        }
    }
    
    func callPLFDLoginAPIManagerDidFailed(manager: PLFDLoginAPIManager) -> Void {
        
    }

    
    // MARK: - Lazy Var
    lazy var loginer: UserLoginByCodeAPIManager = {
        var loginer = UserLoginByCodeAPIManager()
        loginer.delegate = self
        loginer.paramSource = self
//        loginer.interceptor = PLContext.shared.networkInterceptor
        return loginer
    }()

    lazy var userSettings: [String: [Int: PLUserInfo]] = {
        let info = PLUserInfo.fetch()
        return info
    }()
    
    lazy var selectedUserSetting: (apiManagerName: String, setting: [Int : PLUserInfo]) = ("UserLoginByCodeAPIManager", self.userSettings["UserLoginByCodeAPIManager"] ?? [:])
    

}


extension ViewController: BDAPIBaseManagerCallBackDelegate, BDAPIManagerSourceDelegate {
    // MARK: - BDAPIBaseManagerCallBackDelegate
    func managerCallAPIDidSuccess(manager: BDAPIBaseManager) {
        if let temp = manager as? UserLoginByCodeAPIManager {
            callUserLoginByCodeAPIManagerDidSuccess(manager: temp)
        }
        if let temp = manager as? PLFDLoginAPIManager {
            callPLFDLoginAPIManagerDidSuccess(manager: temp)
        }
    }
    
    func managerCallAPIDidFailed(manager: BDAPIBaseManager) {
        
    }
    
    // MARK: - BDAPIManagerSourceDelegate
    func paramsForApi(manager: BDAPIBaseManager) -> [String : Any]? {
        var param: [String: Any] = [:]
        let info = selectedUserSetting.setting[BDNetworkingContext.shared.environmentCode]
        if let _ = manager as? UserLoginByCodeAPIManager {
            param["username"] = info?.userName//"18842310610"
            param["vcode"] = info?.vCode//"123456"
        }
        if let _ = manager as? PLFDLoginAPIManager {
            param["username"] = info?.userName//"18842310610"
            param["password"] = info?.vCode
        }

        return param
    }
}


extension ViewController {
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "tokenSetting" {
            if let controller = segue.destinationController as? PinsLifeTokenSettingViewController {
                controller.delegate = self
                controller.settings = selectedUserSetting
            }
        } else if segue.identifier == "APIManagerCreating" {
            if let controller = segue.destinationController as? APIManagerCreateOverlookViewController {
                let setting = sender as? [String: Any]
                let service = selectedService
                let info = APIInfo(relativeUrl: routeInputtingTextField.stringValue, service: service, requestType: .post)
                controller.info = info
                controller.isAuto = setting?["isAuto"] as? Bool ?? false
                controller.content = BDNetworkFileClient.fetchFileContent(type: .apiManager)
            }
        } else if segue.identifier == "DataReformerCreating" {
            if let controller = segue.destinationController as? DataReformerCreatingOverlookViewController {
                let setting = sender as? [String: Any]
                let service = selectedService
                let info = APIInfo(relativeUrl: routeInputtingTextField.stringValue, service: service, requestType: .post)
                controller.info = info
                controller.isAuto = setting?["isAuto"] as? Bool ?? false
                controller.response = responseTextView.string
            }

        }
    }
}

extension ViewController: PinsLifeTokenSettingViewControllerDelegate {
    func tokenSettingDidChanged(settings: (apiManagerName: String, setting: [Int : PLUserInfo])) {
        selectedUserSetting = settings
        
    }

    
}


extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return paramSource.count
    }
    

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let identifier = tableColumn?.identifier else { return nil }
        
        let cell = tableView.makeView(withIdentifier: identifier, owner: self)
        let textField = cell?.viewWithTag(1) as? NSTextField
        if let key = tableColumn?.identifier.rawValue {
            textField?.stringValue = paramSource[row][key] ?? ""
        }
        
        textField?.delegate = self
        return cell
    }
    
    
}


extension ViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        guard let cell = textField.superview else { return }
        let row = paramList.row(for: cell)
        let column = paramList.column(for: cell)
        guard row >= 0 else {
            return
        }
        guard column >= 0 else {
            return
        }
        var key = column == 0 ? "key" : "value"
        if column == 2 {
            key = "type"
        }
        paramSource[row][key] = textField.stringValue
    }
}
