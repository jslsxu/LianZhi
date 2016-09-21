//
//  NotificationTargetSelectVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NotificationTargetSelectVC.h"
#import "NotificationClassStudentsVC.h"
#import "NotificationGroupMemberVC.h"
@implementation NotificationTargetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setFrame:CGRectMake(20, 0, 20, self.height)];
        [_checkButton setImage:[UIImage imageNamed:@"ControlDefault"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"ControlSelectAll"] forState:UIControlStateSelected];
        [self addSubview:_checkButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_checkButton.right + 10, 0, 200, self.height)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"767676"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
        
        [self setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [_nameLabel setText:_classInfo.name];
}
@end

@implementation NotificationGroupHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setFrame:CGRectMake(20, 0, 20, self.height)];
        [_checkButton setUserInteractionEnabled:NO];
        [self addSubview:_checkButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_checkButton.right + 10, 0, 200, 50)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];

        [self setSelectType:SelectTypeNone];
    }
    return self;
}

- (void)setSelectType:(NSInteger)selectType
{
    _selectType = selectType;
    NSString *imageStr = nil;
    if(_selectType == SelectTypeNone)
        imageStr = @"ControlDefault";
    else if(_selectType == SelectTypePart)
        imageStr = @"ControlSelectPart";
    else
        imageStr = @"ControlSelectAll";
    [_checkButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
}

@end

@interface NotificationTargetSelectVC ()
@property (nonatomic, strong)NSArray *classArray;
@property (nonatomic, strong)NSArray *groupArray;
@end

@implementation NotificationTargetSelectVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息通知";
//    
//    NSMutableArray *classArray = [NSMutableArray array];
//    if([UserCenter sharedInstance].curSchool.classes.count > 0)
//    {
//        NSMutableDictionary *group = [NSMutableDictionary dictionary];
//        [group setValue:@"我教授的班" forKey:@"groupName"];
//        [group setValue:[NSArray arrayWithArray:[UserCenter sharedInstance].curSchool.classes] forKey:@"groupArray"];
//        [classArray addObject:group];
//    }
//    
//    if([UserCenter sharedInstance].curSchool.managedClasses.count > 0)
//    {
//        NSMutableDictionary *group = [NSMutableDictionary dictionary];
//        [group setValue:@"我管理的班" forKey:@"groupName"];
//        [group setValue:[NSArray arrayWithArray:[UserCenter sharedInstance].curSchool.managedClasses] forKey:@"groupArray"];
//        [classArray addObject:group];
//    }
    
    self.classArray = [UserCenter sharedInstance].curSchool.allClasses;
    
    NSMutableArray *groupArray = [NSMutableArray array];
    for (TeacherGroup *teacherGroup in [UserCenter sharedInstance].curSchool.groups)
    {
        if(teacherGroup.canNotice)
            [groupArray addObject:teacherGroup];
    }
    self.groupArray = groupArray;
    
    _selectedClassArray = [NSMutableArray array];
    _selectedGroupArray = [NSMutableArray array];
    
    NSInteger spaceYStart = 0;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"0fabc1"]];
    [self.view addSubview:headerView];
    
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"发给家长",@"发给同事"]];
    [_segmentControl setTintColor:[UIColor colorWithHexString:@"87de53"]];
    [_segmentControl setFrame:CGRectMake((headerView.width - 160) / 2, (headerView.height - 30) / 2, 160, 30)];
    [_segmentControl addTarget:self action:@selector(onSegmentChanged) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:_segmentControl];
    [_segmentControl setSelectedSegmentIndex:0];
    
    spaceYStart = headerView.height;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, spaceYStart, self.view.width, self.view.height - spaceYStart - 64 - 45) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - 45, self.view.width, 45)];
    [bottomView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [self setupBottomView:bottomView];
    [self.view addSubview:bottomView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(onSendClicked)];
}

- (void)setupBottomView:(UIView *)viewParent
{
    _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectAllButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_selectAllButton addTarget:self action:@selector(onSelectAllClicked) forControlEvents:UIControlEventTouchUpInside];
    [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllButton setTitle:@"反选" forState:UIControlStateSelected];
    [_selectAllButton setFrame:CGRectMake(0, 0, 50, viewParent.height)];
    [viewParent addSubview:_selectAllButton];
}

