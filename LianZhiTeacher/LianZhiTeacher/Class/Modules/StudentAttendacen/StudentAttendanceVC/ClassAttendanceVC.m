//
//  ClassAttendanceVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "ClassAttendanceVC.h"
#import "StudentAttendanceVC.h"

@implementation ClassLeftItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.classID = [dataWrapper getStringForKey:@"class_id"];
    self.className = [dataWrapper getStringForKey:@"class_name"];
    self.logo = [dataWrapper getStringForKey:@"logo"];
    self.leftNum = [dataWrapper getIntegerForKey:@"leave_num"];
}

@end
@implementation ClassAttendanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 10, 36, 36)];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 0, 100, 50)];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_nameLabel];
        
        _indicator = [[NumIndicator alloc] init];
        [_indicator setIndicator:@""];
        [self addSubview:_indicator];
        
        [self.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        [self.detailTextLabel setTextColor:[UIColor colorWithHexString:@"949494"]];
        [self setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 55 - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    ClassLeftItem *leftItem = (ClassLeftItem *)modelItem;
    [_logoView sd_setImageWithURL:[NSURL URLWithString:leftItem.logo]];
    [_nameLabel setText:leftItem.className];
    [_nameLabel sizeToFit];
    [_nameLabel setY:(55 - _nameLabel.height) / 2];
    [_indicator setHidden:!leftItem.showRed];
    [_indicator setCenter:CGPointMake(_nameLabel.right + 10, 55.f / 2)];
    if(leftItem.leftNum > 0)
        [self.detailTextLabel setText:[NSString stringWithFormat:@"%ld人请假",(long)leftItem.leftNum]];
    else
        [self.detailTextLabel setText:@"暂无人请假"];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return @(55);
}

@end

@implementation ClassLeftModel
- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    
    if(data.count > 0)
    {
        for (NSInteger i = 0; i < data.count; i++)
        {
            TNDataWrapper *classDataWrapper = [data getDataWrapperForIndex:i];
            ClassLeftItem *leftItem = [[ClassLeftItem alloc] init];
            [leftItem parseData:classDataWrapper];
            NSDictionary *leaveDic = [UserCenter sharedInstance].statusManager.appLeave;
            NSNumber *number = [leaveDic objectForKey:leftItem.classID];
            if(number.integerValue > 0)
                leftItem.showRed = YES;
            else
                leftItem.showRed = NO;
            [self.modelItemArray addObject:leftItem];
        }
    }
    return YES;
}

@end

@interface ClassAttendanceVC ()<UITableViewDataSource, UITableViewDelegate>

@end


@implementation ClassAttendanceVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:REQUEST_REFRESH];
}

- (void)onStatusChanged
{
    NSDictionary *leaveDic = [UserCenter sharedInstance].statusManager.appLeave;
    for (ClassLeftItem *leftItem in self.tableViewModel.modelItemArray)
    {
        NSNumber *number = [leaveDic objectForKey:leftItem.classID];
        if(number.integerValue > 0)
            leftItem.showRed = YES;
        else
            leftItem.showRed = NO;
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我所有的班";

    [self bindTableCell:@"ClassAttendanceCell" tableModel:@"ClassLeftModel"];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"leave/tclass"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    return task;
}

#pragma mark - UITableViewDelegae
- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    ClassLeftItem *leftItem = (ClassLeftItem *)modelItem;
    StudentAttendanceVC *studentAttendanceVC = [[StudentAttendanceVC alloc] init];
    [studentAttendanceVC setClassID:leftItem.classID];
    [studentAttendanceVC setTitle:leftItem.className];
    [self.navigationController pushViewController:studentAttendanceVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
