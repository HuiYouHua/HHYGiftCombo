//
//  HHYGiftContainerView.swift
//  HHYGiftCombo
//
//  Created by 华惠友 on 2020/3/16.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit

private let kChannelCount = 2
private let kChannelViewH : CGFloat = 40
private let kChannelMargin : CGFloat = 10

class HHYGiftContainerView: UIView {

    // MARK: 定义属性
    fileprivate lazy var channelViews: [HHYGiftChannelView] = [HHYGiftChannelView]()
    fileprivate lazy var cacheGiftModels: [HHYGiftModel] = [HHYGiftModel]()
    
    // MARK: 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI
extension HHYGiftContainerView {
    fileprivate func setupUI() {
        // 根据当前的渠道数，创建ChannelView
        let w: CGFloat = frame.width
        let h: CGFloat = kChannelViewH
        let x: CGFloat = 0
        for i in 0..<kChannelCount {
            let y : CGFloat = (h + kChannelMargin) * CGFloat(i)
            
            let channelView = HHYGiftChannelView.loadFromNib()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0.0
            addSubview(channelView)
            channelViews.append(channelView)
            
            channelView.complectionCallBack = { channelView in
                // 1.取出缓冲中的模型
                guard self.cacheGiftModels.count != 0 else {
                    return
                }
                
                let firstGiftModel = self.cacheGiftModels.first!
                self.cacheGiftModels.removeFirst()
                
                // 3.将数组中剩余有和firstGiftModel相同的模型放入到ChanelView缓存中
                for i in (0..<self.cacheGiftModels.count).reversed() {
                    let giftModel = self.cacheGiftModels[i]
                    if giftModel.isEqual(firstGiftModel) {
                        channelView.addOnceToCache()
                        self.cacheGiftModels.remove(at: i)
                    }
                }
                
                // 2.让闲置的channelView执行动画
                channelView.giftModel = firstGiftModel
                

            }
        }
    }
}

extension HHYGiftContainerView {
    func showGiftModel(_ giftModel: HHYGiftModel) {
        // 1.判断显示中的ChannelView和赠送的新礼物的（username、giftName）
        if let channelView = checkUsingChannelView(giftModel)  {
            channelView.addOnceToCache()
            return
        }
        
        // 2.判断有没有闲置的ChannelView
        if let channelView = checkIdleChannelView() {
            channelView.giftModel = giftModel
            return
        }
        
        // 3.将数据放入缓冲
        cacheGiftModels.append(giftModel)
    }
    
    private func checkUsingChannelView(_ giftModel: HHYGiftModel) -> HHYGiftChannelView? {
        for channelView in channelViews {
            if giftModel.isEqual(channelView.giftModel) && channelView.state != .endAnimating {
                return channelView
            }
        }
        return nil
    }
    
    private func checkIdleChannelView() -> HHYGiftChannelView? {
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        return nil
    }
}
