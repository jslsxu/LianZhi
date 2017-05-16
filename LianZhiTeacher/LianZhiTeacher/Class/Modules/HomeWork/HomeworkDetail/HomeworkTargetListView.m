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
        
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]];
        [_arrowImageView setOrigin:CGPointMake(8, (self.contentView.height - _arrowImageView.height) / 2)];
        [self.contentView addSubview:_arrowImageView];
        
        _logoView = [[LogoView alloc] initWithRadius:18];
        [_logoView setOrigin:CGPointMake(8 + _arrowImageView.right, (56 - _logoView.height) / 2)];
        [self.contentView addSubview:_logoView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:_titleLabel];
        
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        [_redDot setBackgroundColor:[UIColor colorWithHexString:@"e00909"]];
        [_redDot.layer setCornerRadius:2];
        [_redDot.layer setMasksToBounds:YES];
        [_redDot setHidden:YES];
        [self.contentView addSubview:_redDot];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_stateLabel setFont:[UIFont systemFontOfSize:12]];
        [_stateLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self.contentView addSubview:_stateLabel];
        
        _alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alertButton setImage:[UIImage imageNamed:@"homeworkAlert"] forState:UIControlStateNormal];
        [_alertButton setSize:CGSizeMake(40, 20)];
        [_alertButton addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_alertButton];
        
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

- (void)alert{
    if(self.alertCallback){
        self.alertCallback();
    }
}

- (void)setExpand:(BOOL)expand{
    _expand = expand;
    CGAffineTransform transform = _expand ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^{
        _arrowImageView.transform = transform;
    }];
}

- (void)setEtype:(BOOL)etype{
    _etype = etype;
    [_alertButton setHidden:!_etype];
}

- (void)setClassInfo:(HomeworkClassStatus *)classInfo{
    _classInfo = classInfo;

    [_logoView sd_setImageWithURL:[NSURL URLWithString:_classInfo.logo]];
    [_alertButton setEnabled:_classInfo.send_notice];
    [_alertButton setOrigin:CGPointMake(self.width - 10 - _alertButton.width, (self.height - _alertButton.height) / 2)];
    [_titleLabel setFrame:CGRectMake(_logoView.right + 15, 0, _stateLabel.left - 10 - (_logoView.right + 15), self.height)];
    [_titleLabel setText:_classInfo.name];
    [_titleLabel sizeToFit];
    [_titleLabel setOrigin:CGPointMake(_logoView.right + 8, _logoView.top)];
    
    [_redDot setHidden:![_classInfo hasUnread]];
    [_redDot setCenter:CGPointMake(_titleLabel.right + 10, _titleLabel.centerY)];
    
    NSMutableAttributedString *stateStr = [[NSMutableAttributedString alloc] initWithString:@"发送:"];
    [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_classInfo.send) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
    if(self.etype){
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人 回复:" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_classInfo.reply) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人 批阅:" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_classInfo.mark) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
    }
    else{
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人 已读:" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_classInfo.read) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
    }
    [_stateLabel setAttributedText:stateStr];
    [_stateLabel sizeToFit];
    [_stateLabel setOrigin:CGPointMake(_logoView.right + 8, _logoView.bottom - _stateLabel.height)];
}


@end

@implementation HomeworkSendTargetCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _avatarView = [[AvatarView alloc] initWithRadius:18];
        [_avatarView setOrigin:CGPointMake(24, (56 - _avatarView.height) / 2)];
        [self addSubview:_avatarView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_titleLabel];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_stateLabel setFont:[UIFont systemFontOfSize:13]];
        //        [_stateLabel setHidden:YES];
        [self addSubview:_stateLabel];
        
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        [_redDot setBackgroundColor:[UIColor colorWithHexString:@"e00909"]];
        [_redDot.layer setCornerRadius:2];
        [_redDot.layer setMasksToBounds:YES];
        [_redDot setHidden:YES];
        [self addSubview:_redDot];
        
        _mobileImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"call_telephone"]];
        [_mobileImageView setOrigin:CGPointMake(self.width - 10 - _mobileImageView.width, (56 - _mobileImageView.height) / 2)];
        [_mobileImageView setHidden:YES];
        [self addSubview:_mobileImageView];
        
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]];
        [_rightArrow setOrigin:CGPointMake(self.width - 10 - _rightArrow.width, (56 - _rightArrow.height) / 2)];
        [_rightArrow setHidden:YES];
        [self addSubview:_rightArrow];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(12, self.height - kLineHeight, self.width - 12, kLineHeight)];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

