//
//  UIView+Frame.swift
//  SwiftCode
//
//  Created by wyj on 2018/9/6.
//  Copyright © 2018年 wyj. All rights reserved.
//

import UIKit

func COLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor
{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
}

func kDevice_Is_iPhoneX() -> Bool ///< 是否iPhone X
{
    if(ScreenHeight() == 812 || ScreenHeight() == 896)
    {
        return true
    }
    return false
}

func kSafeArea_Top() -> CGFloat///< 状态栏高度
{
    return kDevice_Is_iPhoneX() ? 44 : 20
}

func kSafeArea_Bottom() -> CGFloat///< 底部留空
{
    return kDevice_Is_iPhoneX() ? 34 : 0
}

func kNavigationHeight() -> CGFloat///< 导航栏
{
    return 44
}

func kSafeAreaTopHeight() -> CGFloat///< 导航栏+状态栏
{
    return kSafeArea_Top() + kNavigationHeight()
}

func ScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

func ScreenHeight() -> CGFloat {
    return UIScreen.main.bounds.size.height
}



func kTitleColor51() -> UIColor {
    return COLOR(r: 51, 51, 51, 1)
}

func kTitleColor153() -> UIColor {
    return COLOR(r: 153, 153, 153, 1)
}

func kTitleColor102() -> UIColor {
    return COLOR(r: 102, 102, 102, 1)
}

extension UIView {
    
    func width() -> CGFloat {
        return self.frame.size.width
    }
    
    func height() -> CGFloat {
        return self.frame.size.height
    }
    
    func left() -> CGFloat {
        return self.frame.origin.x
    }
    
    func top() -> CGFloat {
        return self.frame.origin.y
    }
    
    func right() -> CGFloat {
        return self.left()+self.width()
    }
    
    func bottom() -> CGFloat
    {
        return self.top()+self.height()
    }
    
    func removeAllSubView()
    {
        while (self.subviews.count != 0) {
            self.subviews.last?.removeFromSuperview();
        }
    }
}
