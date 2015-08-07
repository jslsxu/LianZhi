//
//  ClassOperationVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/3.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassOperationVC.h"
#define kClassOperationShow             @"ClassOperationShow"

@interface ClassOperationVC ()
@property (nonatomic, strong)ClassOperationHeaderView *headerView;
@property (nonatomic, strong)UICollectionView*         collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout * layout;
@property (nonatomic, strong)UITableView*                 tableView;
@property (nonatomic, strong)ClassBatOperationView*       batOperationView;
@property (nonatomic, strong)ClassInfo *classInfo;
@end

@implementation ClassOperationVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL classOperationShow = [[userDefaults valueForKey:kClassOperationShow] boolValue];
    if(classOperationShow == NO)
    {
        [self addUserGuide];
        classOperationShow = YES;
        [userDefaults setValue:@(classOperationShow) forKey:kClassOperationShow];
        [userDefaults synchronize];
    }
    [self updateStudentsStatus];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _publishPool = [[NSMutableArray alloc] initWithCapacity:0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:kReachabilityChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:kPersonalSettingChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
        self.shouldShowEmptyHint = YES;
    }
    return self;
}

- (void)onNetworkStatusChanged
{
    Reachability* curReach = ApplicationDelegate.hostReach;
    NetworkStatus status = [curReach currentReachabilityStatus];
    if(status == ReachableViaWiFi || (status == ReachableViaWWAN && ![UserCenter sharedInstance].personalSetting.wifiSend))
    {
        for (NSDictionary *item in _publishPool) {
            [self postItem:item delay:YES];
        }
        [_publishPool removeAllObjects];
    }
}

- (void)setupSubviews
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.headerView = [[ClassOperationHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 95)];
    [self.headerView setDelegate:self];
    [self.view addSubview:self.headerView];
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    [self.layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.layout setItemSize:CGSizeMake(65, 90)];
    [self.layout setMinimumInteritemSpacing:6];
    [self.layout setMinimumLineSpacing:0];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(11, self.headerView.bottom, self.view.width - 11 * 2, self.view.height - self.headerView.bottom) collectionViewLayout:_layout];
    [self.collectionView setContentInset:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView registerClass:[StudentGridView class] forCellWithReuseIdentifier:@"StudentGridView"];
    [self.view addSubview:self.collectionView];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.view.width, self.collectionView.height) style:UITableViewStylePlain];
    [self.tableView setContentInset:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [self.tableView setHidden:YES];
    
    self.batOperationView = [[ClassBatOperationView alloc] initWithFrame:CGRectMake(0, -72, self.collectionView.width, 60)];
    [self.batOperationView setDelegate:self];
    [self.collectionView addSubview:self.batOperationView];
    
    [self setClassInfo:[UserCenter sharedInstance].curSchool.classes[0]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)addUserGuide
{
    UIView *parentView = [UIApplication sharedApplication].keyWindow;
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton addTarget:self action:@selector(onCoverButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setFrame:parentView.bounds];
    [coverButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [parentView addSubview:coverButton];
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClassOperationGuide1.png"]];
    [image1 setOrigin:CGPointMake((coverButton.width - image1.width) / 2 + 20, 150)];
    [coverButton addSubview:image1];
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClassOperationGuide2.png"]];
    [image2 setOrigin:CGPointMake(20, 220)];
    [coverButton addSubview:image2];

    UIImageView *image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClassOperationGuide3.png"]];
    [image3 setOrigin:CGPointMake((coverButton.width - image3.width) / 2, 320)];
    [coverButton addSubview:image3];

}

- (void)onCurSchoolChanged
{
    [self setupSubviews];
}

- (void)onCoverButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button removeFromSuperview];
}