- (void)setUserInfo:(HomeworkStudentInfo *)userInfo{
    _userInfo = userInfo;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_userInfo.student.avatar] placeholderImage:nil];
    [_titleLabel setText:_userInfo.student.name];
    [_titleLabel sizeToFit];
    [_titleLabel setOrigin:CGPointMake(_avatarView.right + 8, (56 - _titleLabel.height) / 2)];
    [_redDot setHidden:!_userInfo.unread_t];
    [_redDot setCenter:CGPointMake(_titleLabel.right + 10, 56 / 2)];
    [_mobileImageView setHidden:YES];
    [_rightArrow setHidden:YES];
    [_stateLabel setHidden:NO];
    CGFloat spaceXEnd = self.width;
    switch (_userInfo.status) {
        case HomeworkStudentStatusUnread:
            [_stateLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
            [_stateLabel setText:@"未读"];
            [_mobileImageView setHidden:NO];
            spaceXEnd = _mobileImageView.left - 5;
            break;
        case HomeworkStudentStatusRead:
            [_stateLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
            [_stateLabel setText:@"已读"];
            [_mobileImageView setHidden:!self.etype];
            spaceXEnd = _mobileImageView.left - 5;
            break;
        case HomeworkStudentStatusHasMark:
            [_stateLabel setTextColor:kCommonTeacherTintColor];
            [_stateLabel setText:@"已批阅"];
            [_rightArrow setHidden:NO];
            spaceXEnd = _rightArrow.left - 5;
            break;
        case HomeworkStudentStatusWaitMark:
            [_stateLabel setTextColor:[UIColor colorWithHexString:@"5ba110"]];
            [_stateLabel setText:@"等待老师批阅"];
            [_rightArrow setHidden:NO];
            spaceXEnd = _rightArrow.left - 5;
            break;
        default:
            break;
    }
    [_stateLabel sizeToFit];
    [_stateLabel setOrigin:CGPointMake(spaceXEnd - _stateLabel.width, (56 - _stateLabel.height) / 2)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    return @(56);
}

@end


@interface HomeworkTargetListView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UIView*    bottomView;
@property (nonatomic, strong)NSArray *targetArray;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableDictionary* expandDic;
@property (nonatomic, strong)UIButton* alertAllButton;
@end

@implementation HomeworkTargetListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 60, self.width, 60)];
        [self setupBottomView:_bottomView];
        [_bottomView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [_bottomView setHidden:YES];
        [self addSubview:_bottomView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, _bottomView.top) style:UITableViewStylePlain];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [self addSubview:_tableView];
        
        @weakify(self)
        [_tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self loadTargets];
        }]];
    }
    return self;
}

- (void)setupBottomView:(UIView *)viewParent{
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewParent.width, kLineHeight)];
    [topLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:topLine];
    
    UIButton *alertAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alertAllButton addTarget:self action:@selector(alertAll) forControlEvents:UIControlEventTouchUpInside];
    [alertAllButton setFrame:CGRectMake(10, 10, (viewParent.width - 10 * 3) / 2, viewParent.height - 10 * 2)];
    [alertAllButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:alertAllButton.size cornerRadius:4] forState:UIControlStateNormal];
    [alertAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alertAllButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [alertAllButton setTitle:@"提醒全部" forState:UIControlStateNormal];
    [viewParent addSubview:alertAllButton];
    self.alertAllButton = alertAllButton;
    
    UIButton *markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [markButton addTarget:self action:@selector(markHomework) forControlEvents:UIControlEventTouchUpInside];
    [markButton setFrame:CGRectMake(alertAllButton.right + 10, 10, (viewParent.width - 10 * 3) / 2, viewParent.height - 10 * 2)];
    [markButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:alertAllButton.size cornerRadius:4] forState:UIControlStateNormal];
    [markButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [markButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [markButton setTitle:@"批阅作业" forState:UIControlStateNormal];
    [viewParent addSubview:markButton];

}

- (void)loadTargets{
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/classes" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"eid" : self.homeworkItem.eid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *dataWrapper = [responseObject getDataWrapperForKey:@"classes"];
        wself.targetArray = [HomeworkClassStatus nh_modelArrayWithJson:dataWrapper.data];
        [[wself.tableView mj_header] endRefreshing];
        [wself.bottomView setHidden:NO];
        [wself.alertAllButton setEnabled:[wself canAlertAll]];
    } fail:^(NSString *errMsg) {
         [[wself.tableView mj_header] endRefreshing];
    }];
}

