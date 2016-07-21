//
//  NotificationTargetSelectVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationMemberSelectVC.h"

@interface NotificationMemberSelectVC ()
@property (nonatomic, strong)NSMutableArray *selectArray;
@end

@implementation NotificationMemberSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"家长",@"同事"]];
    [_segmentCtrl setSelectedSegmentIndex:0];
    [_segmentCtrl setWidth:120];
    [self.navigationItem setTitleView:_segmentCtrl];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onConfirm)];
}

- (NSMutableArray *)selectArray{
    if(!_selectArray){
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

#pragma mark - Actions
- (void)onConfirm{
    if(self.selectCompletion){
        self.selectCompletion(self.selectArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
