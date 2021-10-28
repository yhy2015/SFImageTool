//
//  ViewController.swift
//  SFImageTool
//
//  Created by yangduoqing on 2021/10/27.
//

import Cocoa

class ViewController: NSViewController, NSSearchFieldDelegate, TextFieldFocusDelegate {

    @IBOutlet weak var replaceedImgView: NSImageView!
    @IBOutlet weak var currentImgView: NSImageView!
    @IBOutlet weak var searchField: MySearchField!
    @IBOutlet weak var pathTextField: NSTextField!
    
    private let projectPath = "/Users/yangduoqing/Desktop/projects/snowball"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchField.delegate = self
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (aEvent) -> NSEvent? in
            self.keyDown(with: aEvent)
            return aEvent
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { (aEvent) -> NSEvent? in
            self.keyDown(with: aEvent)
            return aEvent
        }
        
        searchField.delegate = self
    }

    override func keyDown(with event: NSEvent) {
        if searchField.become, event.specialKey == NSEvent.SpecialKey.enter {
            print(searchField.stringValue)
        }
    }
}

@objc protocol TextFieldFocusDelegate {
    @objc optional func textFieldDidGainFocus(_ textField: NSTextField)
    @objc optional func textFieldDidLoseFocus(_ textField: NSTextField)
}

class MySearchField: NSSearchField {
    var become: Bool = false

    override func becomeFirstResponder() -> Bool {
        become = super.becomeFirstResponder()
        return become
    }

    override func resignFirstResponder() -> Bool {
        let resign = super.resignFirstResponder()
        
        if become, resign, let _ = currentEditor() {
            (delegate as? TextFieldFocusDelegate)?.textFieldDidGainFocus?(self)
        }
        
        become = false
        return resign
    }
    
    override func textDidEndEditing(_ notification: Notification) {
        (delegate as? TextFieldFocusDelegate)?.textFieldDidLoseFocus?(self)
        super.textDidEndEditing(notification)
    }
}

