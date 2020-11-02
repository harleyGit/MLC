//
//  HGDetailController.m
//  HGSWB
//
//  Created by 黄刚 on 2019/1/7.
//  Copyright © 2019 HuangGang'sMac. All rights reserved.
//

#import "HGDetailController.h"


//, ZFPlayerDelegate 缺少
@interface HGDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, strong) HGHomeNewsCellViewModel *newsViewModel;
@property(nonatomic, strong) NSMutableArray *datas;
@property(nonatomic, weak) HGVideoListModel *playingModel;
@property(nonatomic, strong)   ZFPlayerView *playerView;
//缓存Cell高度
@property(nonatomic, strong)NSMutableDictionary *heightIndexDic;

@end

//cell估算高度
int const estimatedCellHeight = 150.0f;

@implementation HGDetailController
#pragma mark -- Get
- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView new];//sharedPlayerView];
//        _playerView.delegate = self;
        //当cell播放视频由全屏变为小屏时候，不回到中间位置
//        _playerView.cellPlayerOnCenter = NO;
        //当cell划出屏幕的时候停止播放
//        _playerView.stopPlayWhileCellNotVisable = YES;
    }
    return _playerView;
}

- (NSMutableDictionary *)heightIndexDic {
    if (!_heightIndexDic) {
        _heightIndexDic = [NSMutableDictionary dictionary];
    }
    return  _heightIndexDic;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

- (HGHomeNewsCellViewModel *)newsViewModel {
    if (!_newsViewModel) {
        _newsViewModel = [[HGHomeNewsCellViewModel alloc] init];
    }
    return _newsViewModel;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 152.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        //消除分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        //注册cellNib
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    @weakify(self);
    self.tableView.mj_header = [HGRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [[self.newsViewModel.newsCommand execute:self.model.category] subscribeNext:^(id  _Nullable x) {
            [self.datas removeAllObjects];
            
            NSArray *datas = [self hn_modelArrayWithCategory:self.model.category fromModel:x];
            [self.datas addObjectsFromArray:datas];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [HGNotificationCenter postNotificationName:TOUTIAO_KHomeStopRefreshNot object:nil];
        }];
    }];
    
    self.tableView.mj_footer = [HGRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [[self.newsViewModel.newsCommand execute:self.model.category] subscribeNext:^(id  _Nullable x) {
            NSArray *datas = [self hn_modelArrayWithCategory:self.model.category fromModel:x];
            if (datas.count == 0 || !datas) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.datas addObjectsFromArray:datas];
                [self.tableView.mj_footer endRefreshing];
            }
            
            if (![self.model.category isEqualToString:@"video"]) {
                [self.tableView reloadData];
            }else {//zfplay播放视频 直接reloadData 会终止上一个视频的播放
                NSInteger baseCount = self.datas.count - [x count];
                NSMutableArray *arr = [NSMutableArray array];
                for (int i = 0 ; i < [(NSArray *)x count]; i ++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:baseCount +i inSection:0];
                    [arr addObject:indexPath];
                }
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
                [self.tableView.mj_footer endRefreshing];
            }
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (![self.model.category isEqualToString:@"video"]) {
        return;
    }
//    [self.playerView resetPlayer];//ZFPlayer 版本太新
    
    NSArray *cells = [self.tableView visibleCells]; //获取tableView中可见的cell数组
    for (HGVideoCell *cell in cells) {
        if (cell.model.playing) {
            [cell refreshCellStatus];
            _playingModel = nil;
        }
    }
}

- (void)needRefreshTableViewData {
    //contentOffset属性时tableView的内容视图相对于tableView在X、Y轴方向的偏移，当tableView向上滚动时contentOffset.y才是大于0的。当tableView向左滚动时contentOffset.x才是大于0的。
    [self.tableView setContentOffset:CGPointZero];
    
    [self.tableView.mj_header beginRefreshing];
}

- (NSArray *)hn_modelArrayWithCategory:(NSString *)category fromModel:(id)x {
    if ([category isEqualToString:@"essay_joke"]) {
        HGHomeJokeModel *model = (HGHomeJokeModel *)x;
        return model.data;
    }else if ([category isEqualToString:@"组图"]){
        HGHomeNewsModel *model = (HGHomeNewsModel *)x;
        return model.data;
    }else if ([category isEqualToString:@"video"]){
        return x;
    }else {
        HGHomeNewsModel *model = (HGHomeNewsModel *)x;
        return model.data;
    }
}

