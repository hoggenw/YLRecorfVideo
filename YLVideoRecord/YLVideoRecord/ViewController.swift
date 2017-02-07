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
        let button = UIButton()
        button.frame = CGRect(x: 170, y: 200, width: 60, height: 50)
        button.setTitle("录制", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(turnToRecordController), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func turnToRecordController() {
        self.navigationController?.pushViewController(YLRecordVideoViewController(), animated: true)
    }


}

