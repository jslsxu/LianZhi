//
//  LZSubjectModel.h
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/25.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SubjectItem : TNModelItem

@property (nonatomic, copy)NSString *subjectCode;
@property (nonatomic, copy)NSString *subjectname;

@end

@interface SkillItem : TNModelItem

@property (nonatomic, copy)NSString *skill_code;
@property (nonatomic, copy)NSString *skill_name;


- (void)parseData:(TNDataWrapper *)data;
@end

@interface LZSubjectModel : TNModelItem

@property (nonatomic, copy)NSString *subjectCode;
@property (nonatomic, copy)TNListModel *skills;

- (void)parseData:(TNDataWrapper *)data  type:(REQUEST_TYPE)type;

@end

@interface LZSubjectList : TNModelItem

@property (nonatomic, copy)LZSubjectModel *chineseModel;
@property (nonatomic, copy)LZSubjectModel *mathModel;
@property (nonatomic, copy)LZSubjectModel *englishModel;

@end

