//
//  ScrollViewController.swift
//  ScrollView
//
//  Created by wyj on 2018/9/18.
//  Copyright © 2018年 wyj. All rights reserved.
//


/*
 1.mainScrollView 嵌套 subScrollView 的样式问题冲突在于：我们希望 mainScrollView 优先滑动，等到 mainScrollView 到达响应的位置之后 subScrollView 才开始滑动， 但是因为 subScrollView 在 mainScrollView 上层会更优先响应手势。
 
 2.这里有两个变量：一个是优先滚动到相应位置、一个是优先响应手势。也就是说，如果我们改变其中的变量就能解决我们的问题了。
 
 3.找答案前先找问题，所以我们根据上面的思路可以提出两个问题：我们如何让 mainScrollView 先于 subScrollView 发生滚动？或者我们如何让 mainScrollView 优先 subScrollView 响应手势？
 
 4.由此我们可以得出两种解决方式：
    a.监听 subScrollView 的手势，然后优先改变 mainScrollView 的滚动位置，等到达临界之后再来修改 subScrollView 的滚动位置 --》 利用 scrollViewDidScroll 方法，收到手势滑动的回调后修改两个 ScrollView 的位置（本文采用此方法）
    b.让 mainScrollView 优先响应手势监听，等 mainScrollView 到达位置之后，再让 subScrollView 响应手势 --》 这里可以利用 scrollEnable 的属性，设置 subScrollView 无法滚动，就能让 mainScrollView 优先响应，等 mainScrollView 滚动到相应位置后 就设置 subScrollView 可以滚动，让 subScrollView 优先响应
 
 5.除了看 demo 的代码之外，还可以看一下我这里使用的解决问题的思考方法：
    明确问题 —— 确定影响变量 —— 思考变量关系 —— 根据变量关系提出问题 —— 根据问题找到答案
 
 */


import UIKit

class ScrollViewController: UIViewController {

    var mainScrollView: UIScrollView
    var subScrollView: UIScrollView
    var headerView: HeaderView
    var tabbarView: TabbarView
    var titleLabel: UILabel
    var titleView: UIView
    let titleHeight: CGFloat = 30.0
    let headerHeight: CGFloat = 160.0
    
    init() {
        
        mainScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth(), height: ScreenHeight()))
        
        headerView = HeaderView.init(frame: CGRect(x: 0, y: 0, width: mainScrollView.width(), height: headerHeight))
        
        tabbarView = TabbarView.init(withTitle: ["最新","最热","最好"], frame: CGRect(x: 10, y: headerView.height(), width: mainScrollView.width(), height: titleHeight))
        
        subScrollView = UIScrollView.init(frame: CGRect(x: 0, y: tabbarView.bottom(), width: ScreenWidth(), height: mainScrollView.height()-kSafeAreaTopHeight()-tabbarView.height()))
        
        titleLabel = UILabel.init(frame: CGRect(x: 0, y: kSafeArea_Top(), width: ScreenWidth(), height: 40))
        
        titleView = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth(), height: kSafeAreaTopHeight()))
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        mainScrollView.backgroundColor = .white
        mainScrollView.delegate = self;
        self.view.addSubview(mainScrollView)
        mainScrollView.contentSize = CGSize(width: ScreenWidth(), height: mainScrollView.height()+160)
        
        titleView.backgroundColor = .white
        self.view.addSubview(titleView)
        
        titleView.alpha = 0
        titleLabel.textAlignment = .center
        titleLabel.text = "ScrollView嵌套ScrollView"
        titleView.addSubview(titleLabel)
        
        mainScrollView.addSubview(headerView)
        
        tabbarView.delegate = self
        mainScrollView.addSubview(tabbarView)
        
        subScrollView.backgroundColor = .gray
        subScrollView.isPagingEnabled = true
        subScrollView.delegate = self;
        mainScrollView.addSubview(subScrollView)
        subScrollView.contentSize = CGSize(width: ScreenWidth()*3, height: 1)
        
        for i in 0..<3
        {
            let x = CGFloat(i)
            let tableView = UITableView.init(frame: CGRect(x: x*self.subScrollView.width(), y: 0, width: self.subScrollView.width(), height: self.subScrollView.height()))
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tag = i
            self.subScrollView.addSubview(tableView)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension ScrollViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == self.mainScrollView) {
            //mainScrollview 响应，就按照位置滚动，但是不超过限制位置
            if (self.mainScrollView.contentOffset.y >= self.tabbarView.top()-kSafeAreaTopHeight()) {
                self.mainScrollView.setContentOffset(CGPoint(x: 0, y: (self.tabbarView.top()-kSafeAreaTopHeight())), animated: false)
            }
            
            let line = self.tabbarView.top()-kSafeAreaTopHeight()
            let alpha = self.mainScrollView.contentOffset.y/line

            self.titleView.alpha = alpha
            self.headerView.setView(alpha: 1-alpha)
            
        }
        else if(scrollView == self.subScrollView) {
        }
        else {
            //如果mainScrollview还没有滚动到极限位置，优先滚动
            let isMainScroll = self.mainScrollView.contentOffset.y < (self.tabbarView.top()-kSafeAreaTopHeight())

            let offsetY = scrollView.contentOffset.y + self.mainScrollView.contentOffset.y;

            // mainScrollview 优先滚动
            if (isMainScroll) {
                //限制下来 只能下拉到200的位置
                if(self.mainScrollView.contentOffset.y < CGFloat(-200))
                {
                    self.mainScrollView.setContentOffset(CGPoint(x: 0, y: -200), animated: false)
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                    self.headerView.setView(alpha: 0)
                }
                else
                {
                    self.mainScrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)

                    let line = self.tabbarView.top()-kSafeAreaTopHeight()
                    let alpha = self.mainScrollView.contentOffset.y/line
                    self.titleView.alpha = alpha
                    self.headerView.setView(alpha: 1-alpha)
                }

            } else { // subScrollView开始滚动——其实是subScrollView里面的tableView
                // 如果tableView 的y值小于0 说明是在下拉 需要将 mainScrollView 也下拉
                if (scrollView.contentOffset.y <= 0) {
                    if self.mainScrollView.contentOffset.y >= (self.tabbarView.top()-kSafeAreaTopHeight()) {
                        self.mainScrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
                    }
                }
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 如果是响应在 mainScrollView
        if(scrollView == self.mainScrollView) {
            // 如果 mainScrollView 可能滑动超过限制的位置 则将它设置到限制位置
            if (self.mainScrollView.contentOffset.y >= self.tabbarView.top()-kSafeAreaTopHeight()) {
                self.mainScrollView.setContentOffset(CGPoint(x: 0, y: (self.tabbarView.top()-kSafeAreaTopHeight())), animated: false)
            }
        }
        else { // 响应在tableView上
            let offsetY = self.mainScrollView.contentOffset.y
            if(offsetY < 0.0)//如果手势结束时，y为负，则动态复原回原位
            {
                self.mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == self.subScrollView)
        {
            let page = scrollView.contentOffset.x/scrollView.width()
            self.tabbarView.select(withTag: Int(page))
        }
    }
}

extension ScrollViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = "\(tableView.tag)"+"\(indexPath.row)"
        return cell
    }
    
}

extension ScrollViewController: TabbarViewDelegate {
    func select(withTag tag: Int) {
        self.subScrollView.scrollRectToVisible(CGRect(x: ScreenWidth()*CGFloat(tag), y: 0, width: self.subScrollView.width(), height: self.subScrollView.height()), animated: true)
    }
    
    
}
