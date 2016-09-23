//
//  HomeWorkVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeWorkVC.h"
#import "HomeWorkRecordListVC.h"
#import "HomeWorkDraftVC.h"
#import "HomeWorkCollectionVC.h"
@interface HomeWorkVC ()
@property (nonatomic, strong)UISegmentedControl*    segmentCtrl;
@property (nonatomic, strong)HomeWorkRecordListVC*  recordVC;
@property (nonatomic, strong)HomeWorkDraftVC*       draftVC;
@property (nonatomic, strong)HomeWorkCollectionVC*  collectionVC;
@end

@implementation HomeWorkVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.recordVC = [[HomeWorkRecordListVC alloc] init];
        self.draftVC = [[HomeWorkDraftVC alloc] init];
        self.collectionVC = [[HomeWorkCollectionVC alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作业练习";
    [self.navigationItem setTitleView:[self segmentCtrl]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    [self.recordVC.view setFrame:self.view.bounds];
    [self.recordVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.recordVC.view];

    [self.draftVC.view setFrame:self.view.bounds];
    [self.draftVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.draftVC.view];
    [self.draftVC.view setHidden:YES];
    
    [self.collectionVC.view setFrame:self.view.bounds];
    [self.collectionVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.collectionVC.view];
    [self.collectionVC.view setHidden:YES];
}

- (UISegmentedControl *)segmentCtrl{
    if(!_segmentCtrl){
        _segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"记录",@"草稿",@"收藏"]];
        [_segmentCtrl setWidth:kScreenWidth * 2 / 3];
        [_segmentCtrl addTarget:self action:@selector(onSegmentValueChanged) forControlEvents:UIControlEventValueChanged];
        [_segmentCtrl setSelectedSegmentIndex:0];
    }
    return _segmentCtrl;
}

- (void)onSegmentValueChanged{
    NSInteger selectedIndex = self.segmentCtrl.selectedSegmentIndex;
    [self.recordVC.view setHidden:selectedIndex != 0];
    [self.draftVC.view setHidden:selectedIndex != 1];
    [self.collectionVC.view setHidden:selectedIndex != 2];
}

- (void)clear{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
