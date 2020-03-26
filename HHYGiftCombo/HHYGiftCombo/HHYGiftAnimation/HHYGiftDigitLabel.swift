//
//  HHYGiftDigitLabel.swift
//  HHYGiftCombo
//
//  Created by 华惠友 on 2020/3/16.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

class HHYGiftDigitLabel: UILabel {

    override func drawText(in rect: CGRect) {
        // 1.获取上下文
        let context = UIGraphicsGetCurrentContext()
        
        // 2.给上下文线段设置一个宽度，通过该宽度画出文本
        context?.setLineWidth(5)
        context?.setLineJoin(.round)
        // 描边空心
        context?.setTextDrawingMode(.stroke)
        textColor = UIColor.orange
        super.drawText(in: rect)
        
        // 内部填充
        context?.setTextDrawingMode(.fill)
        textColor = UIColor.white
        super.drawText(in: rect)
    }

    func showDigitAnimation(_ completion: @escaping () -> ()) {
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            }
        }) { (isFinished) in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                self.transform = CGAffineTransform.identity
            }, completion:{ (isFinished) in
                completion()
            })
        }
    }
    
}






