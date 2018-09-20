//
//  TabbarView.swift
//  ScrollView
//
//  Created by wyj on 2018/9/18.
//  Copyright © 2018年 wyj. All rights reserved.
//

import UIKit

class TabbarView: UIView {
    
    var buttonArray: Array<UIButton>
    var delegate: TabbarViewDelegate?
    var lineView: UIView?
    
    init(withTitle titleArray: [String] ,frame: CGRect) {
        self.buttonArray = Array.init()
        super.init(frame: frame)
        
        for i in 0..<titleArray.count {
            let title = titleArray[i]
            let titleButton = UIButton.init(frame: CGRect(x: 40*i, y: 0, width: 40, height: 30))
            titleButton.tag = i
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            titleButton.setTitle(title, for: .normal)
            titleButton.setTitleColor(kTitleColor153(), for: .normal)
            titleButton.setTitleColor(kTitleColor51(), for: .selected)
            self.addSubview(titleButton)
            titleButton.addTarget(self, action: #selector(selectButton(sender:)), for: .touchUpInside)
            buttonArray.append(titleButton)
        }
        
        lineView = UIView.init(frame: CGRect(x: 5, y: 29, width: 30, height: 1))
        lineView?.backgroundColor = .green
        self.addSubview(lineView!)
        
        let titleButton: UIButton = buttonArray[0]
        self.selectButton(sender: titleButton)
    }
    
    @objc func selectButton(sender: UIButton) {
        for(_, value) in buttonArray.enumerated() {
            let button = value
            if(button == sender)
            {
                button.isSelected = true
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            }
            else
            {
                button.isSelected = false
                button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.lineView?.frame = CGRect(x: CGFloat(5+sender.tag*40), y: (self.lineView?.top())!, width: (self.lineView?.width())!, height: (self.lineView?.height())!)
        }
        
        self.delegate?.select(withTag: sender.tag)
    }
    
    func select(withTag: Int) {
        for(index, value) in buttonArray.enumerated() {
            let button = value
            if(index == withTag)
            {
                button.isSelected = true
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            }
            else
            {
                button.isSelected = false
                button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.lineView?.frame = CGRect(x: CGFloat(5+withTag*40), y: (self.lineView?.top())!, width: (self.lineView?.width())!, height: (self.lineView?.height())!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol TabbarViewDelegate {
    func select(withTag tag: Int)
}
