//
//  UIView+Ext.swift
//  CYZS
//
//  Created by 李理 on 2017/9/4.
//  Copyright © 2017年 Yourdream. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

extension UIView {
    public func tapGesture() -> Observable<UITapGestureRecognizer> {
        let result = self.rx.tapGesture{ (gestureRecognizer, delegate) in
            delegate.simultaneousRecognitionPolicy = .never
        }.when(UIGestureRecognizer.State.recognized)
        return result
    }
}
