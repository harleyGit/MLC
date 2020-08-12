//
//  ViewController.m
//  HGSWB
//
//  Created by 黄刚 on 2018/7/7.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "ShuWenController.h"

@interface ShuWenController ()<ShuWenPresenterDelegate, HGPageControllerDataSource, HGPageControllerDelegate, HGMenuViewDelegate>{
    
}

@property (nonatomic, strong) HGSWDataSource *dataSource_politics;
@property (nonatomic, strong) HGSWDataSource *dataSource_miliatry;
@property (nonatomic, strong) HGSWDataSource *dataSource_finance;
@property (nonatomic, strong) HGSWDataSource *dataSource_society;
@property (nonatomic, strong) HGSWDataSource *dataSource_world;
@property (nonatomic, strong) HGSWDataSource *dataSource_entertainment;
@property (nonatomic, strong) HGSWDataSource *dataSource_sport;
@property (nonatomic, strong) HGSWDataSource *dataSource_tech;
@property (nonatomic, strong) HGSWDataSource *dataSource_living;

@property (nonatomic, strong)  HGScrollMenuView *smv;

@property(nonatomic, retain) HGFunctionVM *fvm;

@property(nonatomic, retain) NSMutableArray *models;

@property(nonatomic, retain) HGHomeTitleViewModel *titleViewModel;


@end

@implementation ShuWenController
#pragma mark -- Get
- (HGHomeTitleViewModel *)titleViewModel {
    if (!_titleViewModel) {
        _titleViewModel = [[HGHomeTitleViewModel alloc] init];
    }
    return _titleViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HGDEFAULT_COLOR;
    
    if (self.scrollType == ScrollLabelTypeController) { //优化加载今日头条
        [self touTiaoConfiguration];
    }else {
        __weak typeof(self) weakSelf = self;
        self.fvm = [[HGFunctionVM alloc] initWithSuccessModel:^(id model) {
            NSArray *titles = model;
            [weakSelf createShuWenFunctionViewsWithTitles:titles];
        }];
        
        [self.fvm returenModel];
    }
    
}

- (void) touTiaoConfiguration {
    
    @weakify(self);
    HGNavigationBar *bar = [self showCustomNavBar];
    [bar setNavigationBarCallBack:^(HGNavigationBarAction action) {
        //@strongify(self);
        if (action != HGNavigationBarActionSend) {
            NSLog(@"跳转到我的Controller");
        }else {
            NSLog(@"拍照！");
        }
    }];
    [self.view addSubview:bar];
    
    [self configuratedDelegateAndDatasource];
    [[self.titleViewModel.titlesCommand execute:@13] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.models = x;    //HGHomeTitleModel数组
        [self configurationScrollView];
        //[self configPageVC];
    }];
}

- (void)configuratedDelegateAndDatasource {
    self.delegate = self;
    self.dataSource = self;
    self.automaticallyCalculatesItemWidths = YES;
    self.itemMargin = 10.0f;
}

- (void) needRefreshTableViewData {//刷新数据
    HGDetailController *dc = (HGDetailController *)self.currentViewController;
    [dc needRefreshTableViewData];
}

//UICollectionView
- (void) createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置headView尺寸大小
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    //设置itemSize大小
    layout.itemSize = CGSizeMake(110, 150);
    
    HGCollectionView *collection = [[HGCollectionView alloc] initWithFrame:self.view.frame viewLayout: layout];
    
    [self.view addSubview: collection];
}

- (UITableView *) createShuWenViewForParameters:(NSDictionary *)parameters  delegateDataSource:(HGSWDataSource *) datasource {
    UITableView *tableView       = [ShuWenController getTableView];
    HGShuWenPresenter *presenter = [HGShuWenPresenter new];

    [presenter shuWenOfParameters:[NSMutableDictionary dictionaryWithDictionary:parameters] successModel:^(id models) {
        [datasource addDataArray:models];
        [tableView reloadData];
    }];
    tableView.dataSource = datasource;
    tableView.delegate   = datasource;
    
    return tableView;
}

//分页导航菜单视图
- (void)createShuWenFunctionViewsWithTitles:(NSArray *)titles {
    
    NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:2];
    for (SWCategoryModel *model in titles) {
        [titleArr addObject:model.name];
    }
    
    static NSString *const cellIdentifier = @"shuWenCellIdentifier";
    
    self.dataSource_politics = [[HGSWDataSource alloc] initWithIdentifier:cellIdentifier cellConfigure:^(id cell, id model) {
        [cell bindModel:model];
    }];
    UITableView *view_politics = [self createShuWenViewForParameters:@{@"region":@"上海", @"category":@""} delegateDataSource:self.dataSource_politics];
    
    
    self.dataSource_miliatry =  [[HGSWDataSource alloc] initWithIdentifier:cellIdentifier cellConfigure:^(id cell, id model) {
        [cell bindModel:model];
    }];
    UITableView *view_military = [self createShuWenViewForParameters:@{@"region":@"北京", @"category":@""} delegateDataSource:self.dataSource_miliatry];
    
    
    self.dataSource_finance = [[HGSWDataSource alloc] initWithIdentifier:cellIdentifier cellConfigure:^(id cell, id model) {
        [cell bindModel:model];
    }];
    UITableView *view_finance = [self createShuWenViewForParameters:@{@"region":@"", @"category":@"Finance"} delegateDataSource:self.dataSource_finance];
    
    self.dataSource_society = [[HGSWDataSource alloc] initWithIdentifier:cellIdentifier cellConfigure:^(id cell, id model) {
        [cell bindModel:model];
    }];
    UITableView *view_society = [self createShuWenViewForParameters:@{@"region":@"郑州", @"category":@"Society"} delegateDataSource:self.dataSource_society];

    self.dataSource_world = [[HGSWDataSource alloc] initWithIdentifier:cellIdentifier cellConfigure:^(id cell, id model) {
        [cell bindModel:model];
    }];
    UITableView *view_world = [self createShuWenViewForParameters:@{@"region":@"", @"category":@"World"} delegateDataSource:self.dataSource_world];
    
    self.dataSource_entertainment  = [[HGSWDataSource alloc] initWithIdentifier:cellIdentifier cellConfigure:^(id cell, id model) {
        [cell bindModel:model];
    }];
    UITableView *view_entertainment = [self createShuWenViewForParameters:@{@"region":@"", @"category":@"Entertainment"} delegateDataSource:self.dataSource_entertainment];

    self.dataSource_sport = [[HGSWDataSource alloc] initWithIdentifier:cellIdentifier cellConfigure:^(id cell, id model) {
        [cell bindModel:model];
    }];
    UITableView *view_sport = [self createShuWenViewForParameters:@{@"region":@"", @"category":@"Sport"} delegateDataSource:self.dataSource_sport];

    self.dataSource_tech = [[HGSWDataSource alloc] initWithIdentifier:cellIdentifier cellConfigure:^(id cell, id model) {
        [cell bindModel:model];
    }];
    UITableView *view_tech = [self createShuWenViewForParameters:@{@"region":@"", @"category":@"Tech"} delegateDataSource:self.dataSource_tech];
    
    self.dataSource_living = [[HGSWDataSource alloc] initWithIdentifier:cellIdentifier cellConfigure:^(id cell, id model) {
        [cell bindModel:model];
    }];
    UITableView *view_living = [self createShuWenViewForParameters:@{@"region":@"", @"category":@"Living"} delegateDataSource:self.dataSource_living];
    
    NSArray *views = @[view_politics, view_military, view_finance, view_society, view_world, view_entertainment, view_sport, view_tech, view_living];
    
    self.smv = [[HGScrollMenuView alloc] initWithFrame:self.view.frame titles:titleArr contentViews:views];
    [self.view addSubview:self.smv];
}



#pragma  mark -- ShuWenPresenterDelegate
- (void)attchModels:(id)newsM {
    self.models = newsM;
}


#pragma mark -- HGPageControllerDataSource
//返回pageController管理的title
- (NSString *)pageController:(HGPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index > self.models.count - 1) {
        return  @"      ";
    }else {
        HGHomeTitleModel *model = self.models[index];
        return model.name;
    }
}


//通过网络请求的model获得controllers数目
- (NSInteger)numbersOfChildControllersInPageController:(HGPageController *)pageControlelr {
    if (self.models.count == 0 || !self.models) {
        return 0;
    }
    
    return self.models.count +1;    //为了做成今日头条的效果 故此多加了一个占位的控制器
}

- (UIViewController *)pageController:(HGPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index > self.models.count -1) {
        return [[HGDetailController alloc] init];
    }
    
    HGHomeTitleModel *model = self.models[index];
    HGDetailController *detail = [[HGDetailController alloc] init];
    detail.model = model;
    
    return detail;
}

#pragma mark -- HGMenuViewDelegate
- (void)menuView:(HGMenuView *)menu didSelectedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    if (index == -1) {
        [self needRefreshTableViewData];
    }else {
        //super调用代理方法，需要把代理方法申明在.h文件中，不能再.m文件中，否则发现不到
        [super menuView:menu didSelectedIndex:index currentIndex:currentIndex];
    }
}

+ (UITableView *) getTableView {
    UITableView *tableView = [UITableView new];
    tableView.backgroundColor = HGDEFAULT_COLOR;
    
    return tableView;
}

- (HGNavigationBar *) showCustomNavBar {
    self.navigationController.navigationBar.hidden = YES;
    HGNavigationBar *bar = [HGNavigationBar navigationBar];
    return bar;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
