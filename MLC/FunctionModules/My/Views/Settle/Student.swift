//
//  Student.swift
//  MLC
//
//  Created by 黄刚 on 2019/12/4.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

import UIKit

//歌曲结构体
struct Music {
    let name: String //歌名
    let singer: String //演唱者
     
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}

//实现 CustomStringConvertible 协议，方便输出调试
extension Music: CustomStringConvertible {
    var description: String {
        return "name：\(name) singer：\(singer)"
    }
}


//歌曲列表数据源
struct MusicListViewModel {
    let data = Observable.just([
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
    ])
}


class ShowCell: UITableViewCell {
    lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        
        return label
    }()
    
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.lightGray
        
        return label
    }()
    
    class func cell(_ tableView: UITableView) -> ShowCell {
        let identifier = NSStringFromClass(self.classForCoder())
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ShowCell
        if cell == nil {
            cell = ShowCell.init(style: .default, reuseIdentifier: identifier)
        }
        
        return cell ?? ShowCell()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        
        self.contentView.addSubview(self.mainTitle)
        self.contentView.addSubview(self.subTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.mainTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
        }
        self.subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self.mainTitle)
            make.top.equalTo(self.mainTitle.snp.bottom).offset(8)
        }
    }
}




class Student: NSObject {
    
    @objc public dynamic var numberID: String?// = "RxSwift 的 KVO"

}
