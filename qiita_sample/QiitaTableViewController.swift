//
//  QiitaTableViewController.swift
//  qiita_sample
//
//  Created by 小林芳樹 on 2015/08/21.
//  Copyright (c) 2015年 小林芳樹. All rights reserved.
//

import UIKit
import SwiftyJSON


@objc protocol QiitaTableViewDatasource:NSObjectProtocol {
    func tableViewCount(tableView: QiitaTableView, numberOfRowsInSection section: Int) -> Int
    func tableViewSetData(tableView: QiitaTableView, cellForRowAtIndex: Int) -> UIButton
}


class QiitaTableView: UIScrollView, UIScrollViewDelegate {
    
    var qiitaTableViewDatasource: QiitaTableViewDatasource?
    
    private var cellCount = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadData() {
        var cellCount = 0
        //self.qiitaTableViewDelegate?.tableViewSelect()
        if (qiitaTableViewDatasource?.respondsToSelector("tableViewCount:numberOfRowsInSection:") == true) {
          cellCount = (qiitaTableViewDatasource?.tableViewCount(self, numberOfRowsInSection: 0))!
        }
        for(var i=0; i < cellCount; i++) {
            let btn: UIButton = (self.qiitaTableViewDatasource?.tableViewSetData(self, cellForRowAtIndex: i))!
            print(btn.frame)
            self.addSubview(btn)
        }
        self.setNeedsDisplay()
    }
}
