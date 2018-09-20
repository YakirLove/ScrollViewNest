//
//  HeaderView.swift
//  ScrollView
//
//  Created by wyj on 2018/9/18.
//  Copyright © 2018年 wyj. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        let bgImgView = UIImageView.init(frame: CGRect(x: 0, y: -100, width: ScreenWidth(), height: 260))
        bgImgView.tag = 100
        bgImgView.backgroundColor = .green
        self.addSubview(bgImgView)
        
        
        let headImgView = UIImageView.init(frame: CGRect(x: 15, y: 50, width: 60, height: 60))
        headImgView.backgroundColor = .red
        self.addSubview(headImgView)
        
        let titleLabel = UILabel.init(frame: CGRect(x: headImgView.right()+8, y: headImgView.top()+20, width: 200, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.text = "ScrollView嵌套ScrollView"
        titleLabel.textColor = .black
        self.addSubview(titleLabel)
        
    }
    
    func setView(alpha: CGFloat) {
        let viewArray = self.subviews as NSArray
        for (_, value) in viewArray.enumerated() {
            let view = value as! UIView
            guard view.tag >= 100 else {
                view.alpha = alpha
                continue
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }

}
