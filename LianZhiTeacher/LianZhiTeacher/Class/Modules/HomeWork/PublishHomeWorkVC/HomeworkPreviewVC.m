//
//  HomeworkPreviewVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/11/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkPreviewVC.h"
#import "HomeworkDetailView.h"
@interface HomeworkPreviewVC ()
@property (nonatomic, strong)HomeworkItem*              homeworkItem;
@property (nonatomic, strong)HomeworkDetailView*        detailView;
@end

@implementation HomeworkPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作业预览";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    [self.view addSubview:[self detailView]];
}

- (void)setHomeworkEntity:(HomeWorkEntity *)homeworkEntity{
    _homeworkEntity = homeworkEntity;
    HomeworkItem *homeworkItem = [[HomeworkItem alloc] init];
    [homeworkItem setPics:homeworkEntity.imageArray];
    [homeworkItem setWords:homeworkEntity.words];
    [homeworkItem setEtype:homeworkEntity.etype];
    [homeworkItem setCourse_name:homeworkEntity.course_name];
    if([homeworkEntity.voiceArray count] > 0)
        [homeworkItem setVoice:homeworkEntity.voiceArray[0]];
    [homeworkItem setReply_close:homeworkEntity.reply_close];
    [homeworkItem setReply_close_ctime:homeworkEntity.reply_close_ctime];
    
    HomeworkExplainEntity *answer = homeworkEntity.explainEntity;
    if(answer){
        HomeworkItemAnswer *itemAnswer = [[HomeworkItemAnswer alloc] init];
        [itemAnswer setWords:answer.words];
        [itemAnswer setPics:answer.imageArray];
        if([answer.voiceArray count] > 0){
            [itemAnswer setVoice:answer.voiceArray[0]];
        }
        [homeworkItem setAnswer:itemAnswer];
    }
    self.homeworkItem = homeworkItem;
}

- (HomeworkDetailView *)detailView{
    if(_detailView == nil){
        _detailView = [[HomeworkDetailView alloc] initWithFrame:self.view.bounds];
        [_detailView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    }
    [_detailView setHomeworkItem:self.homeworkItem];
    return _detailView;
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



@end
