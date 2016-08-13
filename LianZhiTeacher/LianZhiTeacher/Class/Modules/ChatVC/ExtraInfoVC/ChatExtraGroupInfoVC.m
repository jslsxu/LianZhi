//
//  ChatExtraGroupInfoVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/3.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatExtraGroupInfoVC.h"
#import "ClassMemberVC.h"
#import "SearchChatMessageVC.h"
@implementation ChatExtraGroupInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self.textLabel setFont:[UIFont systemFontOfSize:15]];
        [self.textLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.textLabel setText:@"群头像"];
        _logoView = [[LogoView alloc] initWithRadius:30];
        [_logoView setOrigin:CGPointMake(self.width - 35 - _logoView.width, (80 - _logoView.height) / 2)];
        [_logoView setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
        [self addSubview:_logoView];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

@end

@interface ChatExtraGroupInfoVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView*   tableView;
@property (nonatomic, strong)UISwitch*      disturbSwitch;
@property (nonatomic, strong)UISwitch*      groupChatSwitch;
@property (nonatomic, strong)NSArray*       memberArray;
@property (nonatomic, copy)NSString*        logoUrl;
@end

@implementation ChatExtraGroupInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"聊天信息";
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)loadData{
    if(self.chatType == ChatTypeClass){
        @weakify(self)
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"app/contact_of_class" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"class_id" : self.groupID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            @strongify(self)
            TNDataWrapper *classWrapper = [responseObject getDataWrapperForKey:@"class"];
            if(classWrapper.count > 0)
            {
                NSMutableArray *sourceArray = [NSMutableArray array];
                TNDataWrapper *teacherArrayWrapper = [classWrapper getDataWrapperForKey:@"teachers"];
                if(teacherArrayWrapper.count > 0)
                {
                    for (NSInteger i = 0; i < teacherArrayWrapper.count; i++)
                    {
                        TNDataWrapper *teacherItemWrapper = [teacherArrayWrapper getDataWrapperForIndex:i];
                        TeacherInfo *teacherInfo = [[TeacherInfo alloc] init];
                        [teacherInfo parseData:teacherItemWrapper];
                        [sourceArray addObject:teacherInfo];
                    }
                }
                
                TNDataWrapper *studentArrayWrapper = [classWrapper getDataWrapperForKey:@"students"];
                if(studentArrayWrapper.count > 0)
                {
                    for (NSInteger i = 0; i < studentArrayWrapper.count; i++)
                    {
                        TNDataWrapper *studentItemWrapper = [studentArrayWrapper getDataWrapperForIndex:i];
                        StudentInfo *studentInfo = [[StudentInfo alloc] init];
                        [studentInfo parseData:studentItemWrapper];
                        [sourceArray addObjectsFromArray:studentInfo.family];
                    }
                }
                self.memberArray = sourceArray;
            }
            
            [self.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
        }];
    }
    else if(self.chatType == ChatTypeGroup){
        for (TeacherGroup *teacherGroup in [UserCenter sharedInstance].curSchool.groups) {
            if([teacherGroup.groupID isEqualToString:self.groupID]){
                self.memberArray = [NSArray arrayWithArray:teacherGroup.teachers];
                [self.tableView reloadData];
            }
        }
    }
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorColor:kSepLineColor];
    }
    return _tableView;
}

- (UISwitch *)disturbSwitch{
    if(_disturbSwitch == nil){
        _disturbSwitch = [[UISwitch alloc] init];
        [_disturbSwitch addTarget:self action:@selector(onDisturbValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _disturbSwitch;
}

- (UISwitch *)groupChatSwitch{
    if(_groupChatSwitch == nil){
        _groupChatSwitch = [[UISwitch alloc] init];
        [_groupChatSwitch addTarget:self action:@selector(onGroupChatValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _groupChatSwitch;
}

- (void)onDisturbValueChanged{
    
}

- (void)onGroupChatValueChanged{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }
    else if(section == 1){
        return 3;
    }
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0)
        return 80;
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0 && row == 0){
        NSString *reuseID = @"ChatExtraGroupInfoCell";
        ChatExtraGroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(nil == cell){
            cell = [[ChatExtraGroupInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        [cell.logoView setImageWithUrl:[NSURL URLWithString:self.logoUrl]];
        return cell;
    }
    else{
//        UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        NSString *reuseID = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(nil == cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
            [cell.textLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        }
        if(section == 0){
            [cell.textLabel setText:[NSString stringWithFormat:@"全部群成员(%zd)",self.memberArray.count]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else if(section == 1){
            if(row == 0){
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textLabel setText:@"消息免打扰"];
                [cell setAccessoryView:self.disturbSwitch];
            }
            else if(row == 1){
                [cell.textLabel setText:@"查找聊天记录"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            else if(row == 2){
                [cell.textLabel setText:@"清空聊天记录"];
                [cell setAccessoryView:nil];
            }
        }
        else if(section == 2){
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.textLabel setText:@"群聊开关"];
            [cell setAccessoryView:self.groupChatSwitch];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0){
        if(row == 0){
            
        }
        else if(row == 1){
            ClassMemberVC *memberVC = [[ClassMemberVC alloc] init];
            if(self.chatType == ChatTypeClass){
                [memberVC setClassID:self.groupID];
            }
            else{
                [memberVC setGroupID:self.groupID];
            }
            [self.navigationController pushViewController:memberVC animated:YES];
        }
    }
    else if(section == 1){
        if(row == 0){
            
        }
        else if(row == 1){
            SearchChatMessageVC*    searchVC = [[SearchChatMessageVC alloc] init];
            [self.navigationController pushViewController:searchVC animated:YES];
        }
        else if(row == 2){
            
        }
    }
    else{
        
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