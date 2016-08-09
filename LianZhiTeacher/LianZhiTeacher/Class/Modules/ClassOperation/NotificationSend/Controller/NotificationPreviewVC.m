//
//  NotificationPreviewVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationPreviewVC.h"
#import "NotificationDetailView.h"
@interface NotificationPreviewVC (){
    NotificationDetailView*     _detailView;
}

@end

@implementation NotificationPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知预览";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    _detailView = [[NotificationDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_detailView setNotificationSendEntity:self.sendEntity];
    [self.view addSubview:_detailView];
}

- (void)send{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *classesArray = [NSMutableArray array];
    for (ClassInfo *classInfo in self.sendEntity.classArray) {
        NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
        if(classInfo.selected){
            [classDic setValue:classInfo.classID forKey:@"classid"];
        }
        else{
            NSMutableArray *selectedStudents = [NSMutableArray array];
            for (StudentInfo *studentInfo in classInfo.students) {
                if(studentInfo.selected){
                    [selectedStudents addObject:studentInfo.uid];
                }
            }
            if(selectedStudents.count > 0){
                [classDic setValue:classInfo.classID forKey:@"classid"];
                [classDic setValue:selectedStudents forKey:@"students"];
            }
        }
        if(classDic.count > 0){
            [classesArray addObject:classDic];
        }
    }
    
    NSMutableArray *groupsArray = [NSMutableArray array];
    for (TeacherGroup *teacherGroup in self.sendEntity.groupArray) {
        NSMutableDictionary *groupDic = [NSMutableDictionary dictionary];
        if(teacherGroup.selected){
            [groupDic setValue:teacherGroup.groupID forKey:@"id"];
        }
        else{
            NSMutableArray *selectedTeachers = [NSMutableArray array];
            for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
                if(teacherInfo.selected){
                    [selectedTeachers addObject:teacherInfo.uid];
                }
            }
            if(selectedTeachers.count > 0){
                [groupDic setValue:teacherGroup.groupID forKey:@"id"];
                [groupDic setValue:selectedTeachers forKey:@"teachers"];
            }
        }
        if(groupDic.count > 0){
            [groupsArray addObject:groupDic];
        }
    }
    if(classesArray.count == 0 && groupsArray.count == 0){
        [ProgressHUD showHintText:@"没有选择发送对象"];
        return;
    }
    [params setValue:[NSString stringWithJSONObject:classesArray] forKey:@"classes"];
    [params setValue:[NSString stringWithJSONObject:groupsArray] forKey:@"groups"];
    [params setValue:self.sendEntity.content forKey:@"words"];
    if(self.sendEntity.videoArray.count > 0){
        VideoItem *videoItem = self.sendEntity.videoArray[0];
        [params setValue:kStringFromValue(videoItem.videoTime) forKey:@"video_time"];
    }
    if(self.sendEntity.imageArray.count > 0)
    {
        NSMutableString *picSeq = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < self.sendEntity.imageArray.count; i++)
        {
            [picSeq appendFormat:@"picture_%ld,",(long)i];
        }
        [params setValue:picSeq forKey:@"pic_seqs"];
    }

    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/send" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSInteger i = 0; i < self.sendEntity.imageArray.count; i++)
        {
            NSString *filename = [NSString stringWithFormat:@"picture_%ld",(long)i];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(self.sendEntity.imageArray[i], 0.8) name:filename fileName:filename mimeType:@"image/jpeg"];
        }
        if(self.sendEntity.voiceArray.count > 0){
            AudioItem *audioItem = self.sendEntity.voiceArray[0];
            [formData appendPartWithFileData:[NSData dataWithContentsOfFile:audioItem.audioUrl] name:@"voice" fileName:@"voice" mimeType:@"audio/AMR"];
        }
        if(self.sendEntity.videoArray.count > 0){
            VideoItem *videoItem = self.sendEntity.videoArray[0];
            [formData appendPartWithFileData:[NSData dataWithContentsOfFile:videoItem.localVideoPath] name:@"video" fileName:@"video" mimeType:@"application/octet-stream"];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(videoItem.coverImage, 0.8) name:@"video_cover" fileName:@"video_cover" mimeType:@"image/jpeg"];
        }
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        [ProgressHUD showSuccess:@"发送成功"];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showHintText:errMsg];
    }];

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