- (BOOL)canAlertAll{
    for (HomeworkClassStatus *classStatus in self.targetArray) {
        if(classStatus.send_notice){
            return YES;
        }
    }
    return NO;
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    if(_homeworkItem.etype){
        [_tableView setFrame:CGRectMake(0, 0, self.width, _bottomView.top)];
    }
    else{
        [_bottomView setHidden:YES];
        [_tableView setFrame:self.bounds];
    }
    [self loadTargets];
}

- (void)setTargetArray:(NSArray *)targetArray{
    _targetArray = targetArray;
    BOOL expand = NO;
    if(_targetArray.count == 1){
        expand = YES;
        HomeworkClassStatus* group = _targetArray[0];
        NSString *groupID = group.classID;
        if(groupID.length > 0 && !self.expandDic[groupID]){
            [self.expandDic setValue:@(expand) forKey:groupID];
        }
    }
    BOOL hasNew = NO;
    for (NSInteger i = 0; i < _targetArray.count; i++) {
        HomeworkClassStatus* group = _targetArray[i];
        if([group hasUnread]){
            hasNew = YES;
        }
    }
    [self setHasNew:hasNew];
    [_tableView reloadData];
    [self.bottomView setHidden:NO];
}

- (NSMutableDictionary *)expandDic{
    if(_expandDic == nil){
        _expandDic = [NSMutableDictionary dictionary];
    }
    return _expandDic;
}


- (void)markHomework{
    __weak typeof(self) wself = self;
    if([self.homeworkItem etype]){
        NSArray *homeworkArray = [self studentWairMarkHomeworkArray];
        if([homeworkArray count] > 0){
            MarkHomeworkVC *markVC = [[MarkHomeworkVC alloc] init];
            [markVC setHomeworkItem:self.homeworkItem];
            [markVC setHomeworkArray:homeworkArray];
            [markVC setMarkFinishedCallback:^{
                [wself loadTargets];
            }];
            [CurrentROOTNavigationVC pushViewController:markVC animated:YES];
        }
        else{
            [ProgressHUD showHintText:@"没有可批阅的作业"];
        }
    }
    else{
        [ProgressHUD showHintText:@"没有可批阅的作业"];
    }
}

- (void)alertAll{
    BOOL canNoticie = NO;
    for (HomeworkClassStatus *classInfo in self.targetArray) {
        if(classInfo.send_notice){
            canNoticie = YES;
        }
    }
    if(canNoticie){
        __weak typeof(self) wself = self;
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"根据您所选的班级，通过APP通知和短信的形式，提醒未回复作业的学生家长尽快回复。1小时之内可以提醒一次。" style:LGAlertViewStyleAlert buttonTitles:@[@"提醒"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setButtonsTitleColor:kCommonTeacherTintColor];
        [alertView setCancelButtonTitleColor:kCommonTeacherTintColor];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            NSMutableString *class_ids = [[NSMutableString alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:wself.homeworkItem.eid forKey:@"eid"];
            for (HomeworkClassStatus *classInfo in wself.targetArray) {
                if([class_ids length] > 0){
                    [class_ids appendFormat:@",%@", classInfo.classID];
                }
                else{
                    [class_ids appendString:classInfo.classID];
                }
            }
            [params setValue:class_ids forKey:@"class_ids"];
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/send_notice" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:wself completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                for (HomeworkClassStatus *classInfo in wself.targetArray) {
                    classInfo.send_notice = NO;
                }
                [wself.tableView reloadData];
                [wself.alertAllButton setEnabled:[wself canAlertAll]];
                [ProgressHUD showHintText:@"提醒成功"];
            } fail:^(NSString *errMsg) {
                [ProgressHUD showHintText:errMsg];
            }];
        }];
        [alertView showAnimated:YES completionHandler:nil];
    }
    else{
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"在短时间内不可以重复提醒" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setCancelButtonTitleColor:kCommonTeacherTintColor];
        [alertView showAnimated:YES completionHandler:nil];
    }
}

- (void)notificationClass:(HomeworkClassStatus *)classInfo{
    if(classInfo.send_notice){
        __weak typeof(self) wself = self;
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"根据您所选的班级，通过APP通知和短信的形式，提醒未回复作业的学生家长尽快回复。1小时之内可以提醒一次。" style:LGAlertViewStyleAlert buttonTitles:@[@"提醒"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setButtonsTitleColor:kCommonTeacherTintColor];
        [alertView setCancelButtonTitleColor:kCommonTeacherTintColor];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:wself.homeworkItem.eid forKey:@"eid"];
            [params setValue:classInfo.classID forKey:@"class_ids"];
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/send_notice" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:wself completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                classInfo.send_notice = NO;
                [wself.tableView reloadData];
                [ProgressHUD showHintText:@"提醒成功"];
            } fail:^(NSString *errMsg) {
                [ProgressHUD showHintText:errMsg];
            }];
        }];
        [alertView showAnimated:YES completionHandler:nil];
        
    }
    else{
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"在短时间内不可以重复提醒" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setCancelButtonTitleColor:kCommonTeacherTintColor];
        [alertView showAnimated:YES completionHandler:nil];
    }
}

