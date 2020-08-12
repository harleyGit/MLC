//
//  HGShuWenPresenter.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/21.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGShuWenPresenter.h"

@interface HGShuWenPresenter()
{
    UITableView *_view;
}

@property(nonatomic, strong) NSMutableArray<HGEachNewsModel *>* newsM;
@end

@implementation HGShuWenPresenter


- (instancetype)initWithView:(UITableView *)view {
    self = [super init];
    if (self) {
        _view            = view;
//        _view.delegate   = self;
//        _view.dataSource = self;
    }
    
    return self;
}

- (void)attachView:(UITableView *)view {
    _view            = view;
//    _view.delegate   = self;
//    _view.dataSource = self;
}


- (instancetype)initWithParameters:(NSDictionary *)parameters  successModel:(SuccessModel) successModel {
    self = [super init];
    NSString* encodedString = [@"上海" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (self) {
        self.successModel = [successModel copy];//Politics
        NSDictionary *parameters  = @{@"category":@"", @"region": encodedString, @"first_id": @"", @"last_id": @"", @"size": @15};
        [self acquierFunctionDeatailDataWithParameters:parameters];
    }
    return self;
}

- (void) shuWenOfParameters:(NSMutableDictionary *) parameters successModel:(SuccessModel) successModel {

    if (![HGTools isBlankForString:[parameters objectForKey:@"region"]]) {
        NSString *regionStr = [parameters[@"region"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        parameters[@"region"] = regionStr;
    }
    
    NSDictionary *baseParameters = @{@"first_id": @"", @"last_id": @"", @"size": @15};
    self.successModel = [successModel copy];
    
    [parameters addEntriesFromDictionary:baseParameters];
    [self acquierFunctionDeatailDataWithParameters:parameters.copy];
}

- (void) acquierFunctionDeatailDataWithParameters:(NSDictionary *) parameters {
    NSString *port = @"all?";
    
    NSString *baseUrl = [HGNetworking shuWenPortUrl: port parameters:parameters];
    
    [HGNetworking requestWithUrl:baseUrl success:^(id successModel) {
        NSMutableArray * eachNews = [HGShuWenPresenter dataModelTranslationForBaseM:successModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.successModel(eachNews);
        });
    } failure:^(NSError *error) {
        NSLog(@"---->> %@", error);
    }];
}

+ (NSMutableArray<HGEachNewsModel *> *) dataModelTranslationForBaseM:(id)baseM {
    NSMutableArray *eachNews = [NSMutableArray arrayWithCapacity:2];
    
    SWBaseModel *bm = baseM;
    if ([bm isKindOfClass:[SWBaseModel class]]) {
        HGAllNewsModel *anm = [[HGAllNewsModel alloc] initWithDictionary:bm.data error:nil];
        
        for (NSDictionary *eachNewDic in anm.news) {
            NSError *error=nil;
            
        HGEachNewsModel *eachNew = [[HGEachNewsModel alloc] initWithDictionary:eachNewDic error:&error];
        [eachNews addObject: eachNew];
        }
    }
    return eachNews;
}

- (void)dealloc {
//    NSLog(@"--------->> HGShuWenPresenter释放了");
}

@end
