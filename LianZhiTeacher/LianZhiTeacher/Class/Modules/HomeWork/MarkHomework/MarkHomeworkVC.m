//
//  MarkHomeworkVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MarkHomeworkVC.h"
#import "HomeworkMarkHeaderView.h"
#import "HomeworkMarkFooterView.h"
#import "ZYBannerView.h"


@interface MarkHomeworkVC ()<ZYBannerViewDelegate, ZYBannerViewDataSource, HomeworkMarkHeaderDelegate>
@property (nonatomic, strong)UIView*                    contentView;
@property (nonatomic, strong)HomeworkMarkHeaderView*    headerView;
@property (nonatomic, strong)ZYBannerView*              circleView;
@property (nonatomic, strong)UILabel*                   pageIndicator;
@property (nonatomic, strong)HomeworkMarkFooterView*    footerView;
@property (nonatomic, strong)HomeworkMarkItem*          markItem;
@property (nonatomic, strong)NSMutableDictionary*       markMap;
@end

@implementation MarkHomeworkVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self addKeyboardNotifications];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.markItem = [[HomeworkMarkItem alloc] init];
    self.title = @"批阅作业";
    for (HomeworkStudentInfo *studentInfo in self.homeworkArray) {
        HomeworkTeacherMark* teacherMark = nil;
        if([studentInfo.s_answer.mark_detail length] > 0){
            teacherMark = [HomeworkTeacherMark markWithString:studentInfo.s_answer.mark_detail];
            [teacherMark setRightPercent:[self rightRateWithMark:teacherMark]];
            [studentInfo.s_answer setTeacherMark:teacherMark];
        }
        else{
            teacherMark = [[HomeworkTeacherMark alloc] initWithPhotoArray:studentInfo.s_answer.pics];
        }
        [self.markMap setValue:teacherMark forKey:studentInfo.student.uid];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"批阅" style:UIBarButtonItemStylePlain target:self action:@selector(mark)];
    [self.view addSubview:[self contentView]];
    [self.contentView addSubview:[self headerView]];
    [self.contentView addSubview:[self footerView]];
    [self.contentView addSubview:[self circleView]];
    __weak typeof(self) wself = self;
    [RACObserve(self.circleView.pageControl, numberOfPages) subscribeNext:^(id x) {
        [wself updatePageIndicator];
    }];
    [RACObserve(self.circleView.pageControl, currentPage) subscribeNext:^(id x) {
        [wself updatePageIndicator];
    }];
    [self showHomeworkWithIndex:self.curIndex];
}

- (void)onKeyboardWillShow:(NSNotification *)note{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] delay:0 options:curve.integerValue animations:^{
        [self.contentView setY:-keyboardBounds.size.height];
    } completion:nil];
}

- (void)onKeyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] delay:0 options:curve.integerValue animations:^{
        [self.contentView setY:0];
    } completion:nil];
}

- (void)updatePageIndicator{
    NSInteger total = self.circleView.pageControl.numberOfPages;
    NSInteger curPage = self.circleView.pageControl.currentPage;
    [self.pageIndicator setText:[NSString stringWithFormat:@"%zd/%zd",curPage + 1, total]];
    [self.pageIndicator sizeToFit];
    [self.pageIndicator setFrame:CGRectMake((self.circleView.width - self.pageIndicator.width - 20) / 2, 5, self.pageIndicator.width + 40, 24)];
}

- (NSMutableDictionary *)markMap{
    if(_markMap == nil){
        _markMap = [NSMutableDictionary dictionary];
    }
    return _markMap;
}

- (CGFloat)rightRateWithMark:(HomeworkTeacherMark *)mark{
    CGFloat wrongNum = 0;
    NSInteger totalCount = 0;
    for (HomeworkMarkItem *markItem in mark.marks) {
        for (HomeworkPhotoMark *photoMark in markItem.marks) {
            totalCount ++;
            if(photoMark.markType == MarkTypeWrong){
                wrongNum += 1;
            }
            else if(photoMark.markType == MarkTypeHalfRight){
                wrongNum += 0.5;
            }
        }
    }
    CGFloat rightRate = 1 - wrongNum / self.homeworkItem.enums;
    return MAX(rightRate, 0);
}

