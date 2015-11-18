//
//  LanguageManager.swift
//  InternalMultiLanguages
//
//  Created by Mai Nguyen Thi Quynh on 11/16/15.
//  Copyright © 2015 econ. All rights reserved.
//

import UIKit

let languageCodes = ["en", "de", "fr", "ar"]
let languageStrings: [String] = ["English", "German", "French", "Arabic"]
let languageRightToLeft = [false, false, false, true]
let languageSaveKey = "currentLanguageKey"

class LanguageManager: NSObject {
    
    class func setupCurrentLanguage() {
        var currentLanguage = NSUserDefaults.standardUserDefaults().objectForKey(languageSaveKey)
        
        if currentLanguage == nil {
            let languages = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages")
            
            if languages?.count > 0 {
                currentLanguage = languages![0]
                NSUserDefaults.standardUserDefaults().setObject(currentLanguage, forKey: languageSaveKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
        
        let currentLanguageIndex: Int = self.currentLanguageIndex()
        NSUserDefaults.standardUserDefaults().setBool(languageRightToLeft[currentLanguageIndex], forKey: "AppleTextDirection")
        NSUserDefaults.standardUserDefaults().setBool(languageRightToLeft[currentLanguageIndex], forKey: "NSForceRightToLeftWritingDirection")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        NSBundle.setLanguage(currentLanguage as! String)
    }
    
    class func getLanguageStrings() -> [String] {
        var array:[String] = []
        
        for var i = 0; i < Language.LanguageCount.rawValue; ++i {
            array.append(NSLocalizedString(languageStrings[i], comment: ""))
        }
        
        return array
    }
    
    class func currentLanguageString() -> String {
        var string = ""
        let currentCode = NSUserDefaults.standardUserDefaults().objectForKey(languageSaveKey) as! String
        
        for var i = 0; i < Language.LanguageCount.rawValue; ++i {
            if currentCode == languageCodes[i] {
                string = NSLocalizedString(languageStrings[i], comment: "")
                break
            }
        }
        
        return string
    }
    
    class func currentLanguageCode() -> String {
        return NSUserDefaults.standardUserDefaults().objectForKey(languageSaveKey) as! String
    }
    
    class func currentLanguageIndex() -> Int {
        var index = 0
        let currentCode = NSUserDefaults.standardUserDefaults().objectForKey(languageSaveKey) as! String
        
        for var i = 0; i < Language.LanguageCount.rawValue; ++i {
            if currentCode == languageCodes[i] {
                index = i
                break
            }
        }
        
        return index
    }
    
    class func saveLanguageByIndex(index: Int) {
        
        if index >= 0 && index < Language.LanguageCount.rawValue {
            let code = languageCodes[index]
            NSUserDefaults.standardUserDefaults().setObject(code, forKey: languageSaveKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            NSBundle.setLanguage(code)
        }
    }
    
    class func isCurrentLanguageRTL() -> Bool {
        let currentLanguageIndex = self.currentLanguageIndex()
        return languageRightToLeft[currentLanguageIndex]
    }

}

enum Language: Int {
    case English = 0
    case French // raw value is 2
    case German // raw value is 3
    case Arabic // raw value is 4
    case LanguageCount
}