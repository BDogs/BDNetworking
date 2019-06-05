//
//  APIManagerCreateOverlookViewController.swift
//  NetworkPlayground
//
//  Created by 诸葛游 on 2019/4/28.
//  Copyright © 2019 品驰医疗. All rights reserved.
//

import Cocoa

class APIManagerCreateOverlookViewController: NSViewController {
    
    @IBOutlet weak var fileNameTextField: NSTextField!
    @IBOutlet var textView: NSTextView!
    var content: String = ""
    var info: APIInfo?
    var isAuto = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        textView.string = content
        autoReformFileName()
        modificationContent()
        if isAuto {
            save()
        }
    }
    
    
    func autoReformFileName() -> Void {
        guard let info = info else { return }
        let fileName = info.relativeUrl
        var temp = fileName.components(separatedBy: "/")
        temp.removeAll { (element) -> Bool in
            return element == "/"
        }
        for i in 0..<temp.count {
            let element = temp[i]
            guard element.count > 0 else {
                continue
            }
            let prefix = element.prefix(1)
            let new = prefix.capitalized
            temp[i] = element.replacingCharacters(in: element.startIndex..<element.index(element.startIndex, offsetBy: 1), with: new)
        }
        
        fileNameTextField.stringValue = "PL\(temp.joined())APIManager"
    }
    
    func modificationContent() -> Void {
        guard let info = info else { return }
        guard let serviceName = info.service.className.components(separatedBy: ".").last else { return }
        
        let fileName = fileNameTextField.stringValue
        content = content.replacingOccurrences(of: "___FILEBASENAMEASIDENTIFIER___", with: fileName)
        content = content.replacingOccurrences(of: "___BDServiceType___", with: "BDServiceIdentifier.k\(serviceName)")
        content = content.replacingOccurrences(of: "___RelativeUrl___", with: info.relativeUrl)
        
        textView.string = content
    }
    
    func save() -> Void {
        let floder = info?.relativeUrl.components(separatedBy: "/").first
        let fileName = fileNameTextField.stringValue
        guard !fileName.isEmpty else {
            return
        }
        let isSuccess = BDNetworkFileClient.save(type: .apiManager, content: textView.string, fileName: fileName, floder: floder)
        
        let title = isSuccess ? "保存成功-\(fileName)" : "保存失败-\(fileName)"
        let alert = NSAlert()
        alert.messageText = title
        guard let window = self.view.window else { return }
        alert.beginSheetModal(for: window) { (response) in
            
        }
    }
    
    @IBAction func saveClickedAction(_ sender: NSButton) {
      save()
    }
    
}
