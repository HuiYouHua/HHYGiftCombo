//
//  HYGiftModel.swift
//  GiftAnim
//
//  Created by apple on 16/11/20.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit

class HHYGiftModel: NSObject {
    var senderName : String = ""
    var senderURL : String = ""
    var giftName : String = ""
    var giftURL : String = ""
    
    init(senderName : String, senderURL : String, giftName : String, giftURL : String) {
        self.senderName = senderName
        self.senderURL = senderURL
        self.giftName = giftName
        self.giftURL = giftURL
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? HHYGiftModel else {
            return false
        }
        
        guard object.giftName == giftName && object.senderName == senderName else {
            return false
        }
        
        return true
    }
}
