//
//  PageTabVC.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/13.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

@objc open class PageTabVC:UIViewController {
    @objc public var pageTab:PageTabView = PageTabView()
    @objc public var pageVC:PageVC = PageVC()
    
    @objc public var tabHeight:CGFloat = 44 {
        didSet {
            self.pageTab.snp.updateConstraints { (make) in
                make.height.equalTo(self.tabHeight)
            }
        }
    }
    
    public var disposeBag = DisposeBag()
    
    override open func viewDidLoad() {
        self.view.addSubview(self.pageTab)
        self.pageTab.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(self.tabHeight)
        }
        
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.pageTab.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        self.pageVC.didMove(toParent: self)
        
        self.pageTab.selectedIndexObservable.asObservable().observeOn(MainScheduler.asyncInstance).distinctUntilChanged().bind { [weak self] (index) in
            guard
                let sSelf = self,
                index > -1,
                sSelf.pageVC.viewControllers.count > index
                else {
                    return
            }
            
            sSelf.pageVC.show(at: index)
        }.disposed(by: self.disposeBag)
        
        self.pageVC.selectedIndexObservable.asObservable().observeOn(MainScheduler.asyncInstance).distinctUntilChanged().bind { [weak self] (index) in
            guard
                let sSelf = self,
                index > -1,
                sSelf.pageTab.items.count > index
                else {
                    return
            }
            
            sSelf.pageTab.show(at: index)
        }.disposed(by:self.disposeBag)
    }
    
    @objc public func show(at index:Int) {
        //这里做个延迟处理，解决无限联动问题
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.pageTab.show(at: index)
        }
    }
    
    @objc public func remove(at index:Int) {
        self.pageTab.remove(at: index)
        self.pageVC.remove(at: index)
    }
    
    @objc public func removeAll() {
        self.pageTab.removeAll()
        self.pageVC.removeAll()
    }
    
    @objc public func insert(tab: PageTabItemView, vc: UIViewController, at: Int) {
        self.pageTab.insert(newElement: tab, at: at)
        self.pageVC.insert(newElement: vc, at: at)
    }
    
    @objc public func insert(tabs: [PageTabItemView], vcs: [UIViewController], at: Int) {
        self.pageTab.insert(contentsOf: tabs, at: at)
        self.pageVC.insert(contentsOf: vcs, at: at)
    }
    
    deinit {
        Utils.commonLog("【内存释放】\(String(describing: self)) dealloc")
    }
}
