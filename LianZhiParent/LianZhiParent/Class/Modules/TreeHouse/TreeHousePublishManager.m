//
//  TreeHousePublishManager.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/8.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TreeHousePublishManager.h"

@implementation TreeHousePublishManager
SYNTHESIZE_SINGLETON_FOR_CLASS(TreeHousePublishManager)

- (NSString *)saveTask:(TreehouseItem *)item
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:item.params];
    [params setValue:item.detail forKey:@"words"];
    NSMutableString *picSeq = [[NSMutableString alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < [item.photos count]; i++)
    {
        PhotoItem *photoItem = [item.photos objectAtIndex:i];
        PublishImageItem *imageItem = [photoItem publishImageItem];
        NSString *curKey = nil;
        if(imageItem.image == nil)
        {
            curKey = imageItem.photoID;
        }
        else
            curKey = imageItem.photoKey;
        if(curKey)
        {
            if(picSeq.length == 0)
                [picSeq appendString:curKey];
            else
                [picSeq appendFormat:@",%@",curKey];
        }
    }
    [params setValue:picSeq forKey:@"pic_seqs"];
    [params setValue:[UserCenter sharedInstance].curChild.uid forKey:@"child_id"];
    NetworkStatus status = [ApplicationDelegate.hostReach currentReachabilityStatus];
    BOOL notice = (status == ReachableViaWiFi && [UserCenter sharedInstance].personalSetting.wifiSend && item.delay);
    if(notice)
        [params setValue:@"1" forKey:@"onlywifi_notice"];
    NSArray *photos = item.photos;
    NSMutableDictionary *images = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < [photos count]; i++) {
        PhotoItem *photoItem = [photos objectAtIndex:i];
        PublishImageItem *imageItem = [photoItem publishImageItem];
        NSString *photoKey = imageItem.photoKey;
        if(imageItem.image)
            [images setValue:UIImageJPEGRepresentation(imageItem.image, 0.8) forKey:photoKey];
    }
    
    //保存task
    TaskItem *taskItem = [[TaskItem alloc] init];
    taskItem.images = images;
    taskItem.params = params;
    taskItem.targetUrl = @"tree/post_content";
    NSString *filePath = [[TaskUploadManager sharedInstance] saveTask:taskItem];
    return filePath;
}


- (void)startUploading:(TreehouseItem *)item{
//    if(item.newSend && !item.isUploading)
//    {
//        item.isUploading = YES;
//        NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:item];
//        if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:item.params];
//        [params setValue:item.detail forKey:@"words"];
//        NSMutableString *picSeq = [[NSMutableString alloc] initWithCapacity:0];
//        for (NSInteger i = 0; i < [item.photos count]; i++)
//        {
//            PhotoItem *photoItem = [item.photos objectAtIndex:i];
//            PublishImageItem *imageItem = [photoItem publishImageItem];
//            NSString *curKey = nil;
//            if(imageItem.image == nil)
//            {
//                curKey = imageItem.photoID;
//            }
//            else
//                curKey = imageItem.photoKey;
//            if(curKey)
//            {
//                if(picSeq.length == 0)
//                    [picSeq appendString:curKey];
//                else
//                    [picSeq appendFormat:@",%@",curKey];
//            }
//        }
//        [params setValue:picSeq forKey:@"pic_seqs"];
//        [params setValue:[UserCenter sharedInstance].curChild.uid forKey:@"child_id"];
//        NetworkStatus status = [ApplicationDelegate.hostReach currentReachabilityStatus];
//        BOOL notice = (status == ReachableViaWiFi && [UserCenter sharedInstance].personalSetting.wifiSend && item.delay);
//        if(notice)
//            [params setValue:@"1" forKey:@"onlywifi_notice"];
//        NSArray *photos = item.photos;
//        
//        NSMutableDictionary *images = [[NSMutableDictionary alloc] initWithCapacity:0];
//        for (NSInteger i = 0; i < [photos count]; i++) {
//            PhotoItem *photoItem = [photos objectAtIndex:i];
//            PublishImageItem *imageItem = [photoItem publishImageItem];
//            NSString *photoKey = imageItem.photoKey;
//            if(imageItem.image)
//                [images setValue:UIImageJPEGRepresentation(imageItem.image, 0.8) forKey:photoKey];
//        }
//        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/post_content" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            for (NSString *key in images.allKeys)
//            {
//                NSData *imageData = images[key];
//                if(imageData)
//                    [formData appendPartWithFileData:imageData name:key fileName:key mimeType:@"image/jpeg"];
//            }
//        } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//            TNDataWrapper *infoWrapper = [responseObject getDataWrapperForKey:@"info"];
//            if(infoWrapper.count > 0)
//            {
//                if(item.savedPath)
//                    [[NSFileManager defaultManager] removeItemAtPath:item.savedPath error:nil];
//                TreehouseItem *zoneItem = [[TreehouseItem alloc] init];
//                [zoneItem parseData:infoWrapper];
//                
//                NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:item];
//                if(index >=0 && index < self.tableViewModel.modelItemArray.count)
//                {
//                    [self.tableViewModel.modelItemArray replaceObjectAtIndex:index withObject:zoneItem];
//                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//                    [self showEmptyLabel:self.tableViewModel.modelItemArray.count == 0];
//                }
//                if(notice)
//                    [[NSNotificationCenter defaultCenter] postNotificationName:kPublishPhotoItemFinishedNotification object:nil userInfo:nil];
//            }
//            item.isUploading = NO;
//        } fail:^(NSString *errMsg) {
//            item.isUploading = NO;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self onNetworkStatusChanged];
//            });
//        }];
//    }
}
@end
