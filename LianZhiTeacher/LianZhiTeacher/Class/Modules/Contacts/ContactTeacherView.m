//
//  ContactTeacherView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/3.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ContactTeacherView.h"
#import "ContactItemCell.h"
@implementation ContactListHeaderView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
        [self setFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.width - 15 * 2, self.height)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    [_titleLabel setText:_title];
    
}
@end

@interface ContactTeacherView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ContactTeacherView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_tableView setSectionIndexColor:[UIColor colorWithHexString:@"666666"]];
        [self addSubview:_tableView];
    }
    return self;
}

- (void)setTeachers:(NSArray *)teachers{
    _teachers = teachers;
    [_tableView reloadData];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.teachers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ContactGroup *group = [self.teachers objectAtIndex:section];
    return group.contacts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ContactListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ContactListHeaderView"];
    if(headerView == nil){
        headerView = [[ContactListHeaderView alloc] initWithReuseIdentifier:@"ContactListHeaderView"];
    }
    ContactGroup *group = [self.teachers objectAtIndex:section];
    NSString *title = group.key;
    [headerView setTitle:title];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"TeacherCell";
    ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell){
        cell = [[ContactItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    ContactGroup *group = [self.teachers objectAtIndex:indexPath.section];
    TeacherInfo* teacherInfo = group.contacts[indexPath.row];
    if([teacherInfo isKindOfClass:[TeacherInfo class]]){
        [cell setChatCallback:^{
            if(teacherInfo.actived)
            {
                JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
                [chatVC setTo_objid:[UserCenter sharedInstance].curSchool.schoolID];
                [chatVC setTargetID:teacherInfo.uid];
                [chatVC setChatType:ChatTypeTeacher];
                [chatVC setMobile:teacherInfo.mobile];
                NSString *title = teacherInfo.name;
                [chatVC setName:title];
                [ApplicationDelegate popAndPush:chatVC];
            }
        }];
        [cell setTelephoneCallback:^{
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定拨打电话%@吗",teacherInfo.mobile] style:LGAlertViewStyleAlert buttonTitles:@[@"取消", @"拨打电话"] cancelButtonTitle:nil destructiveButtonTitle:nil];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                if(index == 1){
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",teacherInfo.mobile];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }
            }];
            [alertView showAnimated:YES completionHandler:nil];
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactItemCell *itemCell = (ContactItemCell *)cell;
    ContactGroup *group = [self.teachers objectAtIndex:indexPath.section];
    TeacherInfo* teacherInfo = group.contacts[indexPath.row];
    [itemCell setUserInfo:teacherInfo];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray<NSString *> *titleArray = [NSMutableArray array];
    for (ContactGroup *group in self.teachers) {
        [titleArray addObject:group.key];
    }
    return titleArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactGroup *group = [self.teachers objectAtIndex:indexPath.section];
    TeacherInfo *teacher = [group.contacts objectAtIndex:indexPath.row];
    if([teacher isKindOfClass:[TeacherGroup class]])
    {
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setTo_objid:[UserCenter sharedInstance].curSchool.schoolID];
        TeacherGroup *group = (TeacherGroup *)teacher;
        [chatVC setTargetID:group.groupID];
        [chatVC setChatType:ChatTypeGroup];
        [chatVC setName:group.groupName];
        [ApplicationDelegate popAndPush:chatVC];
    }
    else{
        if(teacher.actived){
            JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
            [chatVC setTo_objid:[UserCenter sharedInstance].curSchool.schoolID];
            [chatVC setTargetID:teacher.uid];
            [chatVC setChatType:ChatTypeTeacher];
            [chatVC setMobile:teacher.mobile];
            NSString *title = teacher.name;
            [chatVC setName:title];
            [ApplicationDelegate popAndPush:chatVC];
        }
        else{
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"该用户尚未下载使用连枝，您可打电话与用户联系" style:LGAlertViewStyleAlert buttonTitles:@[@"取消", @"拨打电话"] cancelButtonTitle:nil destructiveButtonTitle:nil];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                if(index == 1){
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",teacher.mobile];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }
            }];
            [alertView showAnimated:YES completionHandler:nil];
        }
    }
}

@end
