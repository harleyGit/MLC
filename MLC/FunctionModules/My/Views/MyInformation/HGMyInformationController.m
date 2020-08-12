//
//  HGMyInformationController.m
//  HGSWB
//
//  Created by 黄刚 on 2018/11/6.
//  Copyright © 2018 HuangGang'sMac. All rights reserved.
//

#import "HGMyInformationController.h"
#import "HGMyPresent.h"

@interface HGMyInformationController ()<MyPresentDelegate>
{
    //放大的高清头像
    UIImageView *largeAvatar;
}

//封面Picture
@property(nonatomic, retain) UIImageView *coverPic;
@property(nonatomic, retain) UIImageView *avatar;
@property(nonatomic, retain) UIButton *QRCodeBtn;
@property(nonatomic, retain) UIButton *editBtn;
@property(nonatomic, retain) UILabel *name;
@property(nonatomic, retain) UILabel *gender;
@property(nonatomic, retain) UIImageView *genderPic;
@property(nonatomic, retain) UILabel *descriptionLab;
@property(nonatomic, retain) UIImageView *locationPic;
@property(nonatomic, retain) UILabel *locationLab;
@property(nonatomic, retain) UIImageView *linkPic;
@property(nonatomic, retain) UILabel *linkLab;
@property(nonatomic, retain) UILabel *attention_count;
@property(nonatomic, retain) UILabel *fans_count;
@property(nonatomic, retain) UILabel *praise_count;


@end

@implementation HGMyInformationController

#pragma mark -- GET/SET
- (UIImageView *)coverPic {
    if (!_coverPic) {
        _coverPic = [UIImageView new];
        _coverPic.backgroundColor = [UIColor grayColor];
    }
    return _coverPic;
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [UIImageView new];
        _avatar.userInteractionEnabled = YES;
        UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyMyAvatar:)];
        [_avatar addGestureRecognizer:singTap];
    }
    return _avatar;
}

- (UIButton *)QRCodeBtn {
    if (!_QRCodeBtn) {
        _QRCodeBtn = [UIButton new];
        [_QRCodeBtn setBackgroundImage:[UIImage imageNamed:@"my_qrcode"] forState:UIControlStateNormal];
        [_QRCodeBtn addTarget:self action:@selector(pushToNextQRCodeController:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QRCodeBtn;
}
-(UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton new];
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"my_eidt"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(presentNextToEditorController:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UILabel *)name {
    if (!_name) {
        _name = [UILabel new];
    }
    return _name;
}

- (UIImageView *)genderPic {
    if (!_genderPic) {
        _genderPic = [UIImageView new];
        _genderPic.image = [UIImage imageNamed:@"my_femal"];
    }
    return _genderPic;
}

- (UILabel *)descriptionLab {
    if (!_descriptionLab) {
        _descriptionLab = [UILabel new];
    }
    return _descriptionLab;
}

- (UIImageView *)locationPic {
    if (!_locationPic) {
        _locationPic = [UIImageView new];
        _locationPic.image = [UIImage imageNamed:@"my_location"];
    }
    return _locationPic;
}

- (UILabel *)locationLab {
    if (!_locationLab) {
        _locationLab = [UILabel new];
         _locationLab.font = [UIFont systemFontOfSize:16.0f];
    }
    return _locationLab;
}

- (UIImageView *)linkPic {
    if (!_linkPic) {
        _linkPic = [UIImageView new];
        _linkPic.image = [UIImage imageNamed:@"my_link"];
    }
    return _linkPic;
}

- (UILabel *)linkLab {
    if (!_linkLab) {
        _linkLab = [UILabel new];
        _linkLab.font = [UIFont systemFontOfSize:16.0f];
    }
    return _linkLab;
}

- (UILabel *)attention_count {
    if (!_attention_count) {
        _attention_count = [UILabel new];
    }
    return _attention_count;
}

- (UILabel *)fans_count {
    if (!_fans_count) {
        _fans_count = [UILabel new];
    }
    return _fans_count;
}


#pragma mark -- Method

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HGDEFAULT_COLOR;

    
    [self requestDataForDomain_show];
    [self layoutViews];
}


#pragma mark -- Request
- (void) requestDataForDomain_show {
    HGMyPresent *mp = [HGMyPresent new];
    mp.delegate = self;
    [mp loadDataFor_UsersDomain_show];
}


#pragma mark --HGMyDataSourceDelegate
- (void) switchToJSONForData:(id)data {
    NSError *error = nil;
    HGMyInformationModel *mim = [[HGMyInformationModel alloc] initWithDictionary:data error:&error];
    
    [self bindMyInformationModel:mim];
}

- (void) bindMyInformationModel:(HGMyInformationModel *)myInformationM {
    self.avatar.image = [UIImage imageWithData:[HGTools transformToDataForURLString:myInformationM.profile_image_url]];
    largeAvatar = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[HGTools transformToDataForURLString:myInformationM.avatar_large]]];
    [self.avatar.image imageWithSize:CGSizeMake(80.0f, 80.0f) radius:40.0f backColor:[UIColor whiteColor] completion:^(UIImage * _Nonnull image) {
        self.avatar.image = image;
    }];
    
    self.name.text = myInformationM.name;
    self.descriptionLab.text = myInformationM.introduction;
    self.locationLab.text = myInformationM.location;
    self.linkLab.text = myInformationM.url;
    self.attention_count.text = myInformationM.friends_count;
    self.fans_count.text = myInformationM.followers_count;
    if ([myInformationM.gender isEqualToString:@"f"]) {
        self.genderPic.image = [UIImage imageNamed:@"my_femal"];
    }else if([myInformationM.gender isEqualToString:@"m"]) {
        self.genderPic.image = [UIImage imageNamed:@"my_male"];
    }else {
        self.genderPic.image = [UIImage imageNamed:@"my_male_femal"];
    }
}

