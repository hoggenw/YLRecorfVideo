//
//  ViewController.swift
//  YLVideoRecord
//
//  Created by 王留根 on 17/2/3.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        initUI()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI() {
        let recordView =  YLRecordControlView(frame: CGRect(x: 0, y: self.view.bounds.size.height - 100, width: self.view.bounds.size.width, height: 100))
        self.view.addSubview(recordView)
        
    }


}

