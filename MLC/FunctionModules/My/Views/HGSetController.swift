//
//  HGSetController.swift
//  HGSWB
//
//  Created by 黄刚 on 2019/8/22.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

import UIKit

class HGSetController: HGBaseController {

    let disposeBag = DisposeBag()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton.init(type: .custom)
        clickBtn.backgroundColor = UIColor.cyan
        clickBtn.setTitle("点击", for: .normal)
        clickBtn.rx.tap.subscribe(onNext: {
            print("欢迎被访问·········")
            self.testRxZip()
            }).disposed(by: disposeBag)
        
        return clickBtn
    }()
    
    lazy var inputText: UITextField = {
        let inputText = UITextField(frame: CGRect.zero)
        inputText.backgroundColor = UIColor.lightGray
        inputText.placeholder = "请输入"
        inputText.rx.text.bind(to: showLab.rx.text)
            .disposed(by: disposeBag)
        
        return inputText
    }()
    
    lazy var showLab: UILabel = {
        let showLab = UILabel(frame: CGRect.zero)
        showLab.backgroundColor = UIColor.groupTableViewBackground
        
        return showLab
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "设置"
        
        self.addSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    public func testRxZip() {
        
        let oneOb = Observable<Int>.create { observer -> Disposable in
            observer.on(.next(20))
            observer.on(.completed)
            return Disposables.create()
        }
        let twoOb = Observable<Int>.create { observer -> Disposable in
            observer.on(.next(80))
            observer.on(.completed)
            return Disposables.create()
        }
        
        Observable.zip(oneOb, twoOb).subscribe(onNext: {(one, two) in
            print("获取信息成功: \(one)")
            print("获取订单成功: \(two) 条")

            }).disposed(by: DisposeBag())
    }
    
    
    
    override func addSubViews() {
        self.view.addSubview(self.clickBtn)
        self.view.addSubview(self.inputText)
        self.view.addSubview(self.showLab)
    }
    
    override func layoutSubViews() {
        super.layoutSubViews()
        
        self.clickBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(34)
            make.width.equalTo(64)
        }
        
        self.inputText.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }
        
        self.showLab.snp.makeConstraints { (make) in
            make.top.equalTo(inputText.snp.bottom).offset(20)
            make.left.right.equalTo(inputText)
            make.height.equalTo(30)
        }
    }
    
    

}
