//
//  HGRichTextView.m
//  HGSWB
//
//  Created by 黄刚 on 2018/12/3.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import "HGRichTextView.h"

@interface HGRichTextView()

@property(nonatomic, retain)NSDictionary *attributes;
@property(nonatomic, copy)NSString *text;
@property(nonatomic, assign)CGRect textFrame;

@end

@implementation HGRichTextView

- (void)setAttributes:(NSDictionary *)attributes {
    _attributes = attributes;
}

- (void)setText:(NSString *)text {
    _text = text;
}


- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text textFrame:(CGRect)textFrame textAttributes:(NSDictionary *)attribute {
    self = [super initWithFrame:frame];
    if (self) {
        self.attributes = attribute;
        self.text = text;
        self.textFrame = textFrame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.text.length > 0) {
        [self.text drawInRect:self.textFrame withAttributes:self.attributes];
    }
    
    
}


@end
