//
//  HomeWorkHistoryVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkHistoryVC.h"

@interface HomeWorkHistoryVC ()<ActionSelectViewDelegate>
@property (nonatomic, copy)NSString *course;
@property (nonatomic, strong)NSMutableArray *courseArray;
@end

@implementation HomeWorkHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.courseArray = [NSMutableArray array];
    for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.classes)
    {
        BOOL isIn = NO;
        for (NSString * course in self.courseArray)
        {
            if([course isEqualToString:classInfo.course])
                isIn = YES;
        }
        if(!isIn)
            [self.courseArray addObject:classInfo.course];
    }
    if(self.courseArray.count > 0)
        self.course = self.courseArray[0];
    if(self.courseArray.count > 0)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStylePlain target:self action:@selector(switchCourse)];
    
    self.title = self.course;
    
    [self bindTableCell:@"HomeWorkHistoryCell" tableModel:@"HomeWorkHistoryModel"];
    [self requestData:REQUEST_REFRESH];
}

- (void)switchCourse
{
    ActionSelectView *selectView = [[ActionSelectView alloc] init];
    [selectView setDelegate:self];
    [selectView show];
}

#pragma mark - ActionSelectDelegate
- (NSInteger)pickerView:(ActionSelectView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.courseArray.count;
}

- (NSString *)pickerView:(ActionSelectView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.courseArray[row];
}

- (void)pickerViewFinished:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.course = self.courseArray[row];
    self.title = self.course;
    [self requestData:REQUEST_REFRESH];
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
