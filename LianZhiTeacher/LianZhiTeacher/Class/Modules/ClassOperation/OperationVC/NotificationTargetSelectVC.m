//
//  NotificationTargetSelectVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NotificationTargetSelectVC.h"
#import "NotificationClassStudentsVC.h"

@implementation NotificationTeacherGroup

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.groupId = [dataWrapper getStringForKey:@"id"];
    self.groupName = [dataWrapper getStringForKey:@"name"];
    self.groupLogo = [dataWrapper getStringForKey:@"logo"];
    TNDataWrapper *teacherArrayWrapper = [dataWrapper getDataWrapperForKey:@"teachers"];
    if(teacherArrayWrapper.count > 0)
    {
        NSMutableArray *teacherArray = [NSMutableArray array];
        for (NSInteger i = 0; i < teacherArrayWrapper.count; i++)
        {
            TeacherInfo *teacherInfo = [[TeacherInfo alloc] init];
            TNDataWrapper *teacherWrapper = [teacherArrayWrapper getDataWrapperForIndex:i];
            [teacherInfo parseData:teacherWrapper];
            [teacherArray addObject:teacherInfo];
        }
        self.teachers = teacherArray;
    }
}

@end

@implementation NotificationTargetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setFrame:CGRectMake(30, 0, 20, self.height)];
        [_checkButton setUserInteractionEnabled:NO];
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
    [_nameLabel setText:_classInfo.className];
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
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"767676"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_nameLabel];

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

@interface NotificationTargetSelectVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSArray *groupArray;
@property (nonatomic, strong)NSArray *classesArray;
@property (nonatomic, strong)NSArray *teacherGroupArray;
@end

@implementation NotificationTargetSelectVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息通知";
    self.classesArray = [UserCenter sharedInstance].curSchool.classes;
    _selectedMateArray = [NSMutableArray array];
    _selectedStudentDic = [NSMutableDictionary dictionary];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [headerView setBackgroundColor:kCommonTeacherTintColor];
    [self.view addSubview:headerView];
    
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"发给家长",@"发给同事"]];
    [_segmentControl setTintColor:[UIColor colorWithHexString:@"87de53"]];
    [_segmentControl setFrame:CGRectMake((headerView.width - 160) / 2, (headerView.height - 30) / 2, 160, 30)];
    [_segmentControl addTarget:self action:@selector(onSegmentChanged) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:_segmentControl];
    [_segmentControl setSelectedSegmentIndex:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - headerView.bottom - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(onSendClicked)];
    
    [self requestData];
}

- (void)onSegmentChanged
{
    [_tableView reloadData];
}

- (void)onSendClicked
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.params];
    NSMutableString *targetStr = [[NSMutableString alloc] init];
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        NSArray *allKeys = [_selectedStudentDic allKeys];
        if(allKeys.count > 0)
        {
            NSMutableArray *classArray = [[NSMutableArray alloc] init];
            for (NSString *key in allKeys)
            {
                NSArray *studentArray = _selectedStudentDic[key];
                NSDictionary *itemDic = @{@"classid" : key,@"students":studentArray};
                [classArray addObject:itemDic];
            }
            [targetStr appendString:[NSString stringWithJSONObject:classArray]];
            [params setValue:targetStr forKey:@"classes"];
        }
    }
    else
    {
        for (NotificationTeacherGroup *teacherInfo in _selectedMateArray)
        {
            [targetStr appendFormat:@"%@,",teacherInfo.groupId];
        }
        [params setValue:targetStr forKey:@"groups"];
    }
    if(targetStr.length == 0)
    {
        [ProgressHUD showHintText:@"还没有选择发送对象"];
        return;
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
        [ProgressHUD showHintText:@"发送成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showHintText:errMsg];
    }];
    
    

}

- (void)requestData
{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/get_publish_scope" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *groupsWrapper = [responseObject getDataWrapperForKey:@"groups"];
        if(groupsWrapper.count > 0)
        {
            NSMutableArray *groupArray = [NSMutableArray array];
            for (NSInteger i = 0; i < groupsWrapper.count; i++)
            {
                TNDataWrapper *classWrapper = [groupsWrapper getDataWrapperForIndex:i];
                ClassInfo *classInfo = [[ClassInfo alloc] init];
                [classInfo parseData:classWrapper];
                [groupArray addObject:classInfo];
            }
            self.groupArray = groupArray;
        }
        
//        TNDataWrapper *classesWrapper = [responseObject getDataWrapperForKey:@"classes"];
//        if(classesWrapper.count > 0)
//        {
//            NSMutableArray *groupArray = [NSMutableArray array];
//            for (NSInteger i = 0; i < classesWrapper.count; i++)
//            {
//                TNDataWrapper *classWrapper = [classesWrapper getDataWrapperForIndex:i];
//                ClassInfo *classInfo = [[ClassInfo alloc] init];
//                [classInfo parseData:classWrapper];
//                [groupArray addObject:classInfo];
//            }
//            self.classesArray = groupArray;
//        }
        [_tableView reloadData];
    } fail:^(NSString *errMsg) {
        
    }];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"app/groups" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *groupsWrapper = [responseObject getDataWrapperForKey:@"list"];
        if(groupsWrapper.count > 0)
        {
            NSMutableArray *groupArray = [NSMutableArray array];
            for (NSInteger i = 0; i < groupsWrapper.count; i++)
            {
                TNDataWrapper *groupWrapper = [groupsWrapper getDataWrapperForIndex:i];
                NotificationTeacherGroup *group = [[NotificationTeacherGroup alloc] init];
                [group parseData:groupWrapper];
                [groupArray addObject:group];
            }
            self.teacherGroupArray = groupArray;
        }
        [_tableView reloadData];
    } fail:^(NSString *errMsg) {
        
    }];

}

