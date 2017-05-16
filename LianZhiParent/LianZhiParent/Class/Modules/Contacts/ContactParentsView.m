//
//  ContactParentsView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/4.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ContactParentsView.h"

@implementation ContactParentItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _avatarView = [[AvatarView alloc] initWithRadius:18];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_nameLabel];
        
        _relationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_relationLabel setFont:[UIFont systemFontOfSize:14]];
        [_relationLabel setTextColor:kCommonParentTintColor];
        [self addSubview:_relationLabel];
        
//        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_phoneButton addTarget:self action:@selector(onPhoneClicked) forControlEvents:UIControlEventTouchUpInside];
//        [_phoneButton setImage:[UIImage imageNamed:@"contact_telephone"] forState:UIControlStateNormal];
//        [_phoneButton setImage:[UIImage imageNamed:@"contact_telephone_disabled"] forState:UIControlStateDisabled];
//        [self addSubview:_phoneButton];
//        
//        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_chatButton addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
//        [_chatButton setImage:[UIImage imageNamed:@"contact_chat"] forState:UIControlStateNormal];
//        [_chatButton setImage:[UIImage imageNamed:@"contact_chat_disabled"] forState:UIControlStateDisabled];
//        [self addSubview:_chatButton];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_sepLine setBackgroundColor:[UIColor colorWithHexString:@"eaeaea"]];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setFamilyInfo:(FamilyInfo *)familyInfo{
    _familyInfo = familyInfo;
    [_phoneButton setFrame:CGRectMake(self.width - 35 - 5, 0, 35, self.height)];
    [_chatButton setFrame:CGRectMake(_phoneButton.x - 35, 0, 35, self.height)];
    [_phoneButton setEnabled:_familyInfo.mobile.length > 0];
    [_chatButton setEnabled:_familyInfo.actived];
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_familyInfo.avatar]];
    [_avatarView setOrigin:CGPointMake(12, (60 - _avatarView.height) / 2)];
    [_avatarView setStatus:_familyInfo.actived ? nil : @"未下载"];
    [_nameLabel setText:_familyInfo.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatarView.right + 10, (60 - _nameLabel.height) / 2)];
    
    [_relationLabel setText:_familyInfo.relation];
    [_relationLabel sizeToFit];
    [_relationLabel setOrigin:CGPointMake(_nameLabel.right + 10, (60 - _relationLabel.height) / 2)];
    
    [_sepLine setFrame:CGRectMake(12, self.height - kLineHeight, self.width - 12, kLineHeight)];
}

- (void)onPhoneClicked{
    if(self.phoneCallback){
        self.phoneCallback();
    }
}

- (void)onChatClicked{
    if(self.chatCallback){
        self.chatCallback();
    }
}

@end

@interface ContactParentsView ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView*    _tableView;
    UILabel*        _headerTitleLabel;
}

@end

@implementation ContactParentsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setClipsToBounds:NO];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.layer setShadowRadius:2];
        [self.layer setShadowOpacity:0.5];
        
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [self addSubview:_tableView];
        
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 36)];
        
        _headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, headerView.width - 12 * 2, headerView.height)];
        [_headerTitleLabel setFont:[UIFont systemFontOfSize:14]];
        [_headerTitleLabel setTextColor:kCommonParentTintColor];
        [headerView addSubview:_headerTitleLabel];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(12, headerView.height - kLineHeight, headerView.width - 12, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [headerView addSubview:sepLine];
        [_tableView setTableHeaderView:headerView];
    }
    return self;
}

- (void)setStudentInfo:(ChildInfo *)studentInfo{
    _studentInfo = studentInfo;
    [_headerTitleLabel setText:[NSString stringWithFormat:@"%@的家长",_studentInfo.name]];
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.studentInfo.family.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"ContactParentItemCell";
    ContactParentItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[ContactParentItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    ContactParentItemCell *itemCell = (ContactParentItemCell *)cell;
    FamilyInfo *familyInfo = self.studentInfo.family[indexPath.row];
    [itemCell setFamilyInfo:familyInfo];
    [itemCell setChatCallback:^{
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setTo_objid:wself.studentInfo.uid];
        [chatVC setTargetID:familyInfo.uid];
        [chatVC setChatType:ChatTypeParents];
        [chatVC setMobile:familyInfo.mobile];
        [chatVC setName:[NSString stringWithFormat:@"%@的%@",wself.studentInfo.name,[(FamilyInfo *)familyInfo relation]]];
//        [CurrentROOTNavigationVC pushViewController:chatVC animated:YES];
        [ApplicationDelegate popAndPush:chatVC];
    }];
    [itemCell setPhoneCallback:^{
        
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定拨打电话%@吗",familyInfo.mobile] style:LGAlertViewStyleAlert buttonTitles:@[@"取消", @"拨打电话"] cancelButtonTitle:nil destructiveButtonTitle:nil];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            if(index == 1){
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",familyInfo.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        }];
        [alertView showAnimated:YES completionHandler:nil];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FamilyInfo *familyInfo = self.studentInfo.family[indexPath.row];
    if(familyInfo.actived)
    {
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setTo_objid:self.studentInfo.uid];
        [chatVC setTargetID:familyInfo.uid];
        [chatVC setChatType:ChatTypeParents];
        [chatVC setMobile:familyInfo.mobile];
        [chatVC setName:[NSString stringWithFormat:@"%@的%@",self.studentInfo.name,[(FamilyInfo *)familyInfo relation]]];
        //        [CurrentROOTNavigationVC pushViewController:chatVC animated:YES];
        [ApplicationDelegate popAndPush:chatVC];
    }
    else
    {
//        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"该用户尚未下载使用连枝，您可打电话与用户联系" style:LGAlertViewStyleAlert buttonTitles:@[@"取消", @"拨打电话"] cancelButtonTitle:nil destructiveButtonTitle:nil];
//        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
//        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
//        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
//            if(index == 1){
//                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",familyInfo.mobile];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//            }
//        }];
//        [alertView showAnimated:YES completionHandler:nil];
    }

}

@end
