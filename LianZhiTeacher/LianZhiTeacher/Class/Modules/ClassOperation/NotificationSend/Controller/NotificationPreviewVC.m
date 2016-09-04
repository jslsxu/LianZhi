//
//  NotificationPreviewVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationPreviewVC.h"
#import "NotificationPreviewView.h"
#import "NotificationManager.h"
#import "NotificationDraftManager.h"
@interface NotificationPreviewVC (){
    NotificationPreviewView*     _previewView;
}

@end

@implementation NotificationPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知预览";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    _previewView = [[NotificationPreviewView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_previewView setNotificationSendEntity:self.sendEntity];
    [self.view addSubview:_previewView];
}

- (void)send{
    if(self.sendCallback){
        self.sendCallback();
    }
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
