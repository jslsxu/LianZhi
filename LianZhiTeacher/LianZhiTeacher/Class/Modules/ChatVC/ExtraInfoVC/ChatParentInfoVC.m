//
//  ChatParentInfoVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatParentInfoVC.h"
#import "ContactInfoHeaderCell.h"

@implementation ContactParentChildInfo

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"schools" : [ContactSchoolInfo class]};
}
@end
@implementation ContactParentInfo

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"children" : [ContactParentChildInfo class]};
}
@end

@implementation ContactParentChildCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _avatar = [[AvatarView alloc] initWithRadius:18];
        [_avatar setOrigin:CGPointMake(12, 12)];
        [self addSubview:_avatar];
        
        _infoViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)setChildInfo:(ContactParentChildInfo *)childInfo{
    _childInfo = childInfo;
    [_avatar setImageWithUrl:[NSURL URLWithString:_childInfo.avatar]];
    [_infoViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_infoViewArray removeAllObjects];
    
    for (NSInteger i = 0; i < [ContactParentChildCell infoNumForChild:_childInfo]; i++) {
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(_avatar.right + 24, 45 * i, self.width - (_avatar.right + 24), 45)];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, infoView.width, kLineHeight)];
        [topLine setBackgroundColor:kSepLineColor];
        [infoView addSubview:topLine];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, infoView.height)];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        if(i == 0){
            [titleLabel setText:@"孩子"];
        }
        else if(i == 1){
            [titleLabel setText:@"性别"];
        }
        else if(i == 2){
            [titleLabel setText:@"机构"];
        }
        [infoView addSubview:titleLabel];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right, 0, infoView.width - 10 - titleLabel.right, infoView.height)];
        [infoLabel setFont:[UIFont systemFontOfSize:14]];
        [infoLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [infoLabel setText:[ContactParentChildCell infoForInfo:_childInfo atIndex:i]];
        [infoView addSubview:infoLabel];
        
        [self addSubview:infoView];
        [_infoViewArray addObject:infoView];
    }
}

+ (NSString *)infoForInfo:(ContactParentChildInfo *)childInfo atIndex:(NSInteger)index{
    if(index == 0){
        return childInfo.name;
    }
    else if(index == 1){
        return childInfo.sex == GenderFemale ? @"女" : @"男";
    }
    else{
        NSInteger count = 0;
        for (NSInteger i = 0; i < childInfo.schools.count; i++) {
            ContactSchoolInfo *schoolInfo = childInfo.schools[i];
            for (NSInteger j = 0; j < schoolInfo.classes.count; i++) {
                if(count + i == index){
                    return [NSString stringWithFormat:@"%@  %@",schoolInfo.name, schoolInfo.classes[j]];
                }
            }
            count += schoolInfo.classes.count;
        }
    }
    return nil;
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    ContactParentChildInfo *childInfo = (ContactParentChildInfo *)modelItem;
    return @(45 * [self infoNumForChild:childInfo]);
}

+ (NSInteger)infoNumForChild:(ContactParentChildInfo *)childInfo{
    NSInteger count = 2;
    for (ContactSchoolInfo *schoolInfo in childInfo.schools) {
        count += schoolInfo.classes.count;
    }
    return count;
}

@end

@interface ChatParentInfoVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView*   tableView;
@end

@implementation ChatParentInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细资料";
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + self.parentInfo.children.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return [[ContactInfoHeaderCell cellHeight:nil cellWidth:tableView.width] floatValue];
    }
    else{
        ContactParentChildInfo *childInfo = self.parentInfo.children[indexPath.section - 1];
        return [[ContactParentChildCell cellHeight:childInfo cellWidth:tableView.width] floatValue];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ContactInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactInfoHeaderCell"];
        if(cell == nil){
            cell = [[ContactInfoHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactInfoHeaderCell"];
        }
        [cell setUserInfo:self.parentInfo];
        return cell;
    }
    else{
        ContactParentChildCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactParentChildCell"];
        if(cell == nil){
            cell = [[ContactParentChildCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactParentChildCell"];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section > 0){
        ContactParentChildCell *childCell = (ContactParentChildCell *)cell;
        [childCell setChildInfo:self.parentInfo.children[indexPath.section - 1]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end