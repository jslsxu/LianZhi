//
//  HomeworkExplainEntity.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "HomeworkItem.h"
@interface HomeworkExplainEntity : TNBaseObject
@property(nonatomic, copy)NSString*             words;
@property(nonatomic, strong)NSMutableArray*     voiceArray;
@property(nonatomic, strong)NSMutableArray*     imageArray;
+ (HomeworkExplainEntity *)explainEntityFromAnswer:(HomeworkItemAnswer *)answer;
- (BOOL)isEmpty;
- (BOOL)isSame:(HomeworkExplainEntity *)anotherEntity;
@end
