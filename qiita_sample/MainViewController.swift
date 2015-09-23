//
//  ViewController.swift
//  qiita_sample
//
//  Created by 小林芳樹 on 2015/08/21.
//  Copyright (c) 2015年 小林芳樹. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainViewController: UIViewController, QiitaTableViewDatasource {

    var qiitaDetailView: QiitaDetailViewController?
    var qiitaTableView: QiitaTableView?
    private let qiitaUrl = "https://qiita.com/api/v2/items"
    
    private var qiitaItems:[Dictionary<String, String>] = []
    //private var myUrls:[String]=[]
   
    private var barHeight: CGFloat = 0.0
    private var displayWidth: CGFloat = 0.0
    private var displayHeight: CGFloat = 0.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.qiitaDetailView = QiitaDetailViewController()
        self.qiitaTableView = QiitaTableView()
        
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        self.qiitaTableView?.frame = CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight - barHeight)
        self.qiitaTableView?.backgroundColor = UIColor.whiteColor()
        self.qiitaTableView?.qiitaTableViewDatasource = self
    
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(qiitaTableView!)
        
        
        //QiitaAPIを実行
        requestQiita(self.qiitaUrl)
        
    }
    
    func showDetail(sender: AnyObject) {
        self.qiitaDetailView!.qiitaUrl = self.qiitaItems[sender.tag]["url"]!
        self.navigationController?.pushViewController(self.qiitaDetailView!, animated: true)
    }

   
    private func requestQiita(url: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
            if (error == nil) {
                let json = SwiftyJSON.JSON(data: data!)
                for (_, obj) in json {
                    var data = ["title":"", "url": ""]
                    data.updateValue(obj["title"].stringValue, forKey:  "title")
                    data.updateValue(obj["url"].stringValue, forKey:  "url")
                    data["url"]   = obj["url"].stringValue
                    self.qiitaItems.append(data)
                    
                    print(obj["title"])
                }
                print("ロード完了")
                dispatch_async(dispatch_get_main_queue(), {
                    //self.qiitaTableView?.contentSize = CGSize(width: self.displayWidth, height: self.displayHeight - self.barHeight)
                    self.qiitaTableView?.reloadData()
                    self.qiitaTableView?.setNeedsDisplay()
                })
            }else{
                print(error)
            }
        })
        task.resume()
    }
    
    func tableViewSetData(tableview: QiitaTableView, cellForRowAtIndex: Int) -> UIButton {
        let button = UIButton()
        let y=45 * cellForRowAtIndex
        
        button.frame = CGRectMake(CGFloat(0), CGFloat(y), CGFloat(self.view.frame.width), CGFloat(60))
        button.backgroundColor = UIColor.redColor()
        button.setTitle(self.qiitaItems[cellForRowAtIndex]["title"], forState: UIControlState.Normal)
        button.addTarget(self, action: "showDetail:", forControlEvents: .TouchUpInside)
        button.tag = cellForRowAtIndex
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        return button
    }
    
    func tableViewCount(tableview: QiitaTableView, numberOfRowsInSection section: Int) -> Int {
        return self.qiitaItems.count
    }


}

