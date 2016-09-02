//
//  ContactServiceVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/28.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ContactServiceVC.h"
#import "ReportProblemVC.h"

@implementation ContactServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.width - 10 * 2, self.height)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:4];
        [_contentView.layer setMasksToBounds:YES];
        [self addSubview:_contentView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, _contentView.height)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_contentView addSubview:_nameLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]];
        [imageView setOrigin:CGPointMake(_contentView.width - imageView.width - 10, (_contentView.height - imageView.height) / 2)];
        [_contentView addSubview:imageView];
    }
    return self;
}

@end

@implementation ContactServiceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"联系客服";
    
    _titleArray = @[@"软件错误报告",@"产品升级建议",@"关联信息报错",@"登录信息修改"];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setSeparatorColor:kSepLineColor];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ContactServiceItemCell";
    ContactServiceCell *cell = (ContactServiceCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[ContactServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
//        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
//        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
//    [cell.textLabel setText:_titleArray[indexPath.section]];
    [cell.nameLabel setText:_titleArray[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReportProblemVC *reportVC = [[ReportProblemVC alloc] init];
    [reportVC setType:indexPath.section + 1];
    [reportVC setTitle:_titleArray[indexPath.section]];
    [self.navigationController pushViewController:reportVC animated:YES];
}
@end
