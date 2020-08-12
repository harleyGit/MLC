//
//  FeedView+SYD.swift
//  LeoCommon
//
//  Created by 李理 on 2017/9/12.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation
import RxSwift

extension FeedView {
    func addRefreshHeader() {
        self.addRefreshHeader(SYDRefreshHeader.self)
    }
    
    func addRefreshFooter() {
        self.addRefreshFooter(SYDRefreshFooter.self, callback: { footer in
            guard let footer = footer as? SYDRefreshFooter else {
                return
            }
            footer.setTitle("", for: .idle)
            footer.setTitle("加载更多~", for: .refreshing)
            footer.setTitle("你碰到我的底线啦~", for: .noMoreData)
        })
    }
}

@objc class FeedViewEmptyCellViewModel:FeedViewCellViewModel {
    var imageName:String?
    var text:String?
    var linkTitle:String?
    var link:String?
    var contentOffsetY:CGFloat = -64
    var size:CGSize?
    var showImage:Bool = true
    var backgroundColor:UIColor?
    var netExceptionRetryAction:(() -> ())? = nil
    
    override func cellClass(_ context:Dictionary<String, Any>?) -> FeedViewCell.Type {
        return FeedViewEmptyCell.self
    }
}

@objc class FeedViewEmptyCell:FeedViewCell {
    var emptyView:YFFeedEmptyView!
    
    override func set() {
        guard let vm = self.viewModel as? FeedViewEmptyCellViewModel else { return }
        if vm.backgroundColor != nil {
            self.emptyView.backgroundColor = vm.backgroundColor
        }
        self.emptyView.text = vm.text
        self.emptyView.imageName = vm.imageName
        self.emptyView.linkTitle = vm.linkTitle
        self.emptyView.link = vm.link
        self.emptyView.showImage = vm.showImage
        self.emptyView.contentOffsetY = vm.contentOffsetY
        if let action = vm.netExceptionRetryAction {
            self.emptyView.netExceptionRetryAction = action
        }
//        else {
//            self.emptyView.netExceptionRetryAction = { [weak self] in
//                guard let sSelf = self else { return }
//                sSelf.parentFeedView?.refresh()
//            }
//        }
    }
    
    override func bind() {}
    
    override func layout() {
        self.emptyView = YFFeedEmptyView.init(imageName: nil, text: nil)
        self.contentView.addSubview(self.emptyView)
        self.emptyView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    override class func sizeThatFits(_ viewModel:FeedViewCellViewModelProtocol?, size: CGSize = .zero) -> CGSize {
        guard
            let vm = viewModel as? FeedViewEmptyCellViewModel,
            let sz = vm.size
        else {
            return size
        }
        
        return sz
    }
}

@objc class YFFeedEmptyView:UIView {
    @objc var imageView:UIImageView!
    @objc var textLabel:UILabel!
    @objc var linkButton = UIButton.init(type: .custom)
    @nonobjc var disposeBag = DisposeBag()
    
    @objc var contentOffsetY:CGFloat = -64 {
        didSet {
            self.setupViews()
        }
    }
    
    @objc var text:String? {
        didSet {
            self.setupViews()
        }
    }
    
    @objc var imageName:String? {
        didSet {
            self.setupViews()
        }
    }
    
    @objc var showImage:Bool = true {
        didSet {
            self.setupViews()
        }
    }
    
    @objc var linkTitle:String? {
        didSet {
            self.setupViews()
            self.updateLinkButton()
        }
    }
    
    @objc var link:String? {
        didSet {
            self.setupViews()
            self.updateLinkButton()
        }
    }
    
    @objc var netExceptionRetryAction:() -> () = {}
    
    fileprivate func updateLinkButton() {
    }
    
    private func netCheck() {
//        SYDGlobalnstance.share().networkStatusSignal.asObservable().bind { [unowned self] (status) in
//            self.setupViews()
//            }.disposed(by: self.disposeBag)
//
//        self.tapGesture().bind {[unowned self] (tap) in
//            self.netExceptionRetryAction()
//            }.disposed(by: self.disposeBag)
    }
    
    private func setupViews() {
        self.imageView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(contentOffsetY)
        }
        self.textLabel.snp.remakeConstraints { (make) in
            if self.showImage {
                make.top.equalTo(self.imageView.snp.bottom).offset(20)
            } else {
                make.centerY.equalTo(self).offset(contentOffsetY)
            }
            make.centerX.equalTo(self)
        }
//        if SYDGlobalnstance.share().networkStatusSignal.value == .none {
//            if self.showImage {
//                self.imageView.image = UIImage.init(named: "syd_defaultgraph_nonetwork")
//            } else {
//                self.imageView.image = nil
//            }
//            self.textLabel.attributedText = "网络连接异常，请下拉刷新".string(font: UIFont.f14(), color:SYD_COLOR_CCCCCC)
//
//        } else {
            if self.showImage {
                self.imageView.image = UIImage.init(named: self.imageName ?? "")
            } else {
                self.imageView.image = nil
            }
//            self.textLabel.attributedText = self.text?.string(font: UIFont.f14(), color:SYD_COLOR_CCCCCC)
//        }
        self.textLabel.text = self.text
        self.textLabel.textAlignment = .center
    }
    
    func initSubviews() {
        self.backgroundColor = UIColor(hex: 0xF7F7F7)
        self.imageView = UIImageView()
        self.addSubview(self.imageView)
        
        self.textLabel = UILabel()
        self.textLabel.font = UIFont.systemFont(ofSize: 14)
        self.textLabel.numberOfLines = 0
        self.textLabel.textColor = UIColor(hex: 0xCCCCCC)
        self.addSubview(textLabel)
        
        linkButton.isHidden = true
        linkButton.layer.cornerRadius = 15
//        linkButton.layer.borderColor = UIColor.color_9547FD().cgColor
        linkButton.layer.borderWidth = Utils.line(value: 1)
        self.addSubview(linkButton)
        linkButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.textLabel.snp.bottom).offset(16)
            make.centerX.equalTo(self)
            make.height.equalTo(30)
        }
        
        linkButton.tapGesture().bind { (tap) in
            
        }.disposed(by: self.disposeBag)
        
        self.setupViews()
    }
    
    @objc init(imageName:String?, text:String?) {
        super.init(frame: .zero)
        
        self.initSubviews()
        
        self.imageName = imageName
        
        self.text = text
        
        self.netCheck()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

