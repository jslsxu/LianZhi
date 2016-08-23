//
//  NotificationTargetSelectVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationMemberSelectVC.h"

#define kNotificationClassArrayKey      @"NotificationClassArray"
#define kNotificationGroupArrayKey      @"NotificationGroupArray"

@implementation NotificationMemberHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self){
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        _stateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray_expand_indicator"]];
        [self addSubview:_stateImageView];
        
        _logoView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_logoView.layer setCornerRadius:18];
        [_logoView.layer setMasksToBounds:YES];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_numLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_numLabel setFont:[UIFont systemFontOfSize:14]];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_numLabel];
        
        _allSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectButton setImage:[UIImage imageNamed:@"ic_xuan_selected"] forState:UIControlStateSelected];
        [_allSelectButton setImage:[UIImage imageNamed:@"send_sms_off"] forState:UIControlStateNormal];
        [_allSelectButton addTarget:self action:@selector(onAllSelectClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_allSelectButton];
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_bottomLine setBackgroundColor:kSepLineColor];
        [self addSubview:_bottomLine];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderClick)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setGroupInfo:(id)groupInfo{
    _groupInfo = groupInfo;
    if([_groupInfo isKindOfClass:[ClassInfo class]]){
        ClassInfo *classInfo = (ClassInfo *)_groupInfo;
        [_logoView sd_setImageWithURL:[NSURL URLWithString:classInfo.logo] placeholderImage:nil];
        [_nameLabel setText:classInfo.name];
        [_allSelectButton setSelected:classInfo.selected];
    }
    else{
        TeacherGroup *teacherGroup = (TeacherGroup *)_groupInfo;
        [_logoView sd_setImageWithURL:[NSURL URLWithString:teacherGroup.logo] placeholderImage:nil];
        [_nameLabel setText:teacherGroup.groupName];
        [_allSelectButton setSelected:teacherGroup.selected];
    }
}

- (void)setExpand:(BOOL)expand{
    _expand = expand;
    [UIView animateWithDuration:0.3 animations:^{
        if(_expand)
            [_stateImageView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        else{
            [_stateImageView setTransform:CGAffineTransformIdentity];
        }
    }];
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [_stateImageView setCenter:CGPointMake(25, self.height / 2)];
    [_logoView setFrame:CGRectMake(50, (self.height - 36) / 2, 36, 36)];
    [_allSelectButton setFrame:CGRectMake(self.width - 40, 0, 40, self.height)];
    [_numLabel setFrame:CGRectMake(_allSelectButton.left - 50, 0, 50, self.height)];
    [_nameLabel setFrame:CGRectMake(_logoView.right + 10, 0, _numLabel.left - 10 - (_logoView.right + 10), self.height)];
    [_bottomLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
}

- (void)onHeaderClick{
    if(self.headerExpandClick){
        self.headerExpandClick();
    }
}

- (void)onAllSelectClicked{
    if(self.allSelectClick){
        self.allSelectClick();
    }
}

@end

@implementation NotificationMemberItemCell
+ (CGFloat)cellHeight{
    return 60;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
        [_stateImageView setContentMode:UIViewContentModeCenter];
        [_stateImageView setImage:[UIImage imageNamed:@"send_sms_off"]];
        [self addSubview:_stateImageView];
        
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_avatarView.layer setCornerRadius:18];
        [_avatarView.layer setMasksToBounds:YES];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setUserInfo:(UserInfo *)userInfo{
    _userInfo = userInfo;
    [_stateImageView setImage:[UIImage imageNamed:_userInfo.selected ? @"send_sms_on" : @"send_sms_off"]];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:nil];
    [_avatarView setFrame:CGRectMake(50, (60 - 36) / 2, 36, 36)];
    [_nameLabel setText:_userInfo.name];
    [_nameLabel setFrame:CGRectMake(_avatarView.right + 10, 0, self.width - 10 - (_avatarView.right + 10), self.height)];
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
}

@end

@interface NotificationMemberView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableDictionary *expandDictionary;
@end

@implementation NotificationMemberView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSectionHeaderHeight:56];
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
        [self addSubview:_tableView];
        
        _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 44, self.width, 44)];
        [_actionView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        
        _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllButton setFrame:CGRectMake(0, 0, 60, _actionView.height)];
        [_selectAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectAllButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_selectAllButton addTarget:self action:@selector(onSelectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_selectAllButton];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_actionView.width / 2, 0, _actionView.width / 2 - 10, _actionView.height)];
        [_stateLabel setFont:[UIFont systemFontOfSize:16]];
        [_stateLabel setTextColor:[UIColor whiteColor]];
        [_stateLabel setTextAlignment:NSTextAlignmentRight];
        [_stateLabel setText:@"已选择0人"];
        [_actionView addSubview:_stateLabel];
        
        [self addSubview:_actionView];
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    self.expandDictionary = [NSMutableDictionary dictionary];
    BOOL expand = NO;
    if(_dataSource.count == 1){
        expand = YES;
    }
    for (id groupInfo in _dataSource) {
        if([groupInfo isKindOfClass:[ClassInfo class]]){
            [self.expandDictionary setValue:@(expand) forKey:[(ClassInfo *)groupInfo classID]];
        }
        else if([groupInfo isKindOfClass:[TeacherGroup class]]){
            [self.expandDictionary setValue:@(expand) forKey:[(TeacherGroup *)groupInfo groupID]];
        }
    }
    [self updateSelectToolBar];
}

