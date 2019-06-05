//
//  PinsLifeTokenSettingViewController.swift
//  NetworkPlayground
//
//  Created by 诸葛游 on 2019/4/19.
//  Copyright © 2019 品驰医疗. All rights reserved.
//

import Cocoa

protocol PinsLifeTokenSettingViewControllerDelegate: NSObjectProtocol {
    func tokenSettingDidChanged(settings: (apiManagerName: String, setting: [Int: PLUserInfo])) -> Void
}

class PinsLifeTokenSettingViewController: NSViewController {
    
    
    var settings: (apiManagerName: String, setting: [Int: PLUserInfo]) = ("", [:])
    weak var delegate: PinsLifeTokenSettingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        displayHistory()
    }
    
    func displayHistory() -> Void {
        
        for i in 0...2 {
            let tag1 = (i+1)*10
            let tag2 = tag1 + 1
            
            let field1 = view.viewWithTag(tag1) as? NSTextField
            let field2 = view.viewWithTag(tag2) as? NSTextField
            
            field1?.stringValue = settings.setting[i]?.userName ?? ""
            field2?.stringValue = settings.setting[i]?.vCode ?? ""
        }
        let apiFiled = view.viewWithTag(40) as? NSTextField
        apiFiled?.stringValue = settings.apiManagerName
    }
    
    @IBAction func saveAction(_ sender: NSButton) {
        let apiFiled = view.viewWithTag(40) as? NSTextField
        let apiName = apiFiled?.stringValue ?? ""
        
        var settings: [Int: PLUserInfo] = [:]
        for i in 0...2 {
            let tag1 = (i+1)*10
            let tag2 = tag1 + 1
            
            let field1 = view.viewWithTag(tag1) as? NSTextField
            let field2 = view.viewWithTag(tag2) as? NSTextField
            
            if let text1 = field1?.stringValue, !text1.isEmpty,
                let text2 = field2?.stringValue, !text2.isEmpty {
                settings[i] = PLUserInfo(userName: text1, vCode: text2, token: nil)
            }
            
        }
        
        PLUserInfo.save(info: (apiName, settings))
        delegate?.tokenSettingDidChanged(settings: (apiName, settings))
        dismiss(self)
    }
    
}
