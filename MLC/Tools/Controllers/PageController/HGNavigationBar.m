//
//  HGNavigationBar.m
//  HGSWB
//
//  Created by 黄刚 on 2019/1/14.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGNavigationBar.h"
@interface HGCustomSearchBar : UITextField

@end

@implementation HGCustomSearchBar

//设置leftView，搜索框左边(人物头像距离左边的位置)图片的位置
- (CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    
    iconRect.origin.x += 8;
    return iconRect;
}

@end

@interface HGActionImageView : UIImageView

@property(nonatomic, copy) void (^ imageClickBlock)(void);

@end

@implementation HGActionImageView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.imageClickBlock) {
        self.imageClickBlock(); //点击图片后触发的行为，很睿智
    }
}

@end


@interface HGNavigationBar()<UITextFieldDelegate>

@end

@implementation HGNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //左边头像
        HGActionImageView *mineImageView = [HGActionImageView new];
        mineImageView.image = [UIImage imageNamed:@"home_no_login_head"];
        [self addSubview:mineImageView];
        @weakify(self);
        [mineImageView setImageClickBlock:^{
            @strongify(self);
            if (self.navigationBarCallBack) {
                self.navigationBarCallBack(HGNavigationBarActionMine);
            }
        }];
        
        HGActionImageView *cameraImageView = [HGActionImageView new];
        cameraImageView.image = [UIImage imageNamed:@"home_camera"];
        [self addSubview:cameraImageView];
        [cameraImageView setImageClickBlock:^{
            @strongify(self);
            if (self.navigationBarCallBack) {
                self.navigationBarCallBack(HGNavigationBarActionSend);
            }
        }];
        
        HGCustomSearchBar *searchBar = [HGCustomSearchBar new];
        searchBar.borderStyle = UITextBorderStyleRoundedRect;
        searchBar.backgroundColor = [UIColor whiteColor];
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        leftView.image = [UIImage imageNamed:@"searchicon_search_20x20_"];
        searchBar.leftView = leftView;  //自定义搜索款，左边的放大镜图片，leftview和rightview，这两个属性分别能设置textField内的左右两边的视图
        searchBar.delegate = self;
        searchBar.text = @"搜你想搜的头条";
        searchBar.textColor = [UIColor grayColor];
        searchBar.font = [UIFont systemFontOfSize:12.0f];
        searchBar.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:searchBar];
        
        [mineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(self).offset(-9);
            make.left.mas_equalTo(self).offset(15);
        }];
        [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(mineImageView.mas_right).offset(15);
            make.right.mas_equalTo(cameraImageView.mas_left).offset(-15);
            make.bottom.mas_equalTo(self).offset(-9);
            make.height.mas_equalTo(26);
        }];
        
        [cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.right.mas_equalTo(self).offset(-15);
            make.bottom.mas_equalTo(self).offset(-9);
            
        }];
        
        _searchSubjuct = [RACSubject subject];
    }
    return self;
}

+ (instancetype) navigationBar {
    HGNavigationBar *bar = [[HGNavigationBar alloc] initWithFrame:CGRectMake(0, 0, HGSCREEN_WIDTH, HGSTATUS_NAVIGATION_HEIGHT)];
    bar.backgroundColor = [UIColor colorWithRed:0.83 green:0.24 blue:0.24 alpha:1];
    
    return bar;
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [_searchSubjuct sendNext:textField];
    return NO;
}

//指定位置后不需设置大小，系统自动调用该方法，使用其size
- (CGSize)intrinsicContentSize {
    //指控件的内置大小，控件的内置大小往往是由控件本身的内容所决定的，比如一个UILabel的文字很长，那么该UILabel的内置大小自然会很长。设置初始时view的size大小：https://www.jianshu.com/p/3d41981e2282，https://blog.csdn.net/hard_man/article/details/50888377
    return CGSizeMake(HGSCREEN_WIDTH -24, 44.0f);
}

@end
