//
//  ChatTeacherInfoVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatTeacherInfoVC.h"
#import "ContactInfoHeaderCell.h"
#import "ContactView.h"

@implementation ContactClassInfo

@end
@implementation ContactSchoolInfo

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"classes" : [ContactClassInfo class]};
}

@end

@implementation ContactTeacherInfo

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"schools" : [ContactSchoolInfo class]};
}
@end

@implementation ContactTeacherSchoolCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _classViewArray = [NSMutableArray array];
        
        _logoView = [[LogoView alloc] initWithRadius:25];
        [_logoView setOrigin:CGPointMake(12, 10)];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)setSchoolInfo:(ContactSchoolInfo *)schoolInfo{
    _schoolInfo = schoolInfo;
    [_logoView sd_setImageWithURL:[NSURL URLWithString:_schoolInfo.logo]];
    [_nameLabel setFrame:CGRectMake(_logoView.right + 10, 0, self.width - 10 - (_logoView.right + 10), 70)];
    [_nameLabel setText:_schoolInfo.name];
    [_classViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_classViewArray removeAllObjects];
    for (NSInteger i = 0; i < _schoolInfo.classes.count; i++) {
        ContactClassInfo *classInfo = _schoolInfo.classes[i];
        UIView *classView = [[UIView alloc] initWithFrame:CGRectMake(0, _nameLabel.bottom + 36 * i, self.width, 36)];
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(_logoView.right + 10, 0, classView.width - _logoView.right + 10, kLineHeight)];
        [topLine setBackgroundColor:kSepLineColor];
        [classView addSubview:topLine];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 0, classView.width - 10 - (_logoView.right + 10), classView.height)];
        [nameLabel setFont:[UIFont systemFontOfSize:12]];
        [nameLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [nameLabel setText:[NSString stringWithFormat:@"%@  %@",classInfo.class_name, classInfo.course]];
        [classView addSubview:nameLabel];
        
        [self addSubview:classView];
        [_classViewArray addObject:classView];
    }
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    ContactSchoolInfo *schoolInfo = (ContactSchoolInfo *)modelItem;
    return @(70 + schoolInfo.classes.count * 36);
}

@end

@interface ChatTeacherInfoVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView*   tableView;
@end

@implementation ChatTeacherInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细资料";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
    [self.view addSubview:self.tableView];
    if(!self.teacherInfo){
        if(self.uid.length > 0){
            ContactTeacherInfo *teacherInfo = [[LZKVStorage userKVStorage] storageValueForKey:[self cacheKey]];
            if(teacherInfo){
                if([teacherInfo isKindOfClass:[ContactTeacherInfo class]]){
                    self.teacherInfo = teacherInfo;
                    [self.tableView reloadData];
                    [self showBottomView];
                }
            }
            @weakify(self)
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_teacher_info" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"uid" : self.uid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                @strongify(self)
                self.teacherInfo = [ContactTeacherInfo nh_modelWithJson:responseObject.data];
                [[LZKVStorage userKVStorage] saveStorageValue:self.teacherInfo forKey:[self cacheKey]];
                [self.tableView reloadData];
                [self showBottomView];
            } fail:^(NSString *errMsg) {
                [self showEmptyView:!self.teacherInfo];
            }];
        }
    }
    else{
        [self showBottomView];
    }
}

- (NSString *)cacheKey{
    return [NSString stringWithFormat:@"teacherInfo_%@",self.uid];
}

- (EmptyHintView *)emptyView{
    if(!_emptyView){
        _emptyView = [[EmptyHintView alloc] initWithImage:@"NoInfo" title:@"网络不给力"];
    }
    return _emptyView;
}

- (void)showBottomView{
    ContactView *contactView = [[ContactView alloc] initWithUserInfo:self.teacherInfo];
    [contactView setChatCallback:^{
        [self chat];
    }];
    [contactView setBottom:self.view.height];
    [contactView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:contactView];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, contactView.height, 0)];
}

- (void)chat{
    NSString* toObjid = self.toObjid;
    if([toObjid length] == 0){
        NSArray* childClasses = [UserCenter sharedInstance].curChild.classes;
        for (ContactSchoolInfo* schoolInfo in self.teacherInfo.schools) {
            for (ContactClassInfo *classInfo in schoolInfo.classes) {
                for (ClassInfo *classItem in childClasses) {
                    if([classInfo.class_name isEqualToString:classItem.name] && [schoolInfo.name isEqualToString:classItem.school.schoolName]){
                        toObjid = classItem.classID;
                    }
                }
            }
        }
    }
    JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
    [chatVC setChatType:ChatTypeTeacher];
    [chatVC setTo_objid:toObjid];
    [chatVC setTargetID:self.teacherInfo.uid];
    [chatVC setMobile:self.teacherInfo.mobile];
    [chatVC setName:self.teacherInfo.name];
    //            [CurrentROOTNavigationVC pushViewController:chatVC animated:YES];
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger count = self.teacherInfo.schools.count;
    if(count > 0){
        return 1 + count;
    }
    else
        return 0;
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
        ContactSchoolInfo *schoolInfo = self.teacherInfo.schools[indexPath.section - 1];
        return [[ContactTeacherSchoolCell cellHeight:(TNModelItem *)schoolInfo cellWidth:tableView.width] floatValue];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if(section == 0){
        ContactInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactInfoHeaderCell"];
        if(cell == nil){
            cell = [[ContactInfoHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactInfoHeaderCell"];
        }
        [cell setUserInfo:self.teacherInfo];
        return cell;
    }
    else{
        ContactTeacherSchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTeacherSchoolCell"];
        if(cell == nil){
            cell = [[ContactTeacherSchoolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactTeacherSchoolCell"];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section > 0){
        ContactTeacherSchoolCell *schoolCell = (ContactTeacherSchoolCell *)cell;
        [schoolCell setSchoolInfo:self.teacherInfo.schools[indexPath.section - 1]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
