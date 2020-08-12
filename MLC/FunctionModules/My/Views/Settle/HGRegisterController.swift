//
//  HGRegisterController.swift
//  MLC
//
//  Created by 黄刚 on 2019/11/29.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

import UIKit

class HGRegisterController: HGBaseController {
    
    let disposeBag = DisposeBag()
    
    private lazy var userNameInput: UITextField = {
        let text = UITextField()
        text.placeholder = "用户名输入"
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 2
        text.layer.masksToBounds = true
        
        return text
    }()
    
    private lazy var reminderUserNameInput: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.red
        label.text = "用户名至少3-10个字符组成"
        
        return label
    }()
    
    private lazy var registerBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.cyan
        button.setTitle("注册", for: .normal)
        
        return button
    }()
    
    private lazy var contentView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    let musicVM = MusicListViewModel()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTableView()
        self.layoutOfTableView()
        self.rxSwiftBindTableView()
        
    
//        self.inputManager()
//        self.createObserver()
//        self.variableTest()
    }
    
    func emptySequence() {
        let emtyOb = Observable<Int>.empty()
        _ = emtyOb.subscribe(onNext: { (number) in
            print("订阅:",number)
        }, onError: { (error) in
            print("error:",error)
        }, onCompleted: {
            print("完成回调")
        }) {
            print("释放回调")
        }
    }
    
    func variableTest() {
        let varible = BehaviorRelay<String>(value: "OnePice：最强 Z")
        varible.asObservable().subscribe { (event) in
            print("Subscription: 1, event: \(event)")
        }.disposed(by: disposeBag)
        
        varible.accept("路飞")
        varible.accept("索大")
        
        
        
        varible.asObservable().subscribe { (event) in
            print("----> Subscription: 2, event: \(event)")
        }.disposed(by: disposeBag)
        
        varible.accept("鸣人：风遁螺旋手里⚔")
        varible.accept("二柱子：天照")
    }
    
    
    func createObserver() {
        let observer = Observable<Any>.create { (observer) -> Disposable in
            observer.onNext("Hello! 我来了！！！")
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        observer.subscribe(onNext: { (text) in
            print("---> \(text)")
        }, onError: nil, onCompleted: {
            print("Completed 完成！！")
            }, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func inputManager() {
        
        let inputValid = self.userNameInput.rx.text.orEmpty.map { (text) -> Bool in
            let length = text.count
            return length >= 3 && length <= 10
        }.share(replay: 1)
        
        inputValid.bind(to: self.reminderUserNameInput.rx.isHidden).disposed(by: disposeBag)
        
        inputValid.bind(to: self.registerBtn.rx.isEnabled).disposed(by: disposeBag)
        
        self.registerBtn.rx.tap.subscribe { [weak self] (next) in
            self?.registerBtn.backgroundColor = UIColor.red
            print("\("注册了")")
            
        }.disposed(by: disposeBag)
         
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        self.view.addSubview(self.userNameInput)
        self.view.addSubview(self.reminderUserNameInput)
        self.view.addSubview(self.registerBtn)
    }
    
    override func layoutSubViews() {
        super.layoutSubViews()
        
        return
        self.userNameInput.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalToSuperview().offset(100)
        }
        
        self.reminderUserNameInput.snp.makeConstraints { (make) in
            make.left.equalTo(self.userNameInput)
            make.top.equalTo(self.userNameInput.snp.bottom)
            make.height.equalTo(30)
        }
        
        self.registerBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(54)
            make.top.equalTo(self.reminderUserNameInput.snp.bottom).offset(6)
        }
    }

}



extension HGRegisterController: UITableViewDelegate {
    
    func rxSwiftBindTableView() {
        
        self.contentView.register(ShowCell.self, forCellReuseIdentifier: "ShowCell")
        //数据绑定
        self.musicVM.data.bind(to: self.contentView.rx.items(cellIdentifier: "ShowCell", cellType: ShowCell.self)){(row, model, cell) in
            cell.mainTitle.text = model.singer
            cell.subTitle.text = model.name
        }.disposed(by: disposeBag)
        
        //点击cell绑定
        self.contentView.rx.itemSelected.bind { (indexPath) in
            print("--->>: \(indexPath)")
        }.disposed(by: disposeBag)
        
        //代理绑定
        self.contentView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func addTableView() {
        self.view.addSubview(self.contentView)
    }
    
    func layoutOfTableView() {
        self.contentView.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalToSuperview()
            
        }
    }
}
