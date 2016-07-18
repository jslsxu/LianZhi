//
//  GrowthTimelinePublishVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelinePublishVC.h"

@implementation GrowthTimelinePublishVC

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setTitle:@"返回"];
    self.navigationItem.backBarButtonItem = backItem;
    self.hidesBottomBarWhenPushed = YES;
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _timelineArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < self.students.count; i++) {
        GrowthTimelineModelItem *modelItem = [[GrowthTimelineModelItem alloc] init];
        [modelItem setStudentInfo:self.students[i]];
        [_timelineArray addObject:modelItem];
    }
    self.title = @"成长手册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:(@"WhiteLeftArrow.png")] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld人",(long)self.students.count] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:kCommonBackgroundColor];
    _datePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
    [_datePickerView setDelegate:self];
    [self.tableView setTableHeaderView:_datePickerView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 75)];
    UIButton *publishRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishRecordButton addTarget:self action:@selector(onPublish) forControlEvents:UIControlEventTouchUpInside];
    [publishRecordButton setFrame:CGRectMake(30, (footerView.height - 45) / 2, footerView.width - 30 * 2, 45)];
    [publishRecordButton setBackgroundImage:[[UIImage imageNamed:(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [publishRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishRecordButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [publishRecordButton setTitle:@"发送成长记录" forState:UIControlStateNormal];
    [footerView addSubview:publishRecordButton];
    
    [self.tableView setTableFooterView:footerView];
    
    [self requestData];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestData
{

    [_timelineArray removeAllObjects];
    for (NSInteger i = 0; i < self.students.count; i++) {
        GrowthTimelineModelItem *modelItem = [[GrowthTimelineModelItem alloc] init];
        [modelItem setStudentInfo:self.students[i]];
        [_timelineArray addObject:modelItem];
    }
    [self.tableView reloadData];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [params setValue:[_datePickerView dateStr] forKey:@"date"];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/record_list" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if([[params objectForKey:@"date"] isEqualToString:[_datePickerView dateStr]])
        {
            TNDataWrapper *listWrapper = [responseObject getDataWrapperForKey:@"list"];
            if(listWrapper.count > 0)
            {
                for (NSInteger i = 0; i < listWrapper.count; i++) {
                    TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
                    for (GrowthTimelineModelItem *item in _timelineArray) {
                        TNDataWrapper *studentWrapper = [itemWrapper getDataWrapperForKey:@"student"];
                        if([[studentWrapper getStringForKey:@"id"] isEqualToString:item.studentInfo.uid])
                            [item parseData:itemWrapper];
                    }
                }
                
                for (NSInteger i = 0; i < _timelineArray.count; i++) {
                    for (NSInteger j = i+1; j < _timelineArray.count; j++) {
                        GrowthTimelineModelItem *item1 = [_timelineArray objectAtIndex:i];
                        GrowthTimelineModelItem *item2 = [_timelineArray objectAtIndex:j];
                        if(item1.hasSent && item2.hasSent == NO)
                            [_timelineArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                    }
                }
                
            }
            [self.tableView reloadData];
        }
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)onPublish
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (GrowthTimelineModelItem *item in _timelineArray) {
        NSDictionary *dic = [item toDictionary];
        [resultArray addObject:dic];
    }
    NSString *publishStr = [NSString stringWithJSONObject:resultArray];
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在发送" toView:self.view];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:publishStr forKey:@"records"];
    [params setValue:[_datePickerView dateStr] forKey:@"date"];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/record" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:YES];
        [ProgressHUD showSuccess:@"发送成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self cancel];
        });
    } fail:^(NSString *errMsg) {
        [hud hide:YES];
        [ProgressHUD showHintText:errMsg];
    }];
}


#pragma mark - DatePickerDelegate
- (void)growthDatePickerFinished:(NSDate *)date
{
    [self requestData];
}

#pragma mark - UItableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return [[UIView alloc] initWithFrame:CGRectZero];
    else
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForHeaderInSection:section])];
        
        UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
        [label setTextColor:[UIColor lightGrayColor]];
        [label setFont:[UIFont systemFontOfSize:16]];
        [label setText:@"下边的小朋友已经发送过成长记录"];
        [label setTextAlignment:NSTextAlignmentCenter];
        [headerView addSubview:label];
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSInteger num = 0;
    for (GrowthTimelineModelItem *item in _timelineArray) {
        if(item.hasSent)
            num++;
    }

    if(num == 0)
    {
        return 0;
    }
    else if(num == _timelineArray.count)
    {
        if(section == 0)
            return 0;
        return 24;
    }
    else
    {
        if(section == 0)
            return 0;
        else
            return 24;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    for (GrowthTimelineModelItem *item in _timelineArray) {
        if(item.hasSent)
            num++;
    }
    if(section == 0)
        return _timelineArray.count - num;
    else
        return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GrowthTimelinePublishCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *cellID = [NSString stringWithFormat:@"GrowthTimelinePublishCell%ld",(long)indexPath.row];
    static NSString *cellID = @"GrowthTimelinePublishCell";
    GrowthTimelinePublishCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[GrowthTimelinePublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSInteger num = 0;
    if(indexPath.section == 0)
    {
        for (GrowthTimelineModelItem *item in _timelineArray) {
            if(!item.hasSent)
            {
                num ++;
                if((num - 1) == indexPath.row)
                {
                    [cell setModelItem:item];
                }
            }
        }
    }
    else
    {
        for (GrowthTimelineModelItem *item in _timelineArray) {
            if(item.hasSent)
            {
                num ++;
                if((num - 1) == indexPath.row)
                {
                    [cell setModelItem:item];
                }
            }
        }
    }
    return cell;
}

@end
