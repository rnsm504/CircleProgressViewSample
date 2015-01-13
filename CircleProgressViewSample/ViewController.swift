//
//  ViewController.swift
//  CircleProgressViewSample
//
//  Created by Kuze Masanori on 2015/01/14.
//  Copyright (c) 2015年 Kuze Masanori. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pcv: CircleProgressView!
    @IBOutlet weak var dcv: CircleProgressView!
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pcv.lineWidth = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func btnClick(sender: AnyObject) {
        pcv.setProgress(pcv.progress+0.3, animated: true)
        dcv.setProgress(dcv.progress+0.3, animated: true)

    }
}

