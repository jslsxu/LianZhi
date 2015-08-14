//
//  NotificationToAllVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NotificationToAllVC.h"
#import "MessageOperationVC.h"
@implementation NotificationGroupItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.groupID = [dataWrapper getStringForKey:@"id"];
    self.groupName = [dataWrapper getStringForKey:@"name"];
    self.comment = [dataWrapper getStringForKey:@"year"];
    self.selected = NO;
    self.canSelected = YES;
}

@end

@implementation NotificationGroupCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _checkBox = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [self addSubview:_checkBox];
        
        _groupNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_groupNameLabel setTextColor:[UIColor grayColor]];
        [_groupNameLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_groupNameLabel];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_commentLabel setTextColor:[UIColor lightGrayColor]];
        [_commentLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_commentLabel];
    }
    return self;
}

- (UIImage *)BGImageForCellType:(TableViewCellType)cellType
{
    UIImage *image = nil;
    if(cellType == TableViewCellTypeFirst)
        image = [[UIImage imageNamed:(@"CellBGFirst.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    else if(cellType == TableViewCellTypeMiddle)
        image = [[UIImage imageNamed:(@"CellBGMiddle.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    else if(cellType == TableViewCellTypeLast)
        image = [[UIImage imageNamed:(@"CellBGLast.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    else
        image = [[UIImage imageNamed:(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    return image;
}

- (void)setGroupItem:(NotificationGroupItem *)groupItem
{
    _groupItem = groupItem;
    [_groupNameLabel setText:_groupItem.groupName];
    [_groupNameLabel sizeToFit];
    if(_groupItem.subItems.count > 0 || _groupItem.groupID.length == 0)
        [_groupNameLabel setOrigin:CGPointMake(20, (self.height - _groupNameLabel.height) / 2)];
    else
        [_groupNameLabel setOrigin:CGPointMake(40, (self.height - _groupNameLabel.height) / 2)];
    if(_groupItem.comment.length > 0)
    {
        _commentLabel.hidden = NO;
        [_commentLabel setText:[NSString stringWithFormat:@"(%@)",_groupItem.comment]];
        [_commentLabel sizeToFit];
        [_commentLabel setOrigin:CGPointMake(_groupNameLabel.right + 5, (self.height - _commentLabel.height) / 2)];
    }
    else
        _commentLabel.hidden = YES;
    [_checkBox setOrigin:CGPointMake(self.width - 45, (self.height - _checkBox.height) / 2)];
    if(_groupItem.canSelected)
    {
        _checkBox.hidden = NO;
        if(_groupItem.selected)
            [_checkBox setImage:[UIImage imageNamed:(@"CheckboxOn.png")]];
        else
            [_checkBox setImage:[UIImage imageNamed:(@"CheckboxOff.png")]];
    }
    else
        _checkBox.hidden = YES;
}

@end

@interface NotificationToAllVC()
@property (nonatomic, strong)NotificationGroupItem *allTeacherItem;
@property (nonatomic, strong)NotificationGroupItem *allParenstsItem;

@end

@implementation NotificationToAllVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"全体通知";
}

- (void)setupSubviews
{
    UIButton *postTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postTextButton addTarget:self action:@selector(onPostButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [postTextButton setBackgroundImage:[[UIImage imageNamed:(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [postTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postTextButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [postTextButton setTitle:@"填写通知内容" forState:UIControlStateNormal];
    [postTextButton setFrame:CGRectMake(10, self.view.height - 10 - 45, self.view.width - 10 * 2, 45)];
    [self.view addSubview:postTextButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 65) style:UITableViewStyleGrouped];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_tableView];
    
    [self addHeaderView];
    [self requestData];
}

- (void)requestData
{
    [self startLoading];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/get_publish_scope" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [self endLoading];
        BOOL allTeacher = [responseObject getBoolForKey:@"all_teachers"];
        NotificationGroupItem *allTeacherGroupItem = [[NotificationGroupItem alloc] init];
        [allTeacherGroupItem setGroupName:@"全体教师"];
        [allTeacherGroupItem setComment:@"包含非教学人员"];
        [allTeacherGroupItem setCanSelected:allTeacher];
        self.allTeacherItem = allTeacherGroupItem;
        
        TNDataWrapper *gradeWrapper = [responseObject getDataWrapperForKey:@"grades"];
        if(gradeWrapper.count > 0)
        {
            NotificationGroupItem *gradesGroupItem = [[NotificationGroupItem alloc] init];
            [gradesGroupItem setGroupName:@"全体家长"];
            [self setAllParenstsItem:gradesGroupItem];
            
            NSMutableArray *subItemArray = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < gradeWrapper.count; i++) {
                TNDataWrapper *itemWrapper = [gradeWrapper getDataWrapperForIndex:i];
                NotificationGroupItem *groupItem = [[NotificationGroupItem alloc] init];
                [groupItem parseData:itemWrapper];
                [subItemArray addObject:groupItem];
            }
            [gradesGroupItem setSubItems:subItemArray];
            [gradesGroupItem setCanSelected:subItemArray.count > 0];
        }
        
        [_tableView reloadData];
    } fail:^(NSString *errMsg) {
        [self endLoading];
        [ProgressHUD showError:errMsg];
    }];
}

- (void)addHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 40)];
    [headerView setBackgroundColor:[UIColor colorWithRed:211 / 255.0 green:211 / 255.0 blue:211 / 255.0 alpha:1.f]];
    [_tableView setTableHeaderView:headerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, headerView.height)];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:kCommonTeacherTintColor];
    [label setText:@"发送给谁?"];
    [headerView addSubview:label];
}

#pragma mark - UItableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
    {
        return 1 + self.allParenstsItem.subItems.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"NotificationGroupCell";
    NotificationGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[NotificationGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setCellType:[BGTableViewCell cellTypeForTableView:tableView atIndexPath:indexPath]];
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
            [cell setGroupItem:self.allParenstsItem];
        else
            [cell setGroupItem:self.allParenstsItem.subItems[indexPath.row - 1]];
        
    }
    else
        [cell setGroupItem:self.allTeacherItem];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        self.allTeacherItem.selected = !self.allTeacherItem.selected;
    }
    else
    {
        if(indexPath.row == 0)
        {
            self.allParenstsItem.selected = !self.allParenstsItem.selected;
            for (NotificationGroupItem *item in self.allParenstsItem.subItems) {
                [item setSelected:self.allParenstsItem.selected];
            }
            
        }
        else
        {
            NotificationGroupItem *item = self.allParenstsItem.subItems[indexPath.row - 1];
            item.selected = !item.selected;
            BOOL selectAll = YES;
            for (NotificationGroupItem *item in self.allParenstsItem.subItems) {
                if(!item.selected)
                    selectAll = NO;
            }
            [self.allParenstsItem setSelected:selectAll];
            
        }
    }
    [tableView reloadData];
}

- (void)onPostButtonClicked
{
    BOOL selected = NO;
    NSMutableString *ids = [[NSMutableString alloc] init];
    for (NotificationGroupItem *item in self.allParenstsItem.subItems) {
        if(item.selected)
        {
            selected = YES;
            if(ids.length > 0)
                [ids appendString:[NSString stringWithFormat:@",%@",item.groupID]];
            else
                [ids appendString:[NSString stringWithFormat:@"%@",item.groupID]];
        }
    }
    if(self.allTeacherItem.selected)
        selected = YES;
    if(selected)
    {
        MessageOperationVC *messageOperationVC = [[MessageOperationVC alloc] init];
        [messageOperationVC setTargetDic:@{@"all_teachers":@(self.allTeacherItem.selected),@"grade_ids":ids}];
        TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:messageOperationVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:nil];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"还没有选择通知对象" buttonItems:@[item]];
        [alertView show];
    }
}
@end