- (void)updateStudentsStatus
{
    //更新班级学生状态
    if([self.classInfo.classID integerValue] > 0)
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.classInfo.classID forKey:@"class_id"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/info" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            TNDataWrapper *studentsWrapper = [responseObject getDataWrapperForKey:@"students"];
            for (NSInteger i = 0; i < studentsWrapper.count; i++) {
                TNDataWrapper *studentWrapper = [studentsWrapper getDataWrapperForIndex:i];
                for (StudentInfo *studentInfo in self.classInfo.students) {
                    NSString *stuID = [studentWrapper getStringForKey:@"id"];
                    if([stuID isEqualToString:studentInfo.uid])
                    {
                        studentInfo.attention = [studentWrapper getIntegerForKey:@"attention"];
                    }
                }
            }
            
            [self.classInfo.students sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                StudentInfo *stu1 = (StudentInfo *)obj1;
                StudentInfo *stu2 = (StudentInfo *)obj2;
                if(stu1.attention > stu2.attention)
                    return NSOrderedDescending;
                else if(stu1.attention == stu2.attention)
                    return NSOrderedSame;
                else
                    return NSOrderedAscending;
            }];
            [[UserCenter sharedInstance] save];
            
            [self.collectionView reloadData];
            self.classInfo.recordEnabled = [responseObject getBoolForKey:@"record_enabled"];
//            [[UserCenter sharedInstance] save];
            [self.batOperationView setGrowthRecord:self.classInfo.recordEnabled];
        } fail:^(NSString *errMsg) {
            
        }];
    }
    else
    {
        [self.batOperationView setGrowthRecord:NO];
    }

}


- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [self.headerView setClassInfo:_classInfo];
    [self.collectionView setContentInset:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.tableView setContentInset:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.batOperationView reset];
    if([_classInfo.classID isEqualToString:@"-1"])//全部
    {
        [self.collectionView setHidden:YES];
        [self.batOperationView removeFromSuperview];
        [self.tableView setHidden:NO];
        self.batOperationView.x = (self.tableView.width - self.batOperationView.width) / 2;
        [self.tableView addSubview:self.batOperationView];
        [self.tableView reloadData];
        
        [self showEmptyLabel:[UserCenter sharedInstance].curSchool.classes.count == 0];
    }
    else
    {
        [self.tableView setHidden:YES];
        [self.batOperationView removeFromSuperview];
        [self.collectionView setHidden:NO];
        self.batOperationView.x = (self.collectionView.width - self.batOperationView.width) / 2;
        [self.collectionView addSubview:self.batOperationView];
        [self.collectionView reloadData];
        
        [self showEmptyLabel:self.classInfo.students.count == 0];
    }
    [self updateStudentsStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postItem:(NSDictionary *)itemParams delay:(BOOL)delay
{
    NSDictionary *params = [NSMutableDictionary dictionaryWithDictionary:itemParams[kNormalParamsKey]];
    NSArray *imageArray = itemParams[kImageArrayKey];
    NSString *url = itemParams[kPostUrlKey];
    NetworkStatus status = [ApplicationDelegate.hostReach currentReachabilityStatus];
    BOOL notice = (status == ReachableViaWiFi && [UserCenter sharedInstance].personalSetting.wifiSend && delay);
    if(notice)
        [params setValue:@"1" forKey:@"onlywifi_notice"];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:url withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSInteger i = 0; i < [imageArray count]; i++) {
            PublishImageItem *imageItem = [imageArray objectAtIndex:i];
            NSString *photoKey = imageItem.photoKey;
            if(imageItem.image)
                [formData appendPartWithFileData:UIImageJPEGRepresentation(imageItem.image, 0.8) name:photoKey fileName:photoKey mimeType:@"image/jpeg"];
        }
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if(notice)
            [[NSNotificationCenter defaultCenter] postNotificationName:kPublishPhotoItemFinishedNotification object:nil userInfo:nil];
        [ProgressHUD showHintText:@"照片发送成功"];
    } fail:^(NSString *errMsg) {
    }];

}

#pragma mark - PhotoOperationDelegate
- (void)photoOperationDidFinished:(NSDictionary *)itemParams
{
    NetworkStatus networkStatus = ApplicationDelegate.hostReach.currentReachabilityStatus;
    
    if(networkStatus == ReachableViaWiFi || (networkStatus == ReachableViaWWAN && ![UserCenter sharedInstance].personalSetting.wifiSend))//能直接发送，直接发送
    {
        [self postItem:itemParams delay:NO];
    }
    else//添加到队列等待发送
    {
        if(([ApplicationDelegate.hostReach currentReachabilityStatus] == ReachableViaWWAN && [UserCenter sharedInstance].personalSetting.wifiSend))
        {
            NSArray *imageArray = itemParams[kImageArrayKey];
            
            [ProgressHUD showHintText:[NSString stringWithFormat:@"为了帮您节省流量，您本次分享的%ld张照片将在有wifi环境时自动上传，在此之前请勿删除本地相册中的内容",(long)[imageArray count]]];
            [_publishPool addObject:itemParams];
        }

    }
}

