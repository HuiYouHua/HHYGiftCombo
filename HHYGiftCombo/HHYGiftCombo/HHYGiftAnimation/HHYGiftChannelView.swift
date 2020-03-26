//
//  HHYGiftChannelView.swift
//  HHYGiftCombo
//
//  Created by 华惠友 on 2020/3/16.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

enum HHYGiftChannelState {
    case idle   // 空闲（礼物视图处于等待区）
    case animating  // 正在动画（礼物视图刚出来）
    case willEnd    // 即将结束（礼物视图悬停等待移出）
    case endAnimating   // 正在结束动画（移出礼物视图）
}

class HHYGiftChannelView: UIView {
    // MARK: 控件属性
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var giftDescLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var digitLabel: HHYGiftDigitLabel!

    // 当前缓冲区待消费的礼物数
    fileprivate var cacheNumber: Int = 0
    // 当前的连击数
    fileprivate var currentNumber: Int = 0
    var state: HHYGiftChannelState = .idle
    
    var complectionCallBack: ((HHYGiftChannelView) -> Void)?
    
    var giftModel : HHYGiftModel? {
        didSet {
            // 1.模型校验
            guard let giftModel = giftModel else {
                return
            }
            
            // 2.给控件赋值
            iconImageView.image = UIImage(named: giftModel.senderURL)
            senderLabel.text = giftModel.senderName
            giftDescLabel.text = "送出礼物：【\(giftModel.giftName)】"
            giftImageView.image = UIImage(named: giftModel.giftURL)
            
            // 3.将channelView显示出
            state = .animating
            performAnimation()
        }
    }
}

// MARK: - 设置UI界面
extension HHYGiftChannelView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.green.cgColor
    }
}

// MARK: - 对外提供的函数
extension HHYGiftChannelView {
    func addOnceToCache() {
        if state == .willEnd {
            performDigitAnimation()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        } else {
            cacheNumber += 1
        }
    }
    
    class func loadFromNib() -> HHYGiftChannelView {
        return Bundle.main.loadNibNamed("HHYGiftChannelView", owner: nil, options: nil)?.first as! HHYGiftChannelView
    }
}

// MARK: - 执行动画
extension HHYGiftChannelView {
    fileprivate func performAnimation() {
        digitLabel.alpha = 1
        digitLabel.text = "x1"
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.frame.origin.x = 0
        }) { (isFinished) in
            self.performDigitAnimation()
        }
    }
    
    fileprivate func performDigitAnimation() {
        currentNumber += 1
        digitLabel.text = "x\(currentNumber)"
        digitLabel.showDigitAnimation {
            if self.cacheNumber > 0 {
                self.cacheNumber -= 1
                self.performDigitAnimation()
            } else {
                self.state = .willEnd
                self.perform(#selector(self.performEndAnimation), with: nil, afterDelay: 3.0)
            }
        }
    }
    
    @objc fileprivate func performEndAnimation() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)

        state = .endAnimating
        
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.x  = UIScreen.main.bounds.width
            self.alpha = 0
        }) { (isFinished) in
            self.cacheNumber = 0
            self.currentNumber = 0
            self.giftModel = nil
            self.frame.origin.x = -self.frame.width
            self.state = .idle
            self.digitLabel.alpha = 0.0

            if let complectionCallBack = self.complectionCallBack {
                complectionCallBack(self)
            }
        }
    }
}
