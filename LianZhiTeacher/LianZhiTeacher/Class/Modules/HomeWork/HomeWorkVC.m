//
//  HomeWorkVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkVC.h"
#import "PublishHomeWorkBaseVC.h"
#import "PublishHomeWorkAudioVC.h"
#import "PublishHomeWorkPhotoVC.h"
#import "PublishHomeWorkTextVC.h"
#import "HomeWorkItemCell.h"
@interface HomeWorkVC ()<ActionSelectViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, PublishHomeWorkDelegate, HomeWorkItemCellDelegate>
@property (nonatomic, strong)NSMutableArray *courseArray;
@property (nonatomic, copy)NSString *course;
@property (nonatomic, strong)NSMutableArray *homeWorkArray;
@end

@implementation HomeWorkVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.homeWorkArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作业练习";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RecordHistory"] style:UIBarButtonItemStylePlain target:self action:@selector(onShowHistory)];
    self.courseArray = [NSMutableArray array];
    for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.classes)
    {
        BOOL isIn = NO;
        for (NSString * course in self.courseArray)
        {
            if([course isEqualToString:classInfo.course])
                isIn = YES;
        }
        if(!isIn)
            [self.courseArray addObject:classInfo.course];
    }
    if(self.courseArray.count > 0)
        self.course = self.courseArray[0];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.width - 10 * 2, 70)];
    [self setupHeaderView:_headerView];
    [self.view addSubview:_headerView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(10, self.view.height - 64 - 20 - 36, self.view.width - 10 * 2, 36)];
    [sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed016"] size:sendButton.size cornerRadius:18] forState:UIControlStateNormal];
    [sendButton setTitle:@"选择学生并发送" forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(onSendClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, _headerView.bottom, self.view.width - 10 * 2, sendButton.y - 20 - _headerView.bottom)];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    [_contentView.layer setCornerRadius:10];
    [_contentView.layer setMasksToBounds:YES];
    [self.view addSubview:_contentView];
    
    _tableView = [[UITableView alloc] initWithFrame:_contentView.bounds style:UITableViewStylePlain];
    [_tableView setScrollEnabled:NO];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_contentView addSubview:_tableView];
    
    _hintLabel = [[UILabel alloc] initWithFrame:CGRectInset(_contentView.bounds, 30, 30)];
    [_hintLabel setTextAlignment:NSTextAlignmentCenter];
    [_hintLabel setNumberOfLines:0];
    [_hintLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_hintLabel setFont:[UIFont systemFontOfSize:14]];
    [_hintLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [_hintLabel setText:@"每组小练习最多支持3道题。可以是文字，语音，图片任何形式。\n您也可以针对不同徐鞥生学习特点发送针对性的习题。\n快快点击上方的加号开始吧！"];
    [_contentView addSubview:_hintLabel];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setFrame:CGRectMake(0, 15, 40, 40)];
    [_addButton setImage:[UIImage imageNamed:@"AddHomeWork"] forState:UIControlStateNormal];
    [_addButton setImage:[UIImage imageNamed:@"AddHomeWorkCancel"] forState:UIControlStateSelected];
    [_addButton addTarget:self action:@selector(onAddButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewParent addSubview:_addButton];
    
    _typeView = [[UIView alloc] initWithFrame:CGRectMake(_addButton.right, 0, 190, viewParent.height)];
    [_typeView setHidden:YES];
    [viewParent addSubview:_typeView];
    
    NSArray *imageArray = @[@"HomeWorkText",@"HomeWorkCamera",@"HomeWorkPhoto",@"HomeWorkAudio"];
    NSArray *colorArray = @[@"c785fb",@"fecf3c",@"02ca94",@"6ca3fb"];
    for (NSInteger i = 0; i < 4; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onTypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:1000 + i];
        [button setFrame:CGRectMake((40 + 10) * i, 15, 40, 40)];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:colorArray[i]] size:button.size cornerRadius:20] forState:UIControlStateNormal];
        [_typeView addSubview:button];
    }
    
    _courseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_courseLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [_courseLabel setFont:[UIFont systemFontOfSize:14]];
    [_courseLabel setTextAlignment:NSTextAlignmentCenter];
    [_courseLabel setText:self.course];
    [viewParent addSubview:_courseLabel];
    
    if(self.courseArray.count == 1)
    {
        [_courseLabel setFrame:CGRectMake(viewParent.width - 10 - 50, (viewParent.height - 16) / 2, 50, 16)];
    }
    else
    {
        [_courseLabel setFrame:CGRectMake(viewParent.width - 10 - 50, 16, 50, 16)];
        UIButton *courseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [courseButton addTarget:self action:@selector(onCourseButtonCLicked) forControlEvents:UIControlEventTouchUpInside];
        [courseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [courseButton.titleLabel setFont:[UIFont systemFontOfSize:9]];
        [courseButton setTitle:@"选择科目" forState:UIControlStateNormal];
        [courseButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHexString:@"28c4d8"] size:CGSizeMake(16, 16) cornerRadius:8] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)] forState:UIControlStateNormal];
        [courseButton setFrame:CGRectMake(viewParent.width - 10 - 50, viewParent.height - 16 - 16, 50, 16)];
        [viewParent addSubview:courseButton];
    }
}

