//
//  ChatParentInfoVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatParentInfoVC.h"
#import "ContactInfoHeaderCell.h"
#import "ContactView.h"

@implementation ContactParentSchoolInfo

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"classes" : [NSString class]};
}

@end

@implementation ContactParentChildInfo

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"schools" : [ContactParentSchoolInfo class]};
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
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarTap)];
        [_avatar addGestureRecognizer:tapGesture];
        
        _infoViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)setChildInfo:(ContactParentChildInfo *)childInfo{
    _childInfo = childInfo;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_childInfo.avatar]];
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

- (void)onAvatarTap{
    [[PBImageController sharedInstance] showForView:_avatar placeHolder:_avatar.image url:self.childInfo.avatar];
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
            ContactParentSchoolInfo *schoolInfo = childInfo.schools[i];
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
    for (ContactParentSchoolInfo *schoolInfo in childInfo.schools) {
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
    if(!self.parentInfo){
        if(self.uid.length > 0){
            ContactParentInfo *parentInfo = [[LZKVStorage userKVStorage] storageValueForKey:[self cacheKey]];
            if(parentInfo){
                if([parentInfo isKindOfClass:[ContactParentInfo class]]){
                    self.parentInfo = parentInfo;
                    [self.tableView reloadData];
                    [self showBottomView];
                }
            }
            @weakify(self)
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_parent_info" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"uid" : self.uid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                @strongify(self)
                self.parentInfo = [ContactParentInfo nh_modelWithJson:responseObject.data];
                if(self.parentInfo){
                    [[LZKVStorage userKVStorage] saveStorageValue:self.parentInfo forKey:[self cacheKey]];
                }
                [self.tableView reloadData];
                [self showBottomView];
            } fail:^(NSString *errMsg) {
                [self showEmptyView:!self.parentInfo];
            }];
        }
    }
    else{
        [self showBottomView];
    }
}

- (EmptyHintView *)emptyView{
    if(!_emptyView){
        _emptyView = [[EmptyHintView alloc] initWithImage:@"NoInfo" title:@"网络不给力"];
    }
    return _emptyView;
}

- (void)showBottomView{
    ContactView *contactView = [[ContactView alloc] initWithUserInfo:self.parentInfo];
    [contactView setChatCallback:^{
        [self chat];
    }];
    [contactView setBottom:self.view.height];
    [contactView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:contactView];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, contactView.height, 0)];
}

- (void)chat{
    JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
    NSString* childID = self.childID;
    if([childID length] == 0){
        for (ContactParentChildInfo* childInfo in self.parentInfo.children) {
            if([self.label containsString:childInfo.name]){
                childID = childInfo.uid;
            }
        }
    }
    [chatVC setTo_objid:childID];
    [chatVC setTargetID:self.parentInfo.uid];
    [chatVC setChatType:ChatTypeParents];
    [chatVC setMobile:self.parentInfo.mobile];
    NSString* name = self.label;
    if([name length] == 0){
        name = self.parentInfo.name;
    }
    [chatVC setName:name];
    [ApplicationDelegate popAndPush:chatVC];
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
         [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setSeparatorColor:kSepLineColor];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

- (NSString *)cacheKey{
    return [NSString stringWithFormat:@"parentInfo_%@",self.uid];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.parentInfo.children.count;
    if(count > 0){
        return 1 + count;
    }
    else{
        return 0;
    }
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
