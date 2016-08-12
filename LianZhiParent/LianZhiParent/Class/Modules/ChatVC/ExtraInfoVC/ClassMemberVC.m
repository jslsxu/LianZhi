//
//  ClassMemberVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/14.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassMemberVC.h"
#import "JSMessagesViewController.h"
@implementation MemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSize:CGSizeMake(kScreenWidth, 50)];
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(15, (self.height - 32) / 2, 32, 32)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 180, self.height)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}
- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    [_nameLabel setText:_userInfo.name];
    [_avatarView setImageWithUrl:[NSURL URLWithString:_userInfo.avatar]];
    [_avatarView setStatus:_userInfo.actived ? nil : @"未下载"];
}

@end

@interface ClassMemberVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic, strong)UITableView*   tableView;
@end

@implementation ClassMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.atCallback && self.cancelCallback){
        self.title = @"选择提醒的人";
        self.navigationItem.leftBarButtonItem  =[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
    else{
        self.title = @"群成员";
    }
    
    self.sourceArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor colorWithHexString:@"666666"]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    [self loadData];
}

- (void)dismiss{
    if(self.cancelCallback){
        self.cancelCallback();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)sourceArray{
    if(_sourceArray == nil){
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}
- (void)loadData{
    if(self.classID)
    {
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        [params setValue:self.classID forKey:@"class_id"];
//        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"app/contact_of_class" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//            @strongify(self)
//            TNDataWrapper *classWrapper = [responseObject getDataWrapperForKey:@"class"];
//            NSArray *teacherArray = [TeacherInfo nh_modelArrayWithJson:[classWrapper getDataWrapperForKey:@"teachers"].data];
//            NSArray *studentArray = [ChildInfo nh_modelArrayWithJson:[classWrapper getDataWrapperForKey:@"students"].data];
//            [self.sourceArray addObjectsFromArray:teacherArray];
//            for (ChildInfo *studentInfo in studentArray) {
//                if(studentInfo.family.count > 0){
//                    [self.sourceArray addObjectsFromArray:studentInfo.family];
//                }
//            }
//            [self.tableView reloadData];
//        } fail:^(NSString *errMsg) {
//            
//        }];
        for (ClassInfo *classInfo in [UserCenter sharedInstance].curChild.classes) {
            if([classInfo.classID isEqualToString:self.classID]){
                [self.sourceArray addObjectsFromArray:classInfo.teachers];
                for (ChildInfo *childInfo in classInfo.students) {
                    [self.sourceArray addObjectsFromArray:childInfo.family];
                }
            }
        }
        [self.tableView reloadData];
    }

}

#pragma mark


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MemberCell";
    MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[MemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    UserInfo *userInfo = self.sourceArray[indexPath.row];
    [cell setUserInfo:userInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfo *userInfo = self.sourceArray[indexPath.row];
    if(self.atCallback){
        self.atCallback(userInfo);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