- (void)mark{
    __weak typeof(self) wself = self;
//    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
//    if(![studentInfo.s_answer marked]){
//        HomeworkTeacherMark *mark = self.markMap[studentInfo.student.uid];
//        if(![mark isEmpty]){
//            NSString *markDetail = [mark modelToJSONString];
//            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//            [params setValue:markDetail forKey:@"mark_detail"];
//            [params setValue:self.homeworkItem.eid forKey:@"eid"];
//            [params setValue:studentInfo.student.uid forKey:@"child_id"];
//            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/marking" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//                [hud hide:NO];
//                [ProgressHUD showHintText:@"批阅成功"];
//                [studentInfo.s_answer setMark_detail:markDetail];
//                HomeworkTeacherMark *teacherMark = [HomeworkTeacherMark markWithString:markDetail];
//            
//                [teacherMark setRightPercent:[wself rightRateWithMark:teacherMark]];
//                [studentInfo.s_answer setTeacherMark:teacherMark];
//                [wself showHomeworkWithIndex:wself.curIndex];
//                if(wself.markFinishedCallback){
//                    wself.markFinishedCallback();
//                }
//            } fail:^(NSString *errMsg) {
//                [hud hide:NO];
//                [ProgressHUD showError:errMsg];
//            }];
//        }
//        else{
//            [ProgressHUD showHintText:@"没有评语和标注"];
//        }
//       
//    }
    NSMutableArray *answerArray = [NSMutableArray array];
    NSMutableArray *markedArray = [NSMutableArray array];
    for (NSInteger i = 0; i < [self.homeworkArray count]; i++) {
        HomeworkStudentInfo *studentInfo = self.homeworkArray[i];
        if(![studentInfo.s_answer marked]){
            HomeworkTeacherMark *mark = self.markMap[studentInfo.student.uid];
            if(![mark isEmpty]){
                [answerArray addObject:studentInfo];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:studentInfo.student.uid forKey:@"child_id"];
                [dic setValue:mark forKey:@"mark_detail"];
                [markedArray addObject:dic];
            }
        }
    }
    if([markedArray count] > 0){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.homeworkItem.eid forKey:@"eid"];
        [params setValue:[markedArray modelToJSONString] forKey:@"markings"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/bulk_marking" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [hud hide:NO];
            [ProgressHUD showHintText:@"批阅成功"];
            for (NSInteger i = 0; i < [markedArray count]; i++) {
                NSDictionary *dic = markedArray[i];
                HomeworkStudentInfo *studentInfo = answerArray[i];
                NSString* markDetail = [dic[@"mark_detail"] modelToJSONString];
                [studentInfo.s_answer setMark_detail:markDetail];
                HomeworkTeacherMark *teacherMark = [HomeworkTeacherMark markWithString:markDetail];
                [teacherMark setRightPercent:[wself rightRateWithMark:teacherMark]];
                [studentInfo.s_answer setTeacherMark:teacherMark];
            }
            [wself showHomeworkWithIndex:wself.curIndex];
            if(wself.markFinishedCallback){
                wself.markFinishedCallback();
            }

        } fail:^(NSString *errMsg) {
            [hud hide:NO];
            [ProgressHUD showHintText:errMsg];
        }];
    }
    else{
        [ProgressHUD showHintText:@"没有批阅的内容"];
    }
}

- (UIView *)contentView{
    if(_contentView == nil){
        _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    return _contentView;
}

- (HomeworkMarkHeaderView *)headerView{
    if(_headerView == nil){
        _headerView = [[HomeworkMarkHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 110)];
        [_headerView setDelegate:self];
    }
    return _headerView;
}

- (ZYBannerView *)circleView{
    if(_circleView == nil){
        _circleView = [[ZYBannerView alloc] initWithFrame:CGRectMake(0, [self.headerView bottom], self.view.width, self.view.height - 120 - 64 - (self.headerView.bottom))];
        [_circleView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
        [_circleView setDelegate:self];
        [_circleView setDataSource:self];
        [_circleView.pageControl setHidden:YES];
        
        [_circleView addSubview:[self pageIndicator]];
    }
    return _circleView;
}

- (UILabel* )pageIndicator{
    if(_pageIndicator == nil){
        _pageIndicator = [[UILabel alloc] initWithFrame:CGRectZero];
        [_pageIndicator setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [_pageIndicator setTextColor:[UIColor whiteColor]];
        [_pageIndicator setTextAlignment:NSTextAlignmentCenter];
        [_pageIndicator setFont:[UIFont systemFontOfSize:15]];
        [_pageIndicator.layer setCornerRadius:12];
        [_pageIndicator.layer setMasksToBounds:YES];

    }
    return _pageIndicator;
}

- (HomeworkMarkFooterView *)footerView{
    if(_footerView == nil){
        _footerView = [[HomeworkMarkFooterView alloc] initWithFrame:CGRectMake(0, self.view.height - 120 - 64, self.view.width, 120)];
    }
    return _footerView;
}

- (void)showHomeworkWithIndex:(NSInteger)index{
    self.curIndex = index;
    [self.headerView setCanPre:self.curIndex > 0];
    [self.headerView setCanNext:self.curIndex < [self.homeworkArray count] - 1];
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    [self.navigationItem.rightBarButtonItem setEnabled:[studentInfo.s_answer.mark_detail length] == 0];
    
    [self.headerView setStudentHomeworkInfo:studentInfo];
    HomeworkTeacherMark *mark = self.markMap[studentInfo.student.uid];
    BOOL haveMarked = [studentInfo.s_answer.mark_detail length] > 0;
    [self.footerView setTeacherMark:mark];
    [self.footerView setUserInteractionEnabled:!haveMarked];
    [self.footerView clearMark];
    [self.circleView setDataSource:self];
    [self setHomeworkRead:studentInfo];
}

- (void)setHomeworkRead:(HomeworkStudentInfo *)studentInfo{
    __weak typeof(self) wself = self;
    if(studentInfo.unread_t){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.homeworkItem.eid forKey:@"eid"];
        [params setValue:studentInfo.student.uid forKey:@"child_id"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/homework" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            studentInfo.unread_t = NO;
            if(wself.markFinishedCallback){
                wself.markFinishedCallback();
            }
        } fail:^(NSString *errMsg) {
            
        }];
    }
}

#pragma mark - HomeworkMarkHeaderDelegate
- (void)requestPreHomework{
    if(self.curIndex > 0){
        [self showHomeworkWithIndex:self.curIndex - 1];
//        if(self.curIndex == 0){
//            HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
//            if(studentInfo.s_answer.marked){
//                 [ProgressHUD showHintText:@"当前是第一份作业"];
//            }
//            else{
//                 [ProgressHUD showHintText:@"当前是第一份待批阅的作业"];
//            }
//        }
    }
}

- (void)requestNextHomework{
    if(self.curIndex < [self.homeworkArray count] - 1){
        [self showHomeworkWithIndex:self.curIndex + 1];
//        if(self.curIndex == [self.homeworkArray count] - 1){
//            HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
//            if(studentInfo.s_answer.marked){
//                [ProgressHUD showHintText:@"当前是最后一份作业"];
//            }
//            else{
//                [ProgressHUD showHintText:@"当前是最后一份待批阅的作业"];
//            }
//        }
    }
}

#pragma mark - ZYbannerDelegate
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner{
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    HomeworkTeacherMark* teacherMark = self.markMap[studentInfo.student.uid];
    return [teacherMark.marks count];
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index{
    HomeworkPhotoImageView *imageView = [[HomeworkPhotoImageView alloc] initWithFrame:banner.bounds];
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    HomeworkTeacherMark* teacherMark = self.markMap[studentInfo.student.uid];
    [imageView setCanEdit:studentInfo.s_answer.mark_detail.length == 0];
    [imageView setMarkItem:teacherMark.marks[index]];
//    [imageView setAddMarkCallback:^{
//        [wself.footerView clearMark];
//    }];
    return imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