#pragma mark - UICOllectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.classInfo.students.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    StudentGridView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StudentGridView" forIndexPath:indexPath];
    StudentInfo *studentIno = self.classInfo.students[indexPath.row];
    if(indexPath.row == 0)
        studentIno.showFocus = YES;
    else
        studentIno.showFocus = NO;
    [cell setStudentInfo:studentIno];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    StudentInfo *student = self.classInfo.students[indexPath.row];
    if(self.batOperationView.show == NO)
    {
        IndividualOperationView *operationView = [[IndividualOperationView alloc] initWithFrame:CGRectZero andClassInfo:self.classInfo];
        [operationView setStudentInfo:student];
//        [operationView setClassInfo:self.classInfo];
        [operationView fadeIn];
    }
    else//批处理,选中
    {
        [student setSelected:!student.selected];
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        [self.batOperationView setSourceArray:self.classInfo.students];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [UserCenter sharedInstance].curSchool.classes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ClassTableCell";
    ClassTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(nil == cell)
    {
        cell = [[ClassTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setClassInfo:[UserCenter sharedInstance].curSchool.classes[indexPath.section]];
    [cell setCellType:TableViewCellTypeSingle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
    ClassInfo *classInfo = classes[indexPath.section];
    if(self.batOperationView.show == NO)
    {
        [self setClassInfo:classInfo];
    }
    else
    {
        classInfo.selected = !classInfo.selected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.batOperationView setSourceArray:classes];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if(offset.y < -50)
    {
        UIEdgeInsets contentInset = scrollView.contentInset;
        if(contentInset.top != 72)
        {
             contentInset.top = 72;
            if(scrollView == self.tableView)
            {
                NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
                for (ClassInfo *classInfo in classes) {
                    [classInfo setCanSelected:YES];
                }
                [self.tableView reloadData];
            }
            [UIView animateWithDuration:0.3 animations:^{
                [self.batOperationView setShow:YES];
                if(scrollView == self.collectionView)
                    [self.batOperationView setSourceArray:self.classInfo.students];
                else
                    [self.batOperationView setSourceArray:[UserCenter sharedInstance].curSchool.classes];
                [scrollView setContentOffset:CGPointMake(0, -contentInset.top)];
                [scrollView setContentInset:contentInset];
            }];
        }
    }
}

#pragma mark - ClassBatOperationDelegate
- (void)classBatOperationCancel
{
    UIScrollView *scrollView = self.collectionView.hidden ? self.tableView : self.collectionView;
    UIEdgeInsets contentInset = scrollView.contentInset;
    contentInset.top = 30;
    [UIView animateWithDuration:0.3 animations:^{
        [self.batOperationView reset];
        [scrollView setContentInset:contentInset];
    }];
    if(self.tableView == scrollView)
    {
        NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
        for (ClassInfo *classInfo in classes) {
            [classInfo setCanSelected:NO];
            [classInfo setSelected:NO];
        }
        [self.tableView reloadData];
    }
    else if (scrollView == self.collectionView)
    {
        NSArray *students = self.classInfo.students;
        for (StudentInfo *student in students) {
            [student setSelected:NO];
        }
        [self.collectionView reloadData];
    }

}

- (BOOL)checkSelectedItems
{
    NSInteger num = 0;
    NSString *alertStr = nil;
     if([self.headerView.classInfo.classID isEqualToString:@"-1"])//选择班级
     {
         NSArray *classes = [self.batOperationView sourceArray];
         for (ClassInfo *classInfo in classes) {
             if(classInfo.selected)
                 num++;
         }
         if(num == 0)
             alertStr = @"你还没有选择班级";
     }
    else
    {
        NSArray *students = [self.batOperationView sourceArray];
        for (StudentInfo *studentInfo in students) {
            if(studentInfo.selected)
                num++;
        }
        if(num == 0)
            alertStr = @"你还没有选择学生";
    }
    if(num == 0)
    {
        TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"确定" action:^{
            
        }];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:alertStr buttonItems:@[confirmItem]];
        [alertView show];
        return NO;
    }
    return YES;
}

- (NSArray *)targetArray
{
    NSMutableArray *targetArray = [[NSMutableArray alloc] init];
    if([self.headerView.classInfo.classID isEqualToString:@"-1"])//选择班级
    {
        NSArray *classes = [self.batOperationView sourceArray];
        for (ClassInfo *classInfo in classes) {
            if(classInfo.selected)
                [targetArray addObject:classInfo];
        }
    }
    else
    {
        NSArray *students = [self.batOperationView sourceArray];
        for (StudentInfo *studentInfo in students) {
            if(studentInfo.selected)
                [targetArray addObject:studentInfo];
        }
    }
    return targetArray;

}

- (NSDictionary *)targetDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if([self.headerView.classInfo.classID isEqualToString:@"-1"])//选择班级
    {
        NSMutableString *classStr = [NSMutableString string];
        NSArray *classes = [self.batOperationView sourceArray];
        for (NSInteger i =0 ; i < classes.count; i++) {
            ClassInfo *classInfo = [classes objectAtIndex:i];
            if(classInfo.selected)
            {
                if(classStr.length == 0)
                    [classStr appendString:classInfo.classID];
                else
                    [classStr appendFormat:@",%@",classInfo.classID];
            }
        }
        if(classStr.length > 0)
            [dictionary setValue:classStr forKey:@"class_ids"];
    }
    else
    {
        [dictionary setValue:self.headerView.classInfo.classID forKey:@"class_id"];
        NSArray *students = [self.batOperationView sourceArray];
        NSMutableString *studentStr = [NSMutableString string];
        for (NSInteger i =0 ; i < students.count; i++) {
            StudentInfo *studentInfo = [students objectAtIndex:i];
            if(studentInfo.selected)
            {
                if(studentStr.length == 0)
                    [studentStr appendString:studentInfo.uid];
                else
                    [studentStr appendFormat:@",%@",studentInfo.uid];
            }
        }
        if(studentStr.length > 0)
            [dictionary setValue:studentStr forKey:@"student_ids"];
    }
    return dictionary;
}
- (void)classBatOperationOnMessage
{
    if([self checkSelectedItems])
    {
        MessageOperationVC *messageOperationVC = [[MessageOperationVC alloc] init];
        [messageOperationVC setTargetDic:[self targetDictionary]];
        TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:messageOperationVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)classBatOperationOnPhotoShare
{
    if([self checkSelectedItems])
    {
        
        PhotoOperationVC *photoOperationVC = [[PhotoOperationVC alloc] init];
        [photoOperationVC setClassInfo:self.classInfo];
        [photoOperationVC setTargetArray:[self targetArray]];
        TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:photoOperationVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)classBatOperationOnGrowthTimeline
{
    if([self checkSelectedItems])
    {
        NSMutableArray *selectedStudents = [[NSMutableArray alloc] init];
        NSArray *students = [self.batOperationView sourceArray];
        for (StudentInfo *studentInfo in students) {
            if(studentInfo.selected)
                [selectedStudents addObject:studentInfo];
        }
        GrowthTimelinePublishVC *growthTimelineVC = [[GrowthTimelinePublishVC alloc] init];
        [growthTimelineVC setClassInfo:self.classInfo];
        [growthTimelineVC setStudents:selectedStudents];
        TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:growthTimelineVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)classBatOperationSelectAll
{
    [self.collectionView reloadData];
    [self.tableView reloadData];
}

#pragma mark - ClassOperationDelegate
- (void)classSwitch:(ClassOperationHeaderView *)headerView
{
    ActionSelectView *selectView = [[ActionSelectView alloc] init];
    [selectView setDelegate:self];
    [selectView show];
}

#pragma mark - ActionSelectViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(ActionSelectView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(ActionSelectView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
    NSInteger rowNum = classes.count;
    if(rowNum > 1)
        rowNum ++;
    return rowNum;
}

- (NSString *)pickerView:(ActionSelectView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
    if(row < classes.count)
    {
        ClassInfo *classInfo = classes[row];
        return classInfo.className;
    }
    return @"我所有的班";
}

- (void)pickerView:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (void)pickerViewFinished:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
    ClassInfo *classInfo;
    if(row < classes.count)
    {
        classInfo = classes[row];
    }
    else
    {
        classInfo = [[ClassInfo alloc] init];
        [classInfo setClassName:@"全部班级"];
        [classInfo setClassID:@"-1"];
    }
    [self setClassInfo:classInfo];
    
}

@end