- (CGFloat)hn_estimatedRowHeight {
    if ([self.model.category isEqualToString:@"essay_joke"]) {
        return 79;
    }else if ([self.model.category isEqualToString:@"组图"]){
        return 152;
    }else if ([self.model.category isEqualToString:@"video"]){
        return 225;
    }else {
        return 79;
    }
}


#pragma mark -- UITableViewDelegate or  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = @(cell.frame.size.height);
    [self.heightIndexDic setObject:height forKey:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *resultCell = nil;
    if ([self.model.category isEqualToString:@"essay_joke"]) {
        HGHomeJokeSummaryModel *model = self.datas[indexPath.row];
        HGHomeJokeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HGHomeJokeCell class])];
        if (!cell) {
            cell = [[HGHomeJokeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HGHomeJokeCell class])];
        }
//        cell.model = model;
        resultCell = cell;
    }else if ([self.model.category isEqualToString:@"组图"]){
        HGHomeNewsSummaryModel *model = self.datas[indexPath.row];
        HGHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HGHomeNewsCell class])];
        if (!cell) {
            cell = [[HGHomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HGHomeNewsCell class])];
        }
        cell.model = model;
        resultCell = cell;
    }else if ([self.model.category isEqualToString:@"video"]) {
        HGVideoListModel *model = self.datas[indexPath.row];
        HGVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HGVideoCell class])];
        if (!cell) {
            cell = [[HGVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HGVideoCell class])];
        }
//        cell.model = model;
        
        @weakify(self);
        [cell setImageViewCallBack:^(UIView * _Nonnull fatherView) {
            @strongify(self);
            HGVideoListModel *model = self.datas[indexPath.row];
            model.playing = YES;
            self.playingModel = model;
            NSMutableDictionary *dic = @{}.mutableCopy;
            dic[@"320P"] = model.videoModel.videoInfoModel.video_list.video_1.main_url;
            dic[@"480p"] = model.videoModel.videoInfoModel.video_list.video_2.main_url;
            dic[@"720p"] = model.videoModel.videoInfoModel.video_list.video_3.main_url;
            
            NSURL *videoURL = [NSURL URLWithString: dic[@"480p"]];
            /*
            ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
            playerModel.title            = model.videoModel.title;
            playerModel.videoURL         = videoURL;
            playerModel.placeholderImageURLString = model.videoModel.videoInfoModel.poster_url;
            playerModel.scrollView       = tableView;
            playerModel.resolutionDic    = dic;
            playerModel.indexPath        = indexPath;
            playerModel.fatherViewTag = fatherView.tag;
            [self.playerView playerControlView:nil playerModel:playerModel];
            [self.playerView autoPlayTheVideo];
             */
        }];
        resultCell = cell;
    }else {
        HGHomeNewsSummaryModel *model = self.datas[indexPath.row];
        if (model.infoModel.image_list) {
            HGHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HGHomeNewsCell class])];
            if (!cell) {
                cell = [[HGHomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HGHomeNewsCell class])];
            }
            cell.model = model;
            resultCell = cell;
        }else {
            HGContentNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HGContentNewsCell class])];
            if (!cell) {
                cell = [[HGContentNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HGContentNewsCell class])];
            }
            cell.model = model;
            resultCell = cell;
        }
    }
    return resultCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.model.category isEqualToString:@"组图"]) {
        HGHomeNewsSummaryModel *model = self.datas[indexPath.row];
//        HNHomeWebVC *webVC = [[HNHomeWebVC alloc]init];
//        webVC.urlString = model.infoModel.article_url;
//        [self.navigationController pushViewController:webVC animated:YES];
    }
}


//设置滚动时的预估值
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.heightIndexDic objectForKey:indexPath];
    if (height) {
        return height.floatValue;
    }else {
        return estimatedCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewAutomaticDimension;
}

#pragma mark -- playingModel
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.model.category isEqualToString:@"video"]) {
        return;
    }
    
    HGVideoListModel *model = self.datas[indexPath.row];
    if (model.playing) {
        model.playing = NO;
        _playingModel = nil;
        [(HGVideoCell *)cell refreshCellStatus];
    }
}

- (void)setPlayingModel:(HGVideoListModel *)playingModel {
    if (_playingModel.playing) {
        _playingModel.playing = NO;
        NSInteger index = [self.datas indexOfObject:_playingModel];
        HGVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell refreshCellStatus];
    }
    _playingModel = playingModel;
}

@end
