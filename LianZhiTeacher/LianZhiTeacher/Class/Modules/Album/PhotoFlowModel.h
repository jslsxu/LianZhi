//
//  PhotoFlowModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "PhotoItem.h"

@interface PhotoFlowModel : TNListModel
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)BOOL forPhotoPicker;
- (BOOL)showYearForSection:(NSInteger)section;
@end
