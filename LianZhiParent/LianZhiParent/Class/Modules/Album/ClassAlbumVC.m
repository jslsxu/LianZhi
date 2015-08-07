//
//  ClassAlbumVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/2/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassAlbumVC.h"

@implementation ClassAlbumVC

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"class/album"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"class_id"];
    [params setValue:@"20" forKey:@"num"];
    if(requestType == REQUEST_REFRESH)
        [params setValue:@"0" forKey:@"start"];
    else
        [params setValue:kStringFromValue(self.collectionViewModel.modelItemArray.count) forKey:@"start"];
    [task setParams:params];
    return task;
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    [browser setBrowserType:PhotoBrowserTypeZone];
    [browser setPhotos:self.collectionViewModel.modelItemArray];
    [browser setCurrentPhotoIndex:index];
    [browser setClassID:self.classID];
    [self.navigationController pushViewController:browser animated:YES];
}

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),self.classID];
}
@end
