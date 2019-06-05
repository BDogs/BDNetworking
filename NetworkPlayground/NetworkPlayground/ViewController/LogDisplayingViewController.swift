//
//  LogDisplayingViewController.swift
//  NetworkPlayground
//
//  Created by 诸葛游 on 2019/4/22.
//  Copyright © 2019 品驰医疗. All rights reserved.
//

import Cocoa

class LogDisplayingViewController: NSViewController {

    @IBOutlet var logTextView: NSTextView!
    
    @IBOutlet weak var noteLabel: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        NotificationCenter.default.addObserver(self, selector: #selector(logDidUpdate), name: .BDNetworkLoggerDidUpudate, object: nil)
        reload()
    }
    
    @objc func logDidUpdate() -> Void {
        reload()
    }
    
    func reload() -> Void {
        var content = ""
        let caches = BDNetworkLogger.shared.caches
        
        for temp in caches {
            content.append(temp)
            content.append("\n")
        }
        noteLabel.stringValue = "logs: \(caches.count)"
        logTextView.string = content
    }
    
}
