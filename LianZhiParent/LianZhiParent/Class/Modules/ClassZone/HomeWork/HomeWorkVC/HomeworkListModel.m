//
//  HomeworkListModel.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkListModel.h"

@implementation HomeworkListModel

- (instancetype)init{
    self = [super init];
    if(self){
        for (NSInteger i = 0; i < 10; i++) {
            HomeworkItem *item = [[HomeworkItem alloc] init];
            item.words = @"请仔细观察图，发挥想象写几句话，然后发给老师，记得注意文字要通顺，病句要少";
            [self.modelItemArray addObject:item];
        }
    }
    return self;
}
@end
