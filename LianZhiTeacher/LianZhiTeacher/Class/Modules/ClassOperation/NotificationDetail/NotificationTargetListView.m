//
//  NotificationTargetListVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationTargetListView.h"

@implementation NotificationTargetHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self){
        self.width = kScreenWidth;
        self.height = 56;
        _logoView = [[LogoView alloc] initWithRadius:18];
        [_logoView setOrigin:CGPointMake(12, (56 - _logoView.height) / 2)];
        [self.contentView addSubview:_logoView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:_titleLabel];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_stateLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_stateLabel];
        
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"expand_indicator"]];
        [_arrowImageView setCenter:CGPointMake(self.width - 10 - _arrowImageView.width / 2, self.contentView.height / 2)];
        [self.contentView addSubview:_arrowImageView];
        
    }
    return self;
}

- (void)setExpand:(BOOL)expand{
    _expand = expand;
    CGAffineTransform transform = _expand ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^{
        _arrowImageView.transform = transform;
    }];
}
@end

@implementation NotificationSendTargetCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _avatarView = [[AvatarView alloc] initWithRadius:18];
        [_avatarView setOrigin:CGPointMake(12, (56 - _avatarView.height) / 2)];
        [self addSubview:_avatarView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_titleLabel];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_stateLabel setFont:[UIFont systemFontOfSize:12]];
        [_stateLabel setTextColor:kCommonTeacherTintColor];
        [_stateLabel setText:@"未读"];
        [_stateLabel sizeToFit];
//        [_stateLabel setHidden:YES];
        [self addSubview:_stateLabel];
        
        _stateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"call_telephone"]];
//        [_stateImageView setHidden:YES];
        [self addSubview:_stateImageView];
    }
    return self;
}

- (void)setUserInfo:(UserInfo *)userInfo{
    _userInfo = userInfo;
    [_avatarView setImageWithUrl:[NSURL URLWithString:_userInfo.avatar] placeHolder:nil];
    [_titleLabel setText:_userInfo.name];
    [_titleLabel sizeToFit];
    [_titleLabel setOrigin:CGPointMake(_avatarView.right + 15, (56 - _titleLabel.height) / 2)];
    
    [_stateImageView setOrigin:CGPointMake(self.width - 10 - _stateImageView.width, (56 - _stateImageView.height) / 2)];
    [_stateLabel setOrigin:CGPointMake(_stateImageView.left - 10 - _stateLabel.width, (56 - _stateLabel.height) / 2)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    return @(56);
}

@end

@interface NotificationTargetListView ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*        _tableView;
}

@end

@implementation NotificationTargetListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [NotificationSendTargetCell cellHeight:nil cellWidth:tableView.width].floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *reuseID = @"NotificationTargetHeaderView";
    NotificationTargetHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID];
    if(headerView == nil){
        headerView = [[NotificationTargetHeaderView alloc] initWithReuseIdentifier:reuseID];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"NotificationSendTargetCell";
    NotificationSendTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[NotificationSendTargetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationSendTargetCell *curCell = (NotificationSendTargetCell *)cell;
    [curCell setUserInfo:[UserCenter sharedInstance].userInfo];
}



@end
