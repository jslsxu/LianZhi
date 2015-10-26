//
//  HomeWorkVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "CourseListVC.h"
#import "HomeWorkVC.h"
@implementation CourseItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.courseID = [dataWrapper getStringForKey:@"course_id"];
    self.courseName = [dataWrapper getStringForKey:@"course_name"];
    self.hasNew = [dataWrapper getBoolForKey:@"has_new"];
    self.courseLogo = [dataWrapper getStringForKey:@"logo"];
}

@end

@implementation CourseListModel

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        NSArray *titleArray = @[@"语文",@"数学",@"英语"];
        for (NSInteger i = 0; i < titleArray.count; i++)
        {
            CourseItem *courseItem = [[CourseItem alloc] init];
            [courseItem setCourseName:titleArray[i]];
            [self.modelItemArray addObject:courseItem];
        }
    }
    return self;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    return YES;
}

@end

@implementation CourseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        
        _typeView = [[UILabel alloc] initWithFrame:CGRectMake(15, (70 - 40) / 2, 40, 40)];
        [_typeView setBackgroundColor:kCommonParentTintColor];
        [_typeView setTextColor:[UIColor whiteColor]];
        [_typeView setFont:[UIFont systemFontOfSize:24]];
        [_typeView setTextAlignment:NSTextAlignmentCenter];
        [_typeView.layer setBorderWidth:2];
        [_typeView.layer setCornerRadius:20];
        [_typeView.layer setBorderColor:[UIColor colorWithRed:20 / 255.f green:141 / 255.f blue:95 / 255.f alpha:1.f].CGColor];
        [_typeView.layer setMasksToBounds:YES];
        [self addSubview:_typeView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, self.width - 10 - 65, 15)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_nameLabel];
        
        _teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 35, self.width - 10 - 65, 15)];
        [_teacherLabel setFont:[UIFont systemFontOfSize:12]];
        [_teacherLabel setTextColor:[UIColor colorWithHexString:@"8e8e8e"]];
        [self addSubview:_teacherLabel];
        
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        [_redDot setBackgroundColor:[UIColor redColor]];
        [_redDot.layer setCornerRadius:4];
        [_redDot.layer setMasksToBounds:YES];
        [_redDot setOrigin:CGPointMake(_typeView.right - _redDot.width - 2,_typeView.y + 2)];
        [self addSubview:_redDot];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    CourseItem *courseItem = (CourseItem *)modelItem;
    
    [_typeView setText:@"语"];
    [_nameLabel setText:courseItem.courseName];
    [_teacherLabel setText:courseItem.courseName];
//    [_redDot setHidden:!courseItem.hasNew];
}

@end

@interface CourseListVC ()

@end

@implementation CourseListVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.cellName = @"CourseCell";
        self.modelName = @"CourseListModel";
        self.title = @"作业练习";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    return nil;
}

- (void)TNBaseCollectionViewControllerModifyLayout:(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
    [flowLayout setSectionInset:UIEdgeInsetsMake(15, 12, 15, 12)];
    [flowLayout setItemSize:CGSizeMake((self.view.width - 15 * 2) / 2, 70)];
    [flowLayout setMinimumLineSpacing:5];
    [flowLayout setMinimumInteritemSpacing:0];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    CourseItem *courseItem = (CourseItem *)modelItem;
    
    HomeWorkVC *homeWorkVC = [[HomeWorkVC alloc] init];
    [homeWorkVC setCourseID:courseItem.courseID];
    [homeWorkVC setTitle:courseItem.courseName];
    [self.navigationController pushViewController:homeWorkVC animated:YES];
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
