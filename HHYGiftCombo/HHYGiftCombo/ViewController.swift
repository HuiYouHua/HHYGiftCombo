//
//  ViewController.swift
//  HHYGiftCombo
//
//  Created by 华惠友 on 2020/3/16.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var digitLabel: HHYGiftDigitLabel!
    
    fileprivate lazy var giftContainerView: HHYGiftContainerView = HHYGiftContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giftContainerView.frame = CGRect(x: 0, y: 100, width: 250, height: 90)
        giftContainerView.backgroundColor = UIColor.lightGray
        view.addSubview(giftContainerView)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        digitLabel.showDigitAnimation {
            print("执行完动画")
        }
    }

    @IBAction func gift1(_ sender: UIButton) {
        let gift1 = HHYGiftModel(senderName: "Lucy", senderURL: "icon1", giftName: "啤酒", giftURL: "prop_f")
        giftContainerView.showGiftModel(gift1)
    }
    
    @IBAction func gift2(_ sender: UIButton) {
        let gift2 = HHYGiftModel(senderName: "Barray", senderURL: "icon2", giftName: "跑车", giftURL: "prop_b")
        giftContainerView.showGiftModel(gift2)
    }
    @IBAction func gift3(_ sender: UIButton) {
        let gift3 = HHYGiftModel(senderName: "Bob", senderURL: "icon3", giftName: "蘑菇", giftURL: "prop_g")
        giftContainerView.showGiftModel(gift3)
    }
}

