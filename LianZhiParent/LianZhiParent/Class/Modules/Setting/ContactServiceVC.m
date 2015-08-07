//
//  ContactServiceVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/28.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ContactServiceVC.h"
#import "ReportProblemVC.h"

@implementation ContactServiceItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 160, self.height)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor grayColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_titleLabel];
        
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"DatePickerNext.png")]];
        [_arrow setHighlightedImage:[UIImage imageNamed:MJRefreshSrcName(@"WhiteRightArrow.png")]];
        [_arrow setOrigin:CGPointMake(self.width - _arrow.width - 20, (self.height - _arrow.height) / 2)];
        [self addSubview:_arrow];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [_titleLabel setText:_title];
}

- (UIImage *)highlightedBGImageForCellType:(TableViewCellType)cellType
{
    NSString *imageStr = nil;
    if(cellType == TableViewCellTypeFirst)
        imageStr = MJRefreshSrcName(@"GreenBG.png");
    else if(cellType == TableViewCellTypeMiddle)
        imageStr = @"Middle_Selected.png";
    else if(cellType == TableViewCellTypeLast)
        imageStr = @"Last_Selected.png";
    else
        imageStr = MJRefreshSrcName(@"GreenBG.png");
    return [[UIImage imageNamed:imageStr] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}
@end

@implementation ContactServiceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"联系客服";
    
    _titleArray = @[@"登录信息修改",@"关联信息报错",@"产品升级建议",@"软件错误报告"];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setContentInset:UIEdgeInsetsMake(15, 0, 5, 0)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ContactServiceItemCell";
    ContactServiceItemCell *cell = (ContactServiceItemCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[ContactServiceItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    [cell setTitle:_titleArray[indexPath.section]];
    [cell setCellType:TableViewCellTypeSingle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReportProblemVC *reportVC = [[ReportProblemVC alloc] init];
    [reportVC setType:indexPath.section + 1];
    [self.navigationController pushViewController:reportVC animated:YES];
}
@end
