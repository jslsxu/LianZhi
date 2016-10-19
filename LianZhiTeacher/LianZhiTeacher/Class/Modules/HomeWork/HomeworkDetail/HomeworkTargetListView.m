//
//  HomeworkTargetListView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkTargetListView.h"
#import "MarkHomeworkVC.h"
@implementation HomeworkTargetHeaderView

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
        [_stateLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self.contentView addSubview:_stateLabel];
        
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"expand_indicator"]];
        [_arrowImageView setCenter:CGPointMake(self.width - 10 - _arrowImageView.width / 2, self.contentView.height / 2)];
        [self.contentView addSubview:_arrowImageView];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(12, self.height - kLineHeight, self.width - 12, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self.contentView addSubview:sepLine];
        
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tapgesture];
        
    }
    return self;
}

- (void)onTap{
    if(self.expandCallback){
        self.expandCallback();
    }
}

- (void)setExpand:(BOOL)expand{
    _expand = expand;
    CGAffineTransform transform = _expand ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^{
        _arrowImageView.transform = transform;
    }];
}

- (void)setGroup:(id)group{
    _group = group;
    NSString *logo = nil;
    NSString *name;
    NSInteger total = 0;
    NSInteger readNum = 0;
    if([_group isKindOfClass:[ClassInfo class]]){
        ClassInfo *classInfo = (ClassInfo *)_group;
        logo = classInfo.logo;
        name = classInfo.name;
        total = classInfo.sent_num;
        readNum = classInfo.read_num;
    }
    else if([_group isKindOfClass:[TeacherGroup class]]){
        TeacherGroup *teacherGroup = (TeacherGroup *)_group;
        logo = teacherGroup.logo;
        name = teacherGroup.groupName;
        total = teacherGroup.sent_num;
        readNum = teacherGroup.read_num;
    }
    
    [_logoView sd_setImageWithURL:[NSURL URLWithString:logo]];
    NSMutableAttributedString *stateStr = [[NSMutableAttributedString alloc] initWithString:@"发送:"];
    [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(total) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
    [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人 已读:" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
    [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(readNum) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
    [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
    [_stateLabel setAttributedText:stateStr];
    [_stateLabel sizeToFit];
    [_stateLabel setOrigin:CGPointMake(_arrowImageView.left - 10 - _stateLabel.width, (self.height - _stateLabel.height) / 2)];
    
    [_titleLabel setFrame:CGRectMake(_logoView.right + 15, 0, _stateLabel.left - 10 - (_logoView.right + 15), self.height)];
    [_titleLabel setText:name];
}


@end

@implementation HomeworkSendTargetCell
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
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(12, self.height - kLineHeight, self.width - 12, kLineHeight)];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

- (void)setUserInfo:(UserInfo *)userInfo{
    _userInfo = userInfo;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:nil];
    [_avatarView setStatus:_userInfo.actived ? @"" : @"未下载"];
    [_titleLabel setText:_userInfo.name];
    [_titleLabel sizeToFit];
    [_titleLabel setOrigin:CGPointMake(_avatarView.right + 15, (56 - _titleLabel.height) / 2)];
    
    if(_userInfo.has_read){
        [_stateImageView setHidden:YES];
        [_stateLabel setHidden:YES];
    }
    else{
        [_stateImageView setHidden:NO];
        [_stateLabel setHidden:NO];
    }
    [_stateImageView setOrigin:CGPointMake(self.width - 10 - _stateImageView.width, (56 - _stateImageView.height) / 2)];
    [_stateLabel setOrigin:CGPointMake(_stateImageView.left - 10 - _stateLabel.width, (56 - _stateLabel.height) / 2)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    return @(56);
}

@end


@interface HomeworkTargetListView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSArray *targetArray;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableDictionary* expandDic;
@end

@implementation HomeworkTargetListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 60, self.width, 60)];
        [self setupBottomView:bottomView];
        [bottomView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:bottomView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, bottomView.top) style:UITableViewStylePlain];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [self addSubview:_tableView];
        
        @weakify(self)
        [_tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            NSString *nid = self.homeworkItem.hid;
            if(nid){
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/my_send_detail" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"id" : self.homeworkItem.hid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    [self.tableView.mj_header endRefreshing];
                    HomeworkItem *homeworkItem = [HomeworkItem nh_modelWithJson:responseObject.data];
                    self.homeworkItem = homeworkItem;
                    if(self.homeworkRefreshCallback){
                        self.homeworkRefreshCallback(self.homeworkItem);
                    }
                } fail:^(NSString *errMsg) {
                    [self.tableView.mj_header endRefreshing];
                }];
            }
            
        }]];
    }
    return self;
}

