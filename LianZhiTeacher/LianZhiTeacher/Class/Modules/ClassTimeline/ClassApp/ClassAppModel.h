//
//  ClassAppModel.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

@interface ClassAppItem : TNModelItem
@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, copy)NSString *actionUrl;
@property (nonatomic, copy)NSString *appID;
@property (nonatomic, copy)NSString *appName;
@end

@interface ClassAppModel : TNListModel

@end
