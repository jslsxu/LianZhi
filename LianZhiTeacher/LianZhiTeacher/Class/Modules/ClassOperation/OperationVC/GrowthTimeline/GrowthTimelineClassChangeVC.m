//
//  GrowthTimelineClassChangeVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelineClassChangeVC.h"

@implementation GrowthClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(12, (self.height - 36) / 2, 36, 36)];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 0, self.width - 50 - (_logoView.right + 10), self.height)];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_nameLabel];
        
        [self setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [_logoView setImageWithUrl:[NSURL URLWithString:_classInfo.logoUrl]];
    [_nameLabel setText:_classInfo.className];
}

@end

@interface GrowthTimelineClassChangeVC ()

@end

@implementation GrowthTimelineClassChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:kSepLineColor];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UserCenter sharedInstance].curSchool.classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"";
    GrowthClassCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[GrowthClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    [cell setClassInfo:[UserCenter sharedInstance].curSchool.classes[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassInfo *classInfo = [UserCenter sharedInstance].curSchool.classes[indexPath.row];
    if(self.completion)
        self.completion(classInfo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