#pragma mark = UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        return 2;
    }
    else
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        if(section == 1)
            return self.groupArray.count;
        else
            return self.classesArray.count;
    }
    else
    {
        return self.teacherGroupArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_segmentControl.selectedSegmentIndex == 0)
        return 50;
    else
        return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        NotificationGroupHeaderView *headerView = [[NotificationGroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
        if(section == 1)
        {
            [headerView.nameLabel setText:@"我管理的班"];
            NSInteger selectNum = 0;
            for (ClassInfo *classInfo in self.groupArray)
            {
                if([_selectedStudentDic valueForKey:classInfo.classID])
                    selectNum ++;
            }
            if(selectNum == 0)
                [headerView setSelectType:SelectTypeNone];
            else if(selectNum == self.groupArray.count)
                [headerView setSelectType:SelectTypeAll];
            else
                [headerView setSelectType:SelectTypePart];
        }
        else
        {
            [headerView.nameLabel setText:@"我教授的班"];
            NSInteger selectNum = 0;
            for (ClassInfo *classInfo in self.classesArray)
            {
                if([_selectedStudentDic valueForKey:classInfo.classID])
                    selectNum ++;
            }
            if(selectNum == 0)
                [headerView setSelectType:SelectTypeNone];
            else if(selectNum == self.classesArray.count)
                [headerView setSelectType:SelectTypeAll];
            else
                [headerView setSelectType:SelectTypePart];
        }
        return headerView;
    }
    else
        return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"NotificationTargetCell";
    NotificationTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[NotificationTargetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        ClassInfo *classInfo = nil;
        if(indexPath.section == 1)
            classInfo = self.groupArray[indexPath.row];
        else
            classInfo = self.classesArray[indexPath.row];
        [cell.nameLabel setText:classInfo.className];
        [cell.checkButton setSelected:[_selectedStudentDic valueForKey:classInfo.classID]];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:indexPath.section == 0 ? [UIImage imageNamed:@"RightArrow"] : nil]];
    }
    else
    {
        NotificationTeacherGroup *teacherGroup = self.teacherGroupArray[indexPath.row];
        [cell.nameLabel setText:teacherGroup.groupName];
        [cell.checkButton setSelected:[_selectedMateArray containsObject:teacherGroup]];
        [cell setAccessoryView:nil];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_segmentControl.selectedSegmentIndex == 0)
    {
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        ClassInfo *classInfo = nil;
        if(section == 1)
            classInfo = self.groupArray[row];
        else
            classInfo = self.classesArray[row];
        if(section == 0)
        {
            NotificationClassStudentsVC *studentVC = [[NotificationClassStudentsVC alloc] init];
            [studentVC setTitle:classInfo.className];
            [studentVC setClassID:classInfo.classID];
            [studentVC setOriginalArray:_selectedStudentDic[classInfo.classID]];
            [studentVC setSelectedCompletion:^(NSArray *studentArray)
             {
                 if(studentArray.count > 0)
                     [_selectedStudentDic setValue:studentArray forKey:classInfo.classID];
                 else
                     [_selectedStudentDic removeObjectForKey:classInfo.classID];
                 [_tableView reloadData];
             }];
            [self.navigationController pushViewController:studentVC animated:YES];
        }
        else
        {
            if([_selectedStudentDic valueForKey:classInfo.classID])
                [_selectedStudentDic removeObjectForKey:classInfo.classID];
            else
                [_selectedStudentDic setValue:@"" forKey:classInfo.classID];
            [_tableView reloadData];
        }
    }
    else
    {
        NotificationTeacherGroup *teachergroup = self.teacherGroupArray[indexPath.row];
        if([_selectedMateArray containsObject:teachergroup])
            [_selectedMateArray removeObject:teachergroup];
        else
            [_selectedMateArray addObject:teachergroup];
        [_tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
