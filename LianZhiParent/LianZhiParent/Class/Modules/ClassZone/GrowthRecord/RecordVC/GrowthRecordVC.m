//
//  GrowthRecordVC.m
//  LianZhiParent
//
//  Created by jslsxu on 17/2/6.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "GrowthRecordVC.h"
#import "Calendar.h"
#import "ChildGrowthInfoView.h"
#import "RecordReplyVC.h"
#import "ChildPhotoView.h"
@interface GrowthRecordVC ()<CalendarDelegate>
@property (nonatomic, strong)Calendar* calendar;
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)ChildGrowthInfoView* infoView;
@property (nonatomic, strong)ChildPhotoView* photoView;
@end

@implementation GrowthRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"家园手册"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"回复" style:UIBarButtonItemStylePlain target:self action:@selector(reply)];
    [self.view addSubview:[self calendar]];
    [self.view addSubview:[self scrollView]];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (UIScrollView *)scrollView{
    if(nil == _scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.calendar.bottom, self.view.width, self.view.height - self.calendar.bottom)];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setAlwaysBounceVertical:YES];
        
        [_scrollView addSubview:[self infoView]];
        [_scrollView addSubview:[self photoView]];
        [self setupScrollContent];
    }
    return _scrollView;
}

- (ChildGrowthInfoView *)infoView{
    if(nil == _infoView){
        _infoView = [[ChildGrowthInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    return _infoView;
}

- (ChildPhotoView *)photoView{
    if(nil == _photoView){
        _photoView = [[ChildPhotoView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    return _photoView;
}

- (void)setupScrollContent{
    CGFloat spaceYStart = 0;
    [self.infoView setY:spaceYStart];
    spaceYStart = self.infoView.bottom;
    
    [self.photoView setY:spaceYStart];
    spaceYStart = self.photoView.bottom;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width, spaceYStart)];
}

- (void)requestGrowthRecord{
    
}

- (void)reply{
    RecordReplyVC* recordReplyVC = [[RecordReplyVC alloc] init];
    TNBaseNavigationController* nav = [[TNBaseNavigationController alloc] initWithRootViewController:recordReplyVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - CalendarDelegate
- (void)calendarDateDidChange:(NSDate *)selectedDate{
    [self requestGrowthRecord];
}

- (void)calendarHeightWillChange:(CGFloat)height{
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setFrame:CGRectMake(0, height, self.view.width, self.view.height - height)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