- (void)onSelectAllClicked
{
    _selectAllButton.selected = !_selectAllButton.selected;
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        [_selectedClassArray removeAllObjects];
        if(_selectAllButton.selected)
            [_selectedClassArray addObjectsFromArray:self.classArray];
        [_tableView reloadData];
    }
    else
    {
        [_selectedGroupArray removeAllObjects];
        if(_selectAllButton.selected)
            [_selectedGroupArray addObjectsFromArray:self.groupArray];
        [_tableView reloadData];
    }
}

- (void)onSegmentChanged
{
    [_tableView reloadData];
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        _selectAllButton.selected = (self.classArray.count == _selectedClassArray.count) && self.classArray.count > 0;
    }
    else
    {
        _selectAllButton.selected = (self.groupArray.count == _selectedGroupArray.count) && self.groupArray.count > 0;
    }
}

- (void)onSendClicked
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.params];
    NSMutableString *targetStr = [[NSMutableString alloc] init];
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        if(_selectedClassArray.count > 0)
        {
            NSMutableArray *classArray = [[NSMutableArray alloc] init];
            for (ClassInfo *classInfo in _selectedClassArray)
            {
                NSDictionary *itemDic = @{@"classid" : classInfo.classID};
                [classArray addObject:itemDic];
            }
            [targetStr appendString:[NSString stringWithJSONObject:classArray]];
            [params setValue:targetStr forKey:@"classes"];
        }
        else
        {
            [ProgressHUD showHintText:@"还没有选择发送对象"];
            return;
        }
    }
    else
    {
        if(_selectedGroupArray.count > 0)
        {
            for (TeacherGroup *teacherInfo in _selectedGroupArray)
            {
                [targetStr appendFormat:@"%@,",teacherInfo.groupID];
            }
            [params setValue:targetStr forKey:@"groups"];
        }
        else
        {
            [ProgressHUD showHintText:@"还没有选择发送对象"];
            return;
        }
    }
    if(self.imageArray.count > 0)
    {
        NSMutableString *picSeq = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < self.imageArray.count; i++)
        {
            [picSeq appendFormat:@"picture_%ld,",(long)i];
        }
        [params setValue:picSeq forKey:@"pic_seqs"];
    }
    
    if(self.imageArray.count > 0)
    {
//        NotificationItem *notificationItem = [[NotificationItem alloc] init];
//        [notificationItem setImageArray:self.imageArray];
//        [notificationItem setWords:self.params[@"words"]];
//        [notificationItem setParams:params];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPublishNotification object:nil userInfo:@{@"item" : notificationItem}];
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/send" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSInteger i = 0; i < self.imageArray.count; i++)
            {
                NSString *filename = [NSString stringWithFormat:@"picture_%ld",(long)i];
                [formData appendPartWithFileData:UIImageJPEGRepresentation(self.imageArray[i], 0.8) name:filename fileName:filename mimeType:@"image/jpeg"];
            }
            if(self.audioData)
                [formData appendPartWithFileData:self.audioData name:@"voice" fileName:@"voice" mimeType:@"audio/AMR"];
        } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [hud hide:NO];
            [ProgressHUD showSuccess:@"发送成功"];
        } fail:^(NSString *errMsg) {
            [hud hide:NO];
            [ProgressHUD showHintText:errMsg];
        }];
    }
}

- (void)onClassHeaderClicked:(UIButton *)button
{
    NotificationGroupHeaderView *headerView = (NotificationGroupHeaderView *)button.superview;
    NSInteger section = headerView.tag - 1000;
     NSArray *classArray = self.classArray[section][@"groupArray"];
    if(headerView.selectType == SelectTypeAll)
    {
        headerView.selectType = SelectTypeNone;
        //删除
        [_selectedClassArray removeObjectsInArray:classArray];
    }
    else
    {
        headerView.selectType = SelectTypeAll;
        //全选
        for (ClassInfo *classInfo in classArray)
        {
            if(![_selectedClassArray containsObject:classInfo])
                [_selectedClassArray addObject:classInfo];
        }
    }
    [_tableView reloadData];
}

- (void)onClassCellClicked:(UIButton *)button
{
    NotificationTargetCell *cell = (NotificationTargetCell *)button.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        ClassInfo *classInfo = self.classArray[indexPath.row];
        button.selected = !button.selected;
        if(button.selected)
        {
            if(![_selectedClassArray containsObject:classInfo])
                [_selectedClassArray addObject:classInfo];
        }
        else
        {
            if([_selectedClassArray containsObject:classInfo])
                [_selectedClassArray removeObject:classInfo];
        }
    }
    else
    {
        NSArray *groupArray = self.groupArray;
        TeacherGroup  *group = groupArray[indexPath.row];
        button.selected = !button.selected;
        if(button.selected)
        {
            if(![_selectedGroupArray containsObject:group])
                [_selectedGroupArray addObject:group];
        }
        else
        {
            if([_selectedGroupArray containsObject:group])
                [_selectedGroupArray removeObject:group];
        }
    }
    [_tableView reloadData];
}

