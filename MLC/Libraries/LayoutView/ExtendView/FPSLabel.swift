//
//  FPSLabel.swift
//  AppStructure
//
//  Created by brave on 2020/3/20.
//  Copyright © 2020 brave. All rights reserved.
//

import UIKit

class FPSLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var link: CADisplayLink?
    private var lastTime: TimeInterval = 0.0
    private var count: Int = 0
    
    
    private func initData() {
        link = CADisplayLink.init(target: self, selector: #selector(FPSLabel.didTick(link:)))
        link?.add(to: RunLoop.current, forMode: .common)
    }
    
    @objc private func didTick(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
        }
        count += 1
        let delta = link.timestamp - lastTime
        if delta < 1 {
            return
        }
        lastTime = link.timestamp
        let fps = Double(count) / delta
        count = 0
        text = String(format: "%02.0ffps", round(fps))
    }
    
    static func showFps() {
        guard let window = UIApplication.shared.keyWindow else { return }
        let height = UIScreen.main.bounds.size.height
        let width = UIScreen.main.bounds.size.width
        let label = FPSLabel.init(frame: CGRect(x: width - 120, y: height - 100, width: 100, height: 30))
        label.textColor = UIColor.green
        window.addSubview(label)
    }
}
