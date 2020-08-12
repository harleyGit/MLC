//
//  HGWeiBoController.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/3.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGWeiBoController.h"

@interface HGWeiBoController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) UITableView *contentView;
@property(nonatomic, retain) UIButton *startBtn;

@property(nonatomic, retain) NSArray *wbModels;
@property(nonatomic, retain) NSOperationQueue *queue;

@end

@implementation HGWeiBoController

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSArray *)wbModels {
    if (!_wbModels) {
        
    }
    return _wbModels;
}

- (UITableView *)contentView {
    if (!_contentView) {
        _contentView = [UITableView new];
        _contentView.delegate = self;
        _contentView.dataSource = self;
    }
    return _contentView;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 60)];
        _startBtn.backgroundColor = [UIColor whiteColor];
        [_startBtn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HGMAIN_COLOR;
    
    NSString *test = @"大头爸爸";
    test.name = @"张光北";
    NSLog(@"字符串分类属性name值： %@", test.name);

    [self.view addSubview:self.startBtn];
    
    [self layoutViews];
    [self startRefreshDataForTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self testReactive];
}

- (void) startAction {
    [self.contentView.mj_header beginRefreshing];
}


- (void) startRefreshDataForTable {
    self.contentView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        //开始刷新请求数据
        NSLog(@"开始刷新请求数据");
    }];
    
    //结束刷新数据
    [self.contentView.mj_header endRefreshing];
}

- (void)testReactive {
    //注意：当前命令内部发送数据完成，一定要主动发送完成
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block调用：执行命令的时候就会调用
        NSLog(@"%@", input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 发送数据
            [subscriber sendNext:@"执行命令产生的数据"];
            
            // *** 发送完成 **
            [subscriber sendCompleted];
            return nil;
        }];  
    }];
    // 监听事件有没有完成
    [command.executing subscribeNext:^(id x) {
        if ([x boolValue] == YES) { // 正在执行
            NSLog(@"当前正在执行%@", x);
        }else {
            // 执行完成/没有执行
            NSLog(@"执行完成/没有执行");
        }
    }];
    
    // 2.执行命令
    [command execute:@"welcome  to  my home!!"];
    
}

#pragma mark -- UITaleViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0f;
}


#pragma mark -- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    

    return cell;
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//self.wbModels.count;
}


- (void) layoutViews {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
}


@end