- (NSArray *)studentHomeworkArray{
    NSMutableArray *homeworkArray = [NSMutableArray array];
    for (HomeworkClassStatus *classStatus in self.targetArray) {
        for (HomeworkStudentInfo *studentInfo in classStatus.students) {
            if(studentInfo.status == HomeworkStudentStatusWaitMark || studentInfo.status == HomeworkStudentStatusHasMark){
                [homeworkArray addObject:studentInfo];
                [studentInfo setClassName:classStatus.name];
            }
        }
    }
    if([homeworkArray count] > 0){
        return homeworkArray;
    }
    return nil;
}

- (NSArray *)studentWairMarkHomeworkArray{
    NSMutableArray *homeworkArray = [NSMutableArray array];
    for (HomeworkClassStatus *classStatus in self.targetArray) {
        for (HomeworkStudentInfo *studentInfo in classStatus.students) {
            if(studentInfo.status == HomeworkStudentStatusWaitMark){
                [homeworkArray addObject:studentInfo];
                [studentInfo setClassName:classStatus.name];
            }
        }
    }
    if([homeworkArray count] > 0){
        return homeworkArray;
    }
    return nil;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.targetArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HomeworkClassStatus *classInfo = self.targetArray[section];
    NSString *groupID = classInfo.classID;
    BOOL expand = [[self.expandDic objectForKey:groupID] boolValue];
    if(expand)
        return [classInfo.students count];
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
    HomeworkClassStatus *classInfo = self.targetArray[section];
    [headerView setEtype:self.homeworkItem.etype];
    [headerView setClassInfo:classInfo];
    BOOL expand = [[self.expandDic objectForKey:classInfo.classID] boolValue];
    [headerView setExpand:expand];
    @weakify(self)
    [headerView setExpandCallback:^{
        @strongify(self)
        [self.expandDic setValue:@(!expand) forKey:classInfo.classID];
        [self.tableView reloadData];
    }];
    [headerView setAlertCallback:^{
        @strongify(self)
        [self notificationClass:classInfo];
    }];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"NotificationSendTargetCell";
    HomeworkSendTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[HomeworkSendTargetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    [cell setEtype:self.homeworkItem.etype];
    HomeworkClassStatus *classInfo = self.targetArray[indexPath.section];
    HomeworkStudentInfo *studentInfo = classInfo.students[indexPath.row];
    [cell setUserInfo:studentInfo];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeworkClassStatus *classInfo = self.targetArray[indexPath.section];
    HomeworkStudentInfo *studentInfo = classInfo.students[indexPath.row];
    if((studentInfo.status == HomeworkStudentStatusRead && self.homeworkItem.etype) || studentInfo.status == HomeworkStudentStatusUnread){
        NSMutableArray *familyArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < studentInfo.student.family.count; i++) {
            FamilyInfo *familyInfo = studentInfo.student.family[i];
            [familyArray addObject:[NSString stringWithFormat:@"%@: %@",familyInfo.relation, familyInfo.mobile]];
        }
        if([familyArray count] > 0){
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:familyArray cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setButtonsTitleColor:[UIColor colorWithHexString:@"28c4d8"]];
            [alertView setCancelButtonTitleColor:[UIColor colorWithHexString:@"28c4d8"]];
            [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                FamilyInfo *familyInfo = studentInfo.student.family[index];
                NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel://%@",familyInfo.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }];
            [alertView showAnimated:YES completionHandler:nil];
        }
    }
    else if( studentInfo.status == HomeworkStudentStatusWaitMark || studentInfo.status == HomeworkStudentStatusHasMark){
        if([self.homeworkItem etype]){
            __weak typeof(self) wself = self;
            NSArray *homeworkArray = [self studentHomeworkArray];
            NSInteger index = [homeworkArray indexOfObject:studentInfo];
            MarkHomeworkVC *markVC = [[MarkHomeworkVC alloc] init];
            [markVC setHomeworkItem:self.homeworkItem];
            [markVC setHomeworkArray:homeworkArray];
            if(index >= 0 && index < [homeworkArray count]){
                [markVC setCurIndex:index];
            }
            [markVC setMarkFinishedCallback:^{
                [wself loadTargets];
            }];
            [CurrentROOTNavigationVC pushViewController:markVC animated:YES];
        }
    }
}


@end