//- (void)onGroupCellClicked:(UIButton *)button
//{
//    NotificationTargetCell *cell = (NotificationTargetCell *)button.superview;
//    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
//    NSArray *groupArray = [UserCenter sharedInstance].curSchool.groups;
//    TeacherGroup  *group = groupArray[indexPath.row];
//    button.selected = !button.selected;
//    if(button.selected)
//    {
//        if(![_selectedGroupArray containsObject:group])
//            [_selectedGroupArray addObject:group];
//    }
//    else
//    {
//        if([_selectedGroupArray containsObject:group])
//            [_selectedGroupArray removeObject:group];
//    }
//    [_tableView reloadData];
//}


#pragma mark = UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        return self.classArray.count;
    }
    else
    {
        return self.groupArray.count;
    }
}

//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if(_segmentControl.selectedSegmentIndex == 0)
//    {
//        NotificationGroupHeaderView *headerView = [[NotificationGroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
//        [headerView setTag:1000 + section];
//        [headerView.checkButton setUserInteractionEnabled:YES];
//        [headerView.checkButton addTarget:self action:@selector(onClassHeaderClicked:) forControlEvents:UIControlEventTouchUpInside];
//        NSDictionary *groupDic = self.classArray[section];
//        [headerView.nameLabel setText:groupDic[@"groupName"]];
//        NSInteger selectNum = 0;
//        NSArray *classArray = groupDic[@"groupArray"];
//        for (ClassInfo *classInfo in classArray)
//        {
//            if([_selectedClassArray containsObject:classInfo])
//                selectNum ++;
//        }
//        if(selectNum == 0)
//            [headerView setSelectType:SelectTypeNone];
//        else if(selectNum == classArray.count)
//            [headerView setSelectType:SelectTypeAll];
//        else
//            [headerView setSelectType:SelectTypePart];
//        return headerView;
//    }
//    else
//        return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"NotificationTargetCell";
    NotificationTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[NotificationTargetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.checkButton setUserInteractionEnabled:YES];
        [cell.checkButton addTarget:self action:@selector(onClassCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if(_segmentControl.selectedSegmentIndex == 0)
    {
//        NSDictionary *groupDic = self.classArray[indexPath.section];
//        NSArray *groupArray = groupDic[@"groupArray"];
        ClassInfo *classInfo = self.classArray[indexPath.row];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",classInfo.students.count]];
        [cell.nameLabel setText:classInfo.name];
        [cell.checkButton setSelected:[_selectedClassArray containsObject:classInfo]];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    else
    {
//        [cell.checkButton addTarget:self action:@selector(onGroupCellClicked:) forControlEvents:UIControlEventTouchUpInside];
        TeacherGroup *teacherGroup = self.groupArray[indexPath.row];
        [cell.nameLabel setText:teacherGroup.groupName];
        [cell.checkButton setSelected:[_selectedGroupArray containsObject:teacherGroup]];
        [cell.detailTextLabel setText:kStringFromValue(teacherGroup.teachers.count)];
        [cell setAccessoryView:nil];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        NSInteger row = indexPath.row;
//        NSDictionary *groupDic = self.classArray[section];
//        NSArray *groupArray = groupDic[@"groupArray"];
        ClassInfo *classInfo = self.classArray[row];
        NotificationClassStudentsVC *studentVC = [[NotificationClassStudentsVC alloc] init];
        [studentVC setTitle:classInfo.name];
        [studentVC setClassInfo:classInfo];
        [studentVC setParams:self.params];
        [studentVC setImageArray:self.imageArray];
        [studentVC setAudioData:self.audioData];
        [self.navigationController pushViewController:studentVC animated:YES];
    }
    else
    {
        TeacherGroup *teachergroup = self.groupArray[indexPath.row];
        NotificationGroupMemberVC *groupMemberVC = [[NotificationGroupMemberVC alloc] init];
        [groupMemberVC setTeacherGorup:teachergroup];
        [groupMemberVC setImageArray:self.imageArray];
        [groupMemberVC setAudioData:self.audioData];
        [groupMemberVC setParams:self.params];
        [self.navigationController pushViewController:groupMemberVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
