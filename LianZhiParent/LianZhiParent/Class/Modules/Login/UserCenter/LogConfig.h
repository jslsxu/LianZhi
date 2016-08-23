//
//  LogConfig.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TagPrivilege){
    TagPrivilegeText = 1,
    TagPrivilegePhoto = 1 << 1,
    TagPrivilegeAudio = 1 << 2,
};

@interface SubTag : TNModelItem
@property (nonatomic, copy)NSString *tagID;
@property (nonatomic, copy)NSString *tagName;
@property (nonatomic, assign)NSInteger content;     //tag权限
@end

@interface TagGroup : TNModelItem
@property (nonatomic, copy)NSString *groupID;
@property (nonatomic, copy)NSString *groupName;
@property (nonatomic, strong)NSArray *subTags;

@end


@interface LogConfig : TNModelItem
@property (nonatomic, copy)NSString *dicoveryUrl;
@property (nonatomic, copy)NSString *introUrl;
@property (nonatomic, copy)NSString *aboutUrl;
@property (nonatomic, copy)NSString *helpUrl;
@property (nonatomic, copy)NSString *faqUrl;
@property (nonatomic, copy)NSArray *tags;

- (NSArray *)tagForPrivilege:(TagPrivilege)privilege;
@end