- (void)setupBottomView:(UIView *)viewParent{
    UIButton *alertAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alertAllButton addTarget:self action:@selector(alertAll) forControlEvents:UIControlEventTouchUpInside];
    [alertAllButton setFrame:CGRectMake(10, 10, (viewParent.width - 10 * 3) / 2, viewParent.height - 10 * 2)];
    [alertAllButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:alertAllButton.size cornerRadius:4] forState:UIControlStateNormal];
    [alertAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alertAllButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [alertAllButton setTitle:@"提醒全部" forState:UIControlStateNormal];
    [viewParent addSubview:alertAllButton];
    
    UIButton *markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [markButton addTarget:self action:@selector(markHomework) forControlEvents:UIControlEventTouchUpInside];
    [markButton setFrame:CGRectMake(alertAllButton.right + 10, 10, (viewParent.width - 10 * 3) / 2, viewParent.height - 10 * 2)];
    [markButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:alertAllButton.size cornerRadius:4] forState:UIControlStateNormal];
    [markButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [markButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [markButton setTitle:@"批阅作业" forState:UIControlStateNormal];
    [viewParent addSubview:markButton];
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    [self setTargetArray:_homeworkItem.classes];
}

- (void)setTargetArray:(NSArray *)targetArray{
    _targetArray = targetArray;
    BOOL expand = NO;
    if(_targetArray.count == 1){
        expand = YES;
    }
    for (NSInteger i = 0; i < _targetArray.count; i++) {
        NSString *groupID = [self groupIDForSection:i];
        if(groupID.length > 0){
            [self.expandDic setValue:@(expand) forKey:groupID];
        }
    }
    [_tableView reloadData];
}

- (NSMutableDictionary *)expandDic{
    if(_expandDic == nil){
        _expandDic = [NSMutableDictionary dictionary];
    }
    return _expandDic;
}

- (NSString *)groupIDForSection:(NSInteger)section{
    NSString *groupID = nil;
    id group = _targetArray[section];
    if([group isKindOfClass:[ClassInfo class]]){
        ClassInfo *classInfo = (ClassInfo *)group;
        groupID = classInfo.classID;
    }
    else if([group isKindOfClass:[TeacherGroup class]]){
        TeacherGroup *teacherGroup = (TeacherGroup *)group;
        groupID = teacherGroup.groupID;
    }
    return groupID;
}

- (NSArray *)userArrayForSection:(NSInteger)section{
    NSArray *userArray = nil;
    id group = self.targetArray[section];
    if([group isKindOfClass:[ClassInfo class]]){
        ClassInfo *classInfo = (ClassInfo *)group;
        userArray = classInfo.students;
    }
    else if([group isKindOfClass:[TeacherGroup class]]){
        TeacherGroup *teacherGroup = (TeacherGroup *)group;
        userArray = teacherGroup.teachers;
    }
    return userArray;
}

- (void)markHomework{
    MarkHomeworkVC *markHomeworkVC = [[MarkHomeworkVC alloc] init];
    [CurrentROOTNavigationVC pushViewController:markHomeworkVC animated:YES];
}

- (void)alertAll{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.targetArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *groupID = [self groupIDForSection:section];
    BOOL expand = [[self.expandDic objectForKey:groupID] boolValue];
    if(expand)
        return [self userArrayForSection:section].count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HomeworkSendTargetCell cellHeight:nil cellWidth:tableView.width].floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *reuseID = @"NotificationTargetHeaderView";
    HomeworkTargetHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID];
    if(headerView == nil){
        headerView = [[HomeworkTargetHeaderView alloc] initWithReuseIdentifier:reuseID];
    }
    [headerView setGroup:self.targetArray[section]];
    NSString *groupID = [self groupIDForSection:section];
    BOOL expand = [[self.expandDic objectForKey:groupID] boolValue];
    [headerView setExpand:expand];
    @weakify(self)
    [headerView setExpandCallback:^{
        @strongify(self)
        [self.expandDic setValue:@(!expand) forKey:groupID];
        [self.tableView reloadData];
    }];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"NotificationSendTargetCell";
    HomeworkSendTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[HomeworkSendTargetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeworkSendTargetCell *curCell = (HomeworkSendTargetCell *)cell;
    UserInfo *userInfo = [[self userArrayForSection:indexPath.section] objectAtIndex:indexPath.row];
    [curCell setUserInfo:userInfo];
    if(userInfo.has_read){
        [curCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else{
        [curCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfo *userInfo = [[self userArrayForSection:indexPath.section] objectAtIndex:indexPath.row];
    if(!userInfo.has_read){
        if([userInfo isKindOfClass:[StudentInfo class]]){
            StudentInfo *studentInfo = (StudentInfo *)userInfo;
            NSMutableArray *familyArray = [NSMutableArray arrayWithCapacity:0];
            for (NSInteger i = 0; i < studentInfo.family.count; i++) {
                FamilyInfo *familyInfo = studentInfo.family[i];
                [familyArray addObject:[NSString stringWithFormat:@"%@: %@",familyInfo.relation, familyInfo.mobile]];
            }
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:familyArray cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setButtonsTitleColor:[UIColor colorWithHexString:@"28c4d8"]];
            [alertView setCancelButtonTitleColor:[UIColor colorWithHexString:@"28c4d8"]];
            [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                FamilyInfo *familyInfo = studentInfo.family[index];
                NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel://%@",familyInfo.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }];
            [alertView showAnimated:YES completionHandler:nil];
        }
        else{
            TeacherInfo *teacherInfo = (TeacherInfo *)userInfo;
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[[NSString stringWithFormat:@"%@: %@",teacherInfo.name, teacherInfo.mobile]] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setButtonsTitleColor:[UIColor colorWithHexString:@"28c4d8"]];
            [alertView setCancelButtonTitleColor:[UIColor colorWithHexString:@"28c4d8"]];
            [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel://%@",teacherInfo.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }];
            [alertView showAnimated:YES completionHandler:nil];
        }
    }
}


@end