- (void)onSelectButtonClicked{
    BOOL selectAll = [[_selectAllButton titleForState:UIControlStateNormal] isEqualToString:@"全选"];
    
    if(self.userType == UserTypeStudent){
        for (ClassInfo *classInfo in self.dataSource) {
            classInfo.selected = selectAll;
            for (StudentInfo *studentInfo in classInfo.students) {
                studentInfo.selected = selectAll;
            }
        }
    }
    else{
        for (TeacherGroup *teacherGroup in self.dataSource) {
            teacherGroup.selected = selectAll;
            for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
                teacherInfo.selected = selectAll;
            }
        }
    }
    [self updateSelectToolBar];
    [_tableView reloadData];
}

- (BOOL)expandForSection:(NSInteger)section{
    BOOL expand = NO;
    if(self.userType == UserTypeStudent){
        ClassInfo *classInfo = (ClassInfo *)self.dataSource[section];
        expand = [[self.expandDictionary valueForKey:classInfo.classID] boolValue];
    }
    else{
        TeacherGroup *teacherGroup = (TeacherGroup *)self.dataSource[section];
        expand = [[self.expandDictionary valueForKey:teacherGroup.groupID] boolValue];
    }
    return expand;

}

- (void)updateSelectToolBar{
    BOOL selectAll = YES;
    NSInteger selectNum = 0;
    if(self.userType == UserTypeStudent){
        for (ClassInfo *classInfo in self.dataSource) {
            if(!classInfo.selected){
                selectAll = NO;
            }
            for (StudentInfo *studentInfo in classInfo.students) {
                if(studentInfo.selected)
                    selectNum ++;
            }
        }
    }
    else{
        for (TeacherGroup *teacherGroup in self.dataSource) {
            if(!teacherGroup.selected){
                selectAll = NO;
            }
            for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
                if(teacherInfo.selected){
                    selectNum++;
                }
            }
        }
    }
    [_selectAllButton setTitle:selectAll ? @"反选" : @"全选" forState:UIControlStateNormal];
    [_stateLabel setText:[NSString stringWithFormat:@"已选择%zd人",selectNum]];
}
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.userType == UserTypeStudent){
        ClassInfo *classInfo = [self.dataSource objectAtIndex:section];
        BOOL expand = [[self.expandDictionary valueForKey:classInfo.classID] boolValue];
        return expand ? classInfo.students.count : 0;
    }
    else{
        TeacherGroup *group = [self.dataSource objectAtIndex:section];
        BOOL expand = [[self.expandDictionary valueForKey:group.groupID] boolValue];
        return expand ? group.teachers.count : 0;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [NotificationMemberItemCell cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    id dataItem = self.dataSource[section];
    static NSString *reuseID = @"NotificationMemberHeaderView";
    NotificationMemberHeaderView *headerView  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID];
    if(!headerView){
        headerView = [[NotificationMemberHeaderView alloc] initWithReuseIdentifier:reuseID];
    }
    [headerView setGroupInfo:dataItem];
    @weakify(self)
    [headerView setHeaderExpandClick:^{
        @strongify(self)
        BOOL expand = NO;
        NSString *key;
        if(self.userType == UserTypeStudent){
            ClassInfo *classInfo = (ClassInfo *)dataItem;
            key = classInfo.classID;
        }
        else{
            TeacherGroup *teacherGroup = (TeacherGroup *)dataItem;
            key = teacherGroup.groupID;
        }
        expand = [[self.expandDictionary valueForKey:key] boolValue];
        [self.expandDictionary setValue:@(!expand) forKey:key];
        [tableView reloadData];
    }];
    [headerView setAllSelectClick:^{
        @strongify(self)
        if(self.userType == UserTypeStudent){
            ClassInfo *classInfo = (ClassInfo *)dataItem;
            [classInfo setSelected:!classInfo.selected];
            for (StudentInfo *studentInfo in classInfo.students) {
                [studentInfo setSelected:classInfo.selected];
            }
        }
        else{
            TeacherGroup *teacherGroup = (TeacherGroup *)dataItem;
            [teacherGroup setSelected:!teacherGroup.selected];
            for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
                [teacherInfo setSelected:teacherGroup.selected];
            }
        }
        [self updateSelectToolBar];
        [tableView reloadData];
    }];
    BOOL expand = NO;
    if(self.userType == UserTypeStudent){
        ClassInfo *classInfo = (ClassInfo *)dataItem;
        expand = [[self.expandDictionary valueForKey:classInfo.classID] boolValue];
    }
    else{
        TeacherGroup *teacherGroup = (TeacherGroup *)dataItem;
        expand = [[self.expandDictionary valueForKey:teacherGroup.groupID] boolValue];
    }
    [headerView setExpand:expand];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"NotificationMemberItemCell";
    NotificationMemberItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell){
        cell = [[NotificationMemberItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationMemberItemCell *itemCell = (NotificationMemberItemCell *)cell;
    UserInfo *userInfo;
    if(self.userType == UserTypeStudent){
        ClassInfo *classInfo = [self.dataSource objectAtIndex:indexPath.section];
        userInfo = classInfo.students[indexPath.row];
    }
    else{
        TeacherGroup *group = [self.dataSource objectAtIndex:indexPath.section];
        userInfo = group.teachers[indexPath.row];
    }
    [itemCell setUserInfo:userInfo];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(self.userType == UserTypeStudent){
        ClassInfo *classInfo = [self.dataSource objectAtIndex:section];
        StudentInfo *studentInfo = classInfo.students[row];
        [studentInfo setSelected:!studentInfo.selected];
        BOOL allSelected = YES;
        for (StudentInfo *stuInfo in classInfo.students) {
            if(!stuInfo.selected){
                allSelected = NO;
            }
        }
        [classInfo setSelected:allSelected];
    }
    else{
        TeacherGroup *group = [self.dataSource objectAtIndex:section];
        TeacherInfo *teacherInfo = group.teachers[row];
        [teacherInfo setSelected:!teacherInfo.selected];
        BOOL allSelected = YES;
        for (teacherInfo in group.teachers) {
            if(!teacherInfo.selected){
                allSelected = NO;
            }
        }
        [group setSelected:allSelected];
    }
    [self updateSelectToolBar];
    [tableView reloadData];
}

@end

@interface NotificationMemberSelectVC ()
@property (nonatomic, strong)NSArray*    classArray;
@property (nonatomic, strong)NSArray*    groupArray;
@property (nonatomic, strong)NSArray*    originalSourceArray;
@end

@implementation NotificationMemberSelectVC

- (instancetype)initWithOriginalArray:(NSArray *)sourceArray{
    self = [super init];
    if(self){
        self.originalSourceArray = sourceArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *classArray = [NSMutableArray array];
    for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.classes) {
        NSDictionary *classDic = [classInfo modelToJSONObject];
        ClassInfo *sourceClassInfo = [ClassInfo modelWithJSON:classDic];
        [classArray addObject:sourceClassInfo];
    }
    self.classArray = classArray;
    
    NSMutableArray *groupArray = [NSMutableArray array];
    for (TeacherGroup *group in [UserCenter sharedInstance].curSchool.groups) {
        NSDictionary *groupDic = [group modelToJSONObject];
        TeacherGroup *sourceGroup = [TeacherGroup modelWithJSON:groupDic];
        [groupArray addObject:sourceGroup];
    }
    self.groupArray = groupArray;
    
    for (ClassInfo *classInfo in self.classArray) {
        classInfo.selected = NO;
        for (StudentInfo *studentInfo in classInfo.students) {
            studentInfo.selected = NO;
        }
    }
    for (TeacherGroup *group in self.groupArray) {
        group.selected = NO;
        for (TeacherInfo *teacherInfo in group.teachers) {
            teacherInfo.selected = NO;
        }
    }
    _segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"家长",@"同事"]];
    [_segmentCtrl setSelectedSegmentIndex:0];
    [_segmentCtrl setWidth:120];
    [_segmentCtrl addTarget:self action:@selector(onValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:_segmentCtrl];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onConfirm)];
    
    _studentView = [[NotificationMemberView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_studentView setUserType:UserTypeStudent];
    [self.view addSubview:_studentView];
    
    _teacherView = [[NotificationMemberView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_teacherView setUserType:UserTypeTeacher];
    [_teacherView setHidden:YES];
    [self.view addSubview:_teacherView];
    
    [self reloadData];
}

- (BOOL)target:(NSString *)targetID isInSource:(NSArray *)sourceArray{
    for (id itemInfo in sourceArray) {
        if([itemInfo isKindOfClass:[StudentInfo class]]){
            StudentInfo *studentInfo = (StudentInfo *)itemInfo;
            if([studentInfo.uid isEqualToString:targetID])
                return YES;
        }
        else{
            TeacherInfo *teacherInfo = (TeacherInfo *)itemInfo;
            if([teacherInfo.uid isEqualToString:targetID])
                return YES;
        }
    }
    return NO;
}

- (void)reloadData{
    for (ClassInfo *classInfo in self.classArray) {
        BOOL allSelected = YES;
        for (StudentInfo *studentInfo in classInfo.students) {
            studentInfo.selected = [self target:studentInfo.uid isInSource:self.originalSourceArray];
            if(!studentInfo.selected){
                allSelected = NO;
            }
        }
        classInfo.selected = allSelected;
    }
    
    for (TeacherGroup *group in self.groupArray) {
        BOOL allSelected = YES;
        for (TeacherInfo *teacherInfo in group.teachers) {
            teacherInfo.selected = [self target:teacherInfo.uid isInSource:self.originalSourceArray];
            if(!teacherInfo.selected){
                allSelected = NO;
            }
        }
        group.selected = allSelected;
    }

    [_studentView setDataSource:self.classArray];
    [_teacherView setDataSource:self.groupArray];
}

- (void)onValueChanged{
    NSInteger index = _segmentCtrl.selectedSegmentIndex;
    [_studentView setHidden:index != 0];
    [_teacherView setHidden:index != 1];
}

#pragma mark - Actions
- (void)onConfirm{
    if(self.selectCompletion){
        self.selectCompletion(self.classArray, self.groupArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
