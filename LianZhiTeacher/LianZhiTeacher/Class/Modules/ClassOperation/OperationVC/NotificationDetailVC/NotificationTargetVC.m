//
//  NotificationTargetVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/8.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "NotificationTargetVC.h"

@interface NotificationTargetVC ()
@property (nonatomic, strong)NSArray *originalArray;
@end

@implementation NotificationTargetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.classes)
    {
        if([self.groupID isEqualToString:classInfo.classID])
            self.originalArray = classInfo.students;
    }
    for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.managedClasses)
    {
        if([self.groupID isEqualToString:classInfo.classID])
            self.originalArray = classInfo.students;
    }
    for (TeacherGroup *group in [UserCenter sharedInstance].curSchool.groups)
    {
        if([self.groupID isEqualToString:group.groupID])
            self.originalArray = group.teachers;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

- (BOOL)isChecked:(NSString *)individualID
{
    if(self.selectedArray.count == 0)
        return YES;
    for (NSString *studentID in self.selectedArray)
    {
        if([studentID isEqualToString:individualID])
            return YES;
    }
    return NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.originalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"NotificationStudentCell";
    NotificationStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil)
    {
        cell = [[NotificationStudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    TNModelItem *item = self.originalArray[indexPath.row];
    if([item isKindOfClass:[StudentInfo class]])
        [cell setChecked:[self isChecked:[(StudentInfo *)item uid]]];
    else
        [cell setChecked:[self isChecked:[(TeacherInfo *)item uid]]];
    [cell onReloadData:item];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
