//
// Created by 李理 on 2017/4/19.
// Copyright (c) 2017 李理. All rights reserved.
//

import Foundation
//import UIColor_Hex_Swift

public func className<T>(_ type:T.Type) -> String {
    return "\(type)".components(separatedBy: ".").last!
}

extension URL {
    public subscript(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}

@objc extension UIColor {
//    public static func color(hex: String) -> UIColor {
//        return UIColor(hexString: hex)
//    }
}

extension UIImage { // 图片去色,加灰
    public func getGrayImage() -> UIImage?{
        UIGraphicsBeginImageContext(self.size)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil , width: Int(self.size.width), height: Int(self.size.height),bitsPerComponent: 8, bytesPerRow: Int(self.size.width) * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let cgImage = context?.makeImage()
        return UIImage.init(cgImage: cgImage!)
    }
}
