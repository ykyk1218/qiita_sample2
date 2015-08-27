//
//  QiitaTableViewController.swift
//  qiita_sample
//
//  Created by 小林芳樹 on 2015/08/21.
//  Copyright (c) 2015年 小林芳樹. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol QiitaDelegate {
    func qiitaUrlDelegate(qiitaUrl: String)
}


class QiitaTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
 
    var qiitaDelegate: QiitaDelegate?
    
    private var myItems:[String]=[]
    private var myUrls:[String]=[]
    
    private var qiitaTableView: UITableView!
    private var refreshControl: UIRefreshControl!
    private var qiitaDetailView: QiitaDetailViewController!
    
    private let qiitaUrl = "https://qiita.com/api/v2/items"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qiitaDetailView = QiitaDetailViewController()
        
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        qiitaTableView = UITableView(frame: CGRect(x:0, y:barHeight, width: displayWidth, height: displayHeight - barHeight))
        
        qiitaTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        qiitaTableView.dataSource = self
        qiitaTableView.delegate = self
       
        qiitaTableView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(qiitaTableView)
       
        
        requestQiita(qiitaUrl)
        addRefreshControl()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.addTarget(self, action: "pullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.qiitaTableView.addSubview(self.refreshControl)
        
    }
    
    func pullToRefresh() {
        println("reload!!")
        self.myItems = []
        self.myUrls = []
        requestQiita(qiitaUrl)
        self.qiitaTableView.reloadData()
    }
    
    private func requestQiita(url: String) -> NSData {
        var result = NSData()
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
            if (error == nil) {
                let json = SwiftyJSON.JSON(data: data)
                for (key: String, obj: JSON) in json {
                    println(obj["title"])
                    //self.myItems["url"] =
                    var title = obj["title"].stringValue
                    var url   = obj["url"].stringValue
                    //self.cellItems[key.intValue] = "\(title), \(url)"
                    self.myUrls.append(obj["url"].stringValue)
                    self.myItems.append(obj["title"].stringValue)
                }
                println("ロード完了")
                dispatch_async(dispatch_get_main_queue(), {
                    self.qiitaTableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
            }else{
                println(error)
            }
            println("test")
        })
        task.resume()
        return result
    }
    
    /* Cellが選択された際に呼び出されるデリゲートメソッド. */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        qiitaDetailView.qiitaUrl = self.myUrls[indexPath.row]
        //self.qiitaDelegate?.qiitaUrlDelegate(self.myUrls[indexPath.row])
        self.navigationController?.pushViewController(qiitaDetailView, animated: true)
    }

    /* Cellの総数を返すデータソースメソッド. (実装必須)
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myItems.count
    }
    
    /* Cellに値を設定するデータソースメソッド. (実装必須)
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { // 再利用するCellを取得する.
            let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! UITableViewCell // Cellに値を設定する.
            cell.textLabel!.text = "\(myItems[indexPath.row])"
            return cell
    }
}
