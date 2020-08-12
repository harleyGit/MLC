//
//  HGRichTextView.h
//  HGSWB
//
//  Created by 黄刚 on 2018/12/3.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGRichTextView : UIView

/**
 初始化富文本View

 @param frame 富文本View的frame
 @param text 文本
 @param textFrame 文本frame
 @param attribute 文本属性
 @return 返回富文本View
 */
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text textFrame:(CGRect)textFrame textAttributes:(NSDictionary *)attribute;

@end

NS_ASSUME_NONNULL_END
