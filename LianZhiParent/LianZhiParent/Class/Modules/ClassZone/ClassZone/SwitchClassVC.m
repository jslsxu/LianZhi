//
//  SwitchClassVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "SwitchClassVC.h"

@implementation ClassItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(15, (self.height - 36) / 2, 36, 36)];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 15, 0, self.width - _logoView.right - 30, self.height)];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, self.width, 0.5)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [_logoView sd_setImageWithURL:[NSURL URLWithString:_classInfo.logo]];
    [_nameLabel setText:_classInfo.name];
}


@end

@interface SwitchClassVC ()
@end

@implementation SwitchClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorColor:kSepLineColor];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UserCenter sharedInstance].curChild.classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"SwitchClassCell";
    ClassItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[ClassItemCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
        
        [cell.detailTextLabel setTextColor:kCommonParentTintColor];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
    }
    ClassInfo *classInfo = [UserCenter sharedInstance].curChild.classes[indexPath.row];
    [cell setClassInfo:classInfo];
    BOOL isSelected = [self.classInfo.classID isEqualToString:classInfo.classID];
    if(isSelected)
    {
        [cell.detailTextLabel setText:@"当前"];
        [cell setAccessoryView:nil];
    }
    else
    {
        [cell.detailTextLabel setText:nil];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.classInfo = [UserCenter sharedInstance].curChild.classes[indexPath.row];
    [_tableView reloadData];
    if(self.completion)
        self.completion(self.classInfo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
