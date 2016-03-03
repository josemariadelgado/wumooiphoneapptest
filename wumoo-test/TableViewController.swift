//
//  TableViewController.swift
//  wumoo-test
//
//  Created by José María Delgado  on 3/3/16.
//  Copyright © 2016 José María Delgado . All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var tableData:Array<String> = Array <String>()
    
    func jsonConn(channelId: String){
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "http://api.wumoo.com/v1/events?channelIds=\(channelId)&limit=1000")!, completionHandler: { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                var wallpaperUrls = [String]()
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    
                    if let items = json["items"] as? [[String: AnyObject]] {
                        for item in items {
                            if let url = item["extDescription"] as? String {
                                wallpaperUrls.append(url)
                                self.tableData.append(url)
                            }
                        }
                    }
                    print(wallpaperUrls)
                    self.do_table_refresh()
                } catch {
                    print("error serializing JSON: \(error)")
                }
            }
        }).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonConn("13207")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tableData[indexPath.row]
        
        return cell
        
    }

}
