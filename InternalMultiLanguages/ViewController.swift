//
//  ViewController.swift
//  InternalMultiLanguages
//
//  Created by Mai Nguyen Thi Quynh on 11/16/15.
//  Copyright © 2015 econ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
    
    var data:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        data = LanguageManager.getLanguageStrings()
        bottomButton.setTitle(NSLocalizedString("Hello", comment: ""), forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if indexPath.row == LanguageManager.currentLanguageIndex() {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        cell?.textLabel?.text = data[indexPath.row]
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let isPreviousLanguageRTL = LanguageManager.isCurrentLanguageRTL()
        LanguageManager.saveLanguageByIndex(indexPath.row)
        let isCurrentLanguageRTL = LanguageManager.isCurrentLanguageRTL()
        
        self.tableView.reloadData()
        
        if isPreviousLanguageRTL != isCurrentLanguageRTL {
            let alert = UIAlertController(title: "Attention", message: "Please, restart the application for applying right-to-left user interface or vice versa", preferredStyle: .Alert)
            let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            
            dispatch_async(dispatch_get_main_queue(), {
                //self.presentViewController(alert, animated: true, completion: nil)
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            })
        }
        
        reloadRootViewController()
    }
    
    func reloadRootViewController() {
        let appDelegate = UIApplication.sharedApplication().delegate
        let storyboardName = "Main"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        appDelegate?.window!!.rootViewController = storyboard.instantiateInitialViewController()
    }
}

