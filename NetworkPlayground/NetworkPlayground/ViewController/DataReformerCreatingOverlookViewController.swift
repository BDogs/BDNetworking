//
//  DataReformerCreatingOverlookViewController.swift
//  NetworkPlayground
//
//  Created by 诸葛游 on 2019/4/28.
//  Copyright © 2019 品驰医疗. All rights reserved.
//

import Cocoa

class DataReformerCreatingOverlookViewController: NSViewController {
    
    @IBOutlet weak var fileNameTextField: NSTextField!
    
    @IBOutlet var responseTextView: NSTextView!
    
    @IBOutlet var reformerTextView: NSTextView!
    
    var response: String = ""
    var info: APIInfo?
    var isAuto = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        responseTextView.string = response
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
        
        fileNameTextField.stringValue = "PL\(temp.joined())APIDataReformer"
    }
    
    func modificationContent() -> Void {
        var content = BDNetworkFileClient.shared.fetchFileContent(type: .dataReformer)
        let fileName = fileNameTextField.stringValue
        content = content.replacingOccurrences(of: "___FILEBASENAMEASIDENTIFIER___", with: fileName)
        
        let response = responseTextView.string
        guard let responseData = response.data(using: .utf8) else { return }
        do {
           let object = try JSONSerialization.jsonObject(with: responseData, options: [.allowFragments])
            if let objectDic = object as? [String: Any] {
                if let dataDic = objectDic["data"] as? [String: Any] {
                    let infoKey = createInfoKey(dic: dataDic)
                    content = content.replacingOccurrences(of: "___InfoKeys___", with: infoKey)
                    let result = createResult(isArray: false)
                    content = content.replacingOccurrences(of: "___Result___", with: result)
                } else if let dataArray = objectDic["data"] as? [[String: Any]] {
                    if let first = dataArray.first {
                        let infoKey = createInfoKey(dic: first)
                        content = content.replacingOccurrences(of: "___InfoKeys___", with: infoKey)
                        let result = createResult(isArray: true)
                        content = content.replacingOccurrences(of: "___Result___", with: result)
                    }
                }
            }
        } catch _ {
            
        }
        
        
        reformerTextView.string = content
    }
    
    func createInfoKey(dic: [String: Any]) -> String {
        var infoKey = "\n"
        for key in dic.keys {
            let reformedKey  = key.fileName(separator: "_").lowercasePrefix()
            let row = "        public static let \(reformedKey): InfoKey = InfoKey(rawValue: \"\(key)\")\n"
            infoKey.append(row)
        }
        return infoKey
    }
    
    func createResult(isArray: Bool) -> String {
        let result: String
        
        if isArray {
            result = "\n        var reformedData: [[InfoKey: Any]] = []\n        let isSuccess = dic[\"success\"] as? Bool ?? false\n        guard isSuccess else {\n            result[.reformedData] = reformedData\n            return result\n        }\n        guard let source = dic[\"data\"] as? [[String: Any]] else {\n            result[.reformedData] = reformedData\n            return result }\n\n        for i in 0..<source.count {\n            var temp = source[i]\n            reformedData.append([:])\n\n            for element in temp.keys {\n                let key = InfoKey(rawValue: element)\n                reformedData[i][key] = temp[element]\n            }\n        }\n        result[.reformedData] = reformedData\n        return result\n"
        } else {
            result = "\n        var reformedData: [InfoKey: Any] = [:]\n        guard let source = dic[\"data\"] as? [String: Any] else {\n            result[.reformedData] = reformedData\n            return result }\n\n        for element in source.keys {\n            let key = InfoKey(rawValue: element)\n            reformedData[key] = source[element]\n        }\n\n        result[.reformedData] = reformedData\n        return result\n"
        }
        
        return result
    }
    
    func save() -> Void {
        let floder = info?.relativeUrl.components(separatedBy: "/").first
        let content = reformerTextView.string
        let fileName = fileNameTextField.stringValue
        guard !content.isEmpty else {
            return
        }
        let isSuccess = BDNetworkFileClient.shared.save(type: .dataReformer, content: content, fileName: fileName, floder: floder)
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
    
    @IBAction func refreshClicked(_ sender: NSButton) {
         modificationContent()
    }
    
}