#pragma mark -- Action
- (void)pushToNextQRCodeController:(UIButton *)sender {
    
}

- (void)presentNextToEditorController:(UIButton *)sender {
    
}

- (void) magnifyMyAvatar:(UIGestureRecognizer *)gesture {
    [HGTools scanBigImageWithImageView:largeAvatar alpha:6.0f];
}


- (void) layoutViews {
    UIView *headView = [UIView new];
    headView.userInteractionEnabled = YES;
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(self.view);
        make.height.equalTo(@340);
    }];

    [headView addSubview:self.coverPic];
    [self.coverPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.equalTo(headView);
        make.height.equalTo(@150);
    }];
    
    [self.view addSubview:self.avatar];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.width.and.height.equalTo(@80);
        make.centerY.equalTo(self.coverPic.mas_bottom);
    }];
    
    
    [headView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_bottom).offset(13);
        make.left.equalTo(self.avatar);
    }];
    
    [headView addSubview:self.genderPic];
    [self.genderPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(6);
        make.width.and.height.equalTo(@30.0f);
    }];
    
    [headView addSubview:self.descriptionLab];
    [self.descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.top.equalTo(self.name.mas_bottom).offset(20);
    }];
    
    [headView addSubview:self.locationPic];
    [self.locationPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descriptionLab);
        make.top.equalTo(self.descriptionLab.mas_bottom).offset(15);
        make.height.and.width.equalTo(@18);
    }];
    
    [headView addSubview:self.locationLab];
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationPic.mas_right).offset(6);
        make.top.equalTo(self.locationPic);
    }];
    
    
    [headView addSubview:self.linkPic];
    [self.linkPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationLab.mas_right).offset(16);
        make.top.equalTo(self.locationLab).offset(3);
        make.width.and.height.equalTo(@14);
    }];
    [headView addSubview:self.linkLab];
    [self.linkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.linkPic.mas_right).offset(6);
        make.right.equalTo(headView).offset(-20);
        make.top.equalTo(self.locationLab);
    }];

    
    [headView addSubview:self.attention_count];
    [self.attention_count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationPic);
        make.top.equalTo(self.locationPic.mas_bottom).offset(15);
    }];
    
    [headView addSubview:self.fans_count];
    [self.fans_count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.attention_count.mas_right).offset(25);
        make.top.equalTo(self.attention_count);
    }];
    
    
    [headView addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView).offset(-15);
        make.top.equalTo(self.coverPic.mas_bottom).offset(8);
        make.width.equalTo(@34);
        make.height.equalTo(@34);
    }];
    

    [headView addSubview:self.QRCodeBtn];
    [self.QRCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editBtn.mas_left).offset(-15);
        make.top.equalTo(self.editBtn);
        make.width.equalTo(@34);
        make.height.equalTo(@34);
    }];
    
    
}

@end
