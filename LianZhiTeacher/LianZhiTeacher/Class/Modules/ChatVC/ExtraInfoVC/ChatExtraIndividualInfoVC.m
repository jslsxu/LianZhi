//
//  ChatExtraInfoVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/2.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatExtraIndividualInfoVC.h"
#import "SearchChatMessageVC.h"
#import "ChatTeacherInfoVC.h"
#import "ChatParentInfoVC.h"
@implementation ChatExtraUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _avatarView = [[AvatarView alloc] initWithRadius:25];
        [_avatarView setOrigin:CGPointMake(12, (80 - _avatarView.height) / 2)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.right + 10, 20, self.width - 10 - (_avatarView.right + 10), 20)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_nameLabel];
        
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.right + 10, 40, self.width - 10 - (_avatarView.right + 10), 20)];
        [_nickLabel setTextColor:[UIColor colorWithHexString:@"28c4d8"]];
        [_nickLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_nickLabel];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

- (void)setUserInfo:(UserInfo *)userInfo{
    _userInfo = userInfo;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar]];
    [_nameLabel setText:_userInfo.name];
    [_nameLabel sizeToFit];
    [_nameLabel setFrame:CGRectMake(_avatarView.right + 10, 20, self.width - 35 - (_avatarView.right + 10), _nameLabel.height)];
    [_nickLabel setText:_userInfo.nick];
    [_nickLabel sizeToFit];
    [_nickLabel setFrame:CGRectMake(_avatarView.right + 10, 80 - 20 - _nickLabel.height, _nameLabel.width, _nickLabel.height)];
}
@end

@interface ChatExtraIndividualInfoVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView*           tableView;
@property (nonatomic, strong)UISwitch*              disturbSwitch;
@property (nonatomic, strong)ContactTeacherInfo*    teacherInfo;
@property (nonatomic, strong)ContactParentInfo*     parentInfo;
@end

@implementation ChatExtraIndividualInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天信息";
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

- (void)loadData{
    @weakify(self)
    if(self.chatType == ChatTypeParents){
        ContactParentInfo *parentInfo = [[LZKVStorage userKVStorage] storageValueForKey:[self cacheKey]];
        if(parentInfo && [parentInfo isKindOfClass:[ContactParentInfo class]]){
            self.parentInfo = parentInfo;
            [self.tableView reloadData];
        }
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_parent_info" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"uid" : self.uid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            @strongify(self)
            self.parentInfo = [ContactParentInfo nh_modelWithJson:responseObject.data];
            if(self.parentInfo){
                [[LZKVStorage userKVStorage] saveStorageValue:self.parentInfo forKey:[self cacheKey]];
            }
            [self.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
        }];
    }
    else if(self.chatType == ChatTypeTeacher){
        ContactTeacherInfo *teacherInfo = [[LZKVStorage userKVStorage] storageValueForKey:[self cacheKey]];
        if(teacherInfo && [teacherInfo isKindOfClass:[ContactTeacherInfo class]]){
            self.teacherInfo = teacherInfo;
            [self.tableView reloadData];
        }
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_teacher_info" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"uid" : self.uid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            @strongify(self)
            self.teacherInfo = [ContactTeacherInfo nh_modelWithJson:responseObject.data];
            if(self.teacherInfo){
                [[LZKVStorage userKVStorage] saveStorageValue:self.teacherInfo forKey:[self cacheKey]];
            }
            [self.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
        }];
    }
}

- (NSString *)cacheKey{
    NSString *cacheKey = nil;
    if(self.chatType == ChatTypeParents){
        cacheKey = [NSString stringWithFormat:@"parentInfo_%@",self.uid];
    }
    else if(self.chatType == ChatTypeTeacher){
        cacheKey = [NSString stringWithFormat:@"teacherInfo_%@",self.uid];
    }
    return cacheKey;
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorColor:kSepLineColor];
    }
    return _tableView;
}

- (UISwitch *)disturbSwitch{
    if(_disturbSwitch == nil){
        _disturbSwitch = [[UISwitch alloc] init];
        [_disturbSwitch addTarget:self action:@selector(onValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    [_disturbSwitch setOn:self.quietModeOn];
    return _disturbSwitch;
}

- (void)onValueChanged{
    BOOL quietModeOn = !self.quietModeOn;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.uid forKey:@"from_id"];
    [params setValue:kStringFromValue(self.chatType) forKey:@"from_type"];
    [params setValue:quietModeOn ? @"close" : @"open" forKey:@"sound"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/set_thread" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        self.quietModeOn = quietModeOn;
        if(self.alertChangeCallback){
            self.alertChangeCallback(quietModeOn);
        }
    } fail:^(NSString *errMsg) {
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
        return 1;
    else
        return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 80;
    }
    else
        return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(section == 0){
        NSString *reuseID = @"UserCell";
        ChatExtraUserCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil){
            cell = [[ChatExtraUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        if(self.teacherInfo)
            [cell setUserInfo:self.teacherInfo];
        else{
            [cell setUserInfo:self.parentInfo];
        }
        return cell;
    }
    else{
        NSString *reuseID = @"ExtraInfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
            [cell.textLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        }
        if(row == 0){
            [cell.textLabel setText:@"消息免打扰"];
            [cell setAccessoryView:self.disturbSwitch];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        else {
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            if(row == 1){
                [cell.textLabel setText:@"查找聊天记录"];
                 [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            else if(row == 2){
                [cell.textLabel setText:@"清空聊天记录"];
            }
            [cell setAccessoryView:nil];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(section == 0){
        if(self.chatType == ChatTypeTeacher){
            if(self.teacherInfo){
                ChatTeacherInfoVC *teacherInfoVC = [[ChatTeacherInfoVC alloc] init];
                [teacherInfoVC setTeacherInfo:self.teacherInfo];
                [self.navigationController pushViewController:teacherInfoVC animated:YES];
            }
        }
        else if(self.chatType == ChatTypeParents){
            if(self.parentInfo){
                ChatParentInfoVC *parentInfoVC = [[ChatParentInfoVC alloc] init];
                [parentInfoVC setParentInfo:self.parentInfo];
                [parentInfoVC setChildID:self.toObjid];
                [self.navigationController pushViewController:parentInfoVC animated:YES];
            }
        }
    }
    else{
        if(row == 0){
            
        }
        else if(row == 1){
            SearchChatMessageVC *searchVC = [[SearchChatMessageVC alloc] init];
            [self.navigationController pushViewController:searchVC animated:YES];
        }
        else if(row == 2){
            @weakify(self)
            LGAlertView *alertView = [LGAlertView alertViewWithTitle:@"确定要清空聊天记录吗?" message:nil style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setDestructiveHandler:^(LGAlertView *alertView) {
                @strongify(self)
                if(self.clearChatRecordCallback){
                    self.clearChatRecordCallback(^(BOOL success){
                        if(success){
                            [ProgressHUD showSuccess:@"聊天记录已清除"];
                        }
                    });
                }
            }];
            [alertView showAnimated:YES completionHandler:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
