//
//  HGFunctionDetailVM.m
//  HGSWB
//
//  Created by 黄刚 on 2018/8/5.
//  Copyright © 2018年 HuangGang'sMac. All rights reserved.
//

#import "HGFunctionDetailVM.h"

@implementation HGFunctionDetailVM

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

- (void) acquierFunctionDeatailDataWithParameters:(NSDictionary *) parameters {
    NSString *port = @"all?";
    
    NSString *baseUrl = [HGNetworking shuWenPortUrl: port parameters:parameters];
    [HGNetworking requestWithUrl:baseUrl success:^(id successModel) {
//        if ([successModel isKindOfClass:[SWBaseModel class]]) {
//            SWBaseModel *bm = successModel;
//            HGAllNewsModel *anm = [[HGAllNewsModel alloc] initWithDictionary:bm.data error:nil];
//
//            self.successModel(anm.news);
//        }
        NSMutableArray * eachNews = [HGFunctionDetailVM dataModelTranslationForBaseM:successModel];
        self.successModel(eachNews);
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
            NSLog(@"---------Unable to copy file: %@", [error localizedDescription]);
            

            [eachNews addObject: eachNew];
        }
    }
    return eachNews;
}

@end
