//
//  PhotoPickerItem.m
//  LianZhiParent
//
//  Created by jslsxu on 15/3/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PhotoPickerItem.h"

@implementation PhotoPickerItem

- (BOOL)isEqualTo:(PhotoPickerItem *)targetItem
{
    if(self == targetItem)
        return YES;
    if((self.asset && self.asset == targetItem.asset) || (self.photoItem && self.photoItem == targetItem.photoItem) )
        return YES;
    else
    {
        if(self.asset && targetItem.asset)
        {
            NSString *photoUrl = [[self.asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
            NSString *targetPhotoUrl = [[targetItem.asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
            if([photoUrl isEqualToString:targetPhotoUrl])
                return YES;
        }
        if(self.photoItem && targetItem.photoItem)
        {
            NSString *photoID = [self.photoItem photoID];
            NSString *targetPhotoID = [targetItem.photoItem photoID];
            if([photoID isEqualToString:targetPhotoID])
                return YES;
        }
    }
    return NO;
}
@end