- (void)onTypeButtonClicked:(UIButton *)button
{
    NSInteger index = button.tag - 1000;
    PublishHomeWorkBaseVC *publishVC = nil;
    UIImagePickerController *imagePicker = nil;
    if(index == 0 || index == 3)
    {
        if(index == 0)
            publishVC = [[PublishHomeWorkTextVC alloc] init];
        else
            publishVC = [[PublishHomeWorkAudioVC alloc] init];
        [publishVC setDelegate:self];
        TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:publishVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setAllowsEditing:YES];
        [imagePicker setDelegate:self];
        if(index == 1)
        {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else
        {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)onShowHistory
{
    
}

- (void)onSendClicked
{
    
}

- (void)onAddButtonClicked
{
    _addButton.selected = !_addButton.selected;
    [_typeView setHidden:!_addButton.selected];
}

- (void)onCourseButtonCLicked
{
    ActionSelectView *selectView  =[[ActionSelectView alloc] init];
    [selectView setDelegate:self];
    [selectView show];
    
}

- (void)updateContentView
{
    NSInteger height = 0;
    if(self.homeWorkArray.count == 0)
    {
        height = self.view.height - 20 - 36 - _headerView.bottom - 20;
    }
    else
    {
        for (HomeWorkItem *item in self.homeWorkArray)
        {
            height += [HomeWorkItemCell cellHeightForItem:item forWidth:_tableView.width];
        }
    }
    [_contentView setHeight:height];
    [_tableView setHeight:height];
    [_tableView reloadData];
}

#pragma mark - HomeWorkItemCellDelegate
- (void)homeWorkCellDidDelete:(HomeWorkItemCell *)cell
{
    HomeWorkItem *item = cell.homeWorkItem;
    if(self.homeWorkArray.count > 0)
    {
        [self.homeWorkArray removeObject:item];
        [self updateContentView];
    }
}

#pragma mark - PublishHomeWorkDelegate
- (void)publishHomeWorkFinished:(HomeWorkItem *)homeWorkItem
{
    if(self.homeWorkArray.count < 3 && homeWorkItem)
    {
        [self.homeWorkArray addObject:homeWorkItem];
        [self updateContentView];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _hintLabel.hidden = (self.homeWorkArray.count > 0);
    return self.homeWorkArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeWorkItem *homeWorkItem = self.homeWorkArray[indexPath.row];
    return [HomeWorkItemCell cellHeightForItem:homeWorkItem forWidth:tableView.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"HomeWorkItemCell";
    HomeWorkItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[HomeWorkItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        [cell setDelegate:self];
        [cell setWidth:tableView.width];
    }
    [cell setHomeWorkItem:self.homeWorkArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeWorkItemCell *cell = (HomeWorkItemCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setCurSelected:!cell.curSelected];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        PublishHomeWorkPhotoVC *publishPhotoVC = [[PublishHomeWorkPhotoVC alloc] init];
        [publishPhotoVC setImage:image];
        [publishPhotoVC setDelegate:self];
        TNBaseNavigationController *navVC = [[TNBaseNavigationController alloc] initWithRootViewController:publishPhotoVC];
        [self presentViewController:navVC animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
}

#pragma mark - ActionSelectDelegate
- (NSInteger)pickerView:(ActionSelectView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.courseArray.count;
}

- (NSString *)pickerView:(ActionSelectView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.courseArray[row];
}

- (void)pickerViewFinished:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.course = self.courseArray[row];
    [_courseLabel setText:self.course];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
