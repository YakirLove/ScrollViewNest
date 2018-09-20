//
//  ViewController.swift
//  ScrollView
//
//  Created by wyj on 2018/9/18.
//  Copyright © 2018年 wyj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton.init(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .red
        button.setTitle("点击", for: .normal)
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(self.jumpToScroll), for: .touchUpInside)
        
    }
    
    @objc func jumpToScroll() {
        
        let controller = ScrollViewController.init()
        let nav: UINavigationController = UINavigationController.init(rootViewController: controller)
        self.present(nav, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

