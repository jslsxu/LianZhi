//
//  ClassSelectionVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassSelectionVC.h"
#import "LZMicrolessonVCViewController.h"
#define kRedDotTag                      1000
@interface ClassSelectionVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSArray *classArray;
@end

@implementation ClassSelectionVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
    }
    return self;
}

- (void)onStatusChanged
{
//    if(self.classDic)
//    {
//        if(self.isHomework)
//        {
//            self.classDic = [NSMutableDictionary dictionary];
//            for (NSString *key in [UserCenter sharedInstance].statusManager.appPractice.allKeys) {
//                NSInteger num = [[UserCenter sharedInstance].statusManager.appPractice[key] integerValue];
//                if(num > 0)
//                    [self.classDic setValue:@"" forKey:key];
//            }
//
//            [_tableView reloadData];
//        }
//        else
//        {
//            if(self.validateStatus){
//                self.classDic = self.validateStatus();
//            }
////            NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
//////            NSArray *feedClassNewArray = [UserCenter sharedInstance].statusManager.feedClassesNew;
////            NSArray *classNewCommentArray = [UserCenter sharedInstance].statusManager.classNewCommentArray;
////            for (ClassInfo *classInfo in [UserCenter sharedInstance].curChild.classes)
////            {
////                NSString *classID = classInfo.classID;
////                NSString *badge = nil;
////                NSInteger count = 0;
////                for (TimelineCommentItem *commentItem in classNewCommentArray)
////                {
////                    if([commentItem.objid isEqualToString:classID])
////                        count += commentItem.alertInfo.num;
////                }
////                if(count > 0)
////                    badge = kStringFromValue(count);
////                else
////                {
////                    count += [[UserCenter sharedInstance].statusManager newCountForClassFeed];
//////                    for (ClassFeedNotice *notice in feedClassNewArray)
//////                    {
//////                        if([notice.classID isEqualToString:classID] && [notice.childID isEqualToString:[UserCenter sharedInstance].curChild.uid])
//////                            count += notice.num;
//////                    }
////                    if(count > 0)
////                        badge = @"";
////                }
////                [classDic setValue:badge forKey:classID];
////            }
////            self.classDic = classDic;
//            [_tableView reloadData];
//        }
//    }
    if(self.validateStatus){
        self.classDic = self.validateStatus();
    }
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我所有的班";
    
    self.classArray = [UserCenter sharedInstance].curChild.classes;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:kSepLineColor];
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableviewdele

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return kSectionHeaderHeight;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSDictionary *groupDic = self.classArray[section];
//    NSString *title = groupDic[@"groupName"];
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, kSectionHeaderHeight)];
//    [headerView setBackgroundColor:[UIColor whiteColor]];
//
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.width - 15, headerView.height)];
//    [titleLabel setTextColor:[UIColor colorWithHexString:@"8e8e8e"]];
//    [titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [titleLabel setText:title];
//    [headerView addSubview:titleLabel];
//
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height - kLineHeight, headerView.width, kLineHeight)];
//    [bottomLine setBackgroundColor:kSepLineColor];
//    [headerView addSubview:bottomLine];
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        [cell setWidth:kScreenWidth];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setTextColor:kCommonParentTintColor];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
        
        NumIndicator *indicator = [[NumIndicator alloc] init];
        [indicator setTag:kRedDotTag];
        [cell addSubview:indicator];
    }
    ClassInfo *classInfo = self.classArray[indexPath.row];
    [cell.textLabel setText:classInfo.name];
    NSString *badge = self.classDic[classInfo.classID];
    NumIndicator *indicator = [cell viewWithTag:kRedDotTag];
    [indicator setIndicator:badge];
    [indicator setHidden:!badge];
    [indicator setCenter:CGPointMake(cell.width - 40, cell.height / 2)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassInfo *classInfo = self.classArray[indexPath.row];
    self.originalClassID = classInfo.classID;
    [tableView reloadData];
    if(self.selection)
        self.selection(classInfo);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
