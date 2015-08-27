//
//  QiitaDetailViewController.swift
//  qiita_sample
//
//  Created by 小林芳樹 on 2015/08/22.
//  Copyright (c) 2015年 小林芳樹. All rights reserved.
//

import UIKit

class QiitaDetailViewController: UIViewController,UIWebViewDelegate,QiitaDelegate{
    var qiitaUrl: String = ""
    let tableView = QiitaTableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let webView = UIWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: self.qiitaUrl)!))
        
        webView.delegate = self
        self.tableView.qiitaDelegate = self
    }

    //ページが読み終わったときに呼ばれる関数
    func webViewDidFinishLoad(webView: UIWebView) {
        println(self.qiitaUrl)
    }
    //ページを読み始めた時に呼ばれる関数
    func webViewDidStartLoad(webView: UIWebView) {
        println("ページ読み込み開始しました！")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func qiitaUrlDelegate(qiitaUrl: String) {
        println("call delegate")
        self.qiitaUrl = qiitaUrl
        
    }
   
    
}
