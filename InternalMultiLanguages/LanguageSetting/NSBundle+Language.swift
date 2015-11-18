//
//  NSBundle+Language.swift
//  InternalMultiLanguages
//
//  Created by Mai Nguyen Thi Quynh on 11/16/15.
//  Copyright © 2015 econ. All rights reserved.
//

import UIKit

var kBundleKey = UnsafePointer<Void>(bitPattern: 0)
var shareInstance = 0

class BundleEx: NSBundle {
    
    override func localizedStringForKey(key: String, value: String?, table tableName: String?) -> String {
        let languageBundle: NSBundle? = objc_getAssociatedObject(self, kBundleKey) as? NSBundle
        
        if let bundle = languageBundle {
            return bundle.localizedStringForKey(key, value: value, table: tableName)
        }
        else {
            return super.localizedStringForKey(key, value: value, table: tableName)
        }
    }
}

extension NSBundle {
    
    class func setLanguage(language: String) {

        if shareInstance == 0 {
            object_setClass(NSBundle.mainBundle(), BundleEx.self)
            shareInstance = 1
        }
        
        if let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj") {
            let value = NSBundle(path: path)
            
            guard let _ = value else {
                return
            }
            
            objc_setAssociatedObject(NSBundle.mainBundle(), kBundleKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}