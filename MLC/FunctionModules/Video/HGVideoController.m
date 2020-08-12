//
//  HGVideoController.m
//  HGSWB
//
//  Created by 黄刚 on 2018/10/6.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import "HGVideoController.h"
#import "RollView.h"

@interface HGVideoController() <UISearchBarDelegate, RollViewDelegate>

@property(nonatomic, retain)HGSearchBar *searchBar;
@property(nonatomic, retain)UITextView *inputText;
@property(nonatomic, retain)NSString *kvoText;

@property (nonatomic, strong) RollView *rollView;

@end

@implementation HGVideoController
- (UITextView *)inputText {
    if (!_inputText) {
        _inputText = [UITextView new];
        _inputText.text = @"轩辕依人眼睛微眯：“然后你把我师兄方书，用四口云纹飞刀，钉在了石柱上。小tuǐ上两刀，肩侧上两刀口一直过了两个时辰，才把刀取下，可到现在都还没把你那惊云神灭剑意，驱逐出来据说很痛，叫的好像杀猪一宗守顿时一乐，心中竟是暗觉快意。他对龙霸天方书这类鼻孔朝天，尾巴翘到的天上的名门弟子，最看不顺眼了。\n 先前也就属这位方书的话，最是难听。听到自己，将这人用飞刀钉住，顿时心xiōng大快，念头畅达。\n 慢着，飞刀？\n 宗守又mō了mō自己的袖子，然后是yù哭无泪，心痛无比。自己辛辛苦苦，蕴养了好几个月的云纹飞刀，这就没了？足可诛杀四位武宗的飞刀，就用在这么一个垃圾身上？明明一刀，就可解决。\n  心中纠紧，宗守过了半晌，才回过气来。自我安慰着，其实这样也不错，当时的自己，肯定很帅很酷。\n “再后面呢？我还做了什么？依人你一口气说完，我听着就是！”“再后面啊！”轩辕依人一阵迟疑，板着小脸道：“后面你把我爹也给揍了！” \n宗守正喝着茶，此刻闻言，不由‘噗，的一声。口中的水，全数喷了出去。如同一个扇面，把这个房间的小半，都笼罩了进去。轩辕依人似乎也料到了，提前躲开。 \n宗守旋即又觉不对，仔细的想了想。面sè又淡定了下来：“依人你也学坏了，骗人也不打草稿。 \n我那岳丈，早已是地轮九脉的巅峰，距离天位只有半步之遥，只差着一层膜没有捅破而已、即便是十个我，也不是他对手，怎么可能揍得了他？胡说乱侃一”\n 就在宗守有些不耐时，谭涛才淡淡开口：“小姐无需强迫世子，也无道歉的必要。昨日之事，错在于我。说来还是老夫该庆幸才是，换作任何人，有世子这样的本事，都未必就是此了局。似我这般行事，说不定就有血光在灾口也万分庆幸，城主能得此佳婿，玄山城后继有人。对了，另还有一事告知，在你面见城主之前，我已命人把消息传于给烈焰山与云瑕山。到后来追悔莫及，已追不回了。大约过上几日，世子就会见到他们的人手”\n宗守再次愣住，暗想这才是一位狠人，当真是yīn狠无比！简直毒辣至绝，全不留余地。";
    }
    return _inputText;
}

- (HGSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[HGSearchBar alloc] init];
        _searchBar.placeholder = @"喜欢的视频";
        _searchBar.barStyle = UIBarStyleBlack;
    }
    return  _searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatPicRollView];
    return;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAcion:)];
    [self.view addGestureRecognizer:tap];
    
//    self.kvoText = @"124";
    
    [self PG_addObserver:self forKey:NSStringFromSelector(@selector(kvoText)) withBlock:^(id  _Nonnull observedObject, NSString * _Nonnull observedKey, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"---->>>自定义KVO %@.%@ is now: %@", observedObject, observedKey, newValue);
    }];
    
    self.kvoText = @"然后你把我师兄方书，用四口云纹飞刀，钉在了石柱上。小tuǐ上两刀，肩侧上两刀口一直过了两个时辰，才把刀取下，可到现在都还没把你那惊云神灭剑意，驱逐出来据说很痛，叫的好像杀猪";
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimer * timer = [NSTimer timerWithTimeInterval:1.f repeats:YES block:^(NSTimer * _Nonnull timer) {
               static int count = 0;
               [NSThread sleepForTimeInterval:1];
               //休息一秒钟，模拟耗时操作
               NSLog(@"%s - %d",__func__,count++);
           }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        //子线程需要手动开启Runloop
        [[NSRunLoop currentRunLoop] run];
        NSLog(@"当前线程: %@", [NSThread currentThread]);
    });
    
    
    
    [self addSubViews];
    [self testRichView];
}

-(void)creatPicRollView{
    
    
    
    self.rollView = [[RollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 150) withDistanceForScroll:12.0f withGap:8.0f];
   
    /** 全屏宽滑动 视图之间间隙,  将 Distance 设置为 -12.0f */
   // self.rollView = [[RollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 150) withDistanceForScroll: -12.0f withGap:8.0f];
   // self.rollView.backgroundColor = [UIColor blackColor];
    
    self.rollView.delegate = self;
   
    [self.view addSubview:self.rollView];
    
    
    NSArray *arr = @[@"1.jpg",
                     @"2.jpg",
                     @"3.jpg"];
    /*
     ,
     @"4.jpg",
     @"5.jpg",
     @"6.jpg"
     */
    
    [self.rollView rollView:arr];
}

#pragma mark - 滚动视图协议
-(void)didSelectPicWithIndexPath:(NSInteger)index{
    
    if (index != -1) {
        
        NSLog(@"%ld", (long)index);
    }
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    [self layoutViews];

}

- (void) testRichView {
    
    //段落格式
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;//居中
    
    NSDictionary *attribute_one = @{
        NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:36.0f],//字体大小
        NSParagraphStyleAttributeName:paragraph,//段落格式
        NSStrokeWidthAttributeName:@3, //描边宽度
        NSStrokeColorAttributeName:[UIColor greenColor],//设置 描边颜色
        NSObliquenessAttributeName:@1//倾斜程度
                                    };
    
    HGRichTextView *rtv = [[HGRichTextView alloc] initWithFrame:CGRectMake(100, 90, 214, 60) text:@"返回" textFrame:CGRectMake(60, 10, 94, 40) textAttributes:attribute_one];
    rtv.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:rtv];

}



- (void) addSubViews {
    [self.view addSubview:self.searchBar];

    [self.view addSubview:self.inputText];
}

- (void)layoutViews {
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(HGSTATUS_FRAME_HEIGHT);
        make.height.equalTo(@45.0f);
    }];
    
    [self.inputText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(100);
        make.width.equalTo(@300);
        make.height.equalTo(@200);
        make.centerX.equalTo(self.view);
    }];
    
}

- (void) tapAcion:(UITapGestureRecognizer *)gesture {
    //促使UITextFild放弃第一响者
    [self.view endEditing:YES];
}





@end
