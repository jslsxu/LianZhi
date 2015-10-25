//
//  CityManager.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/25.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface District: NSObject
@property (nonatomic, copy)NSString *districtID;
@property (nonatomic, copy)NSString *districtName;
@property (nonatomic, copy)NSString *cityCode;
@end

@interface City : NSObject
@property (nonatomic, copy)NSString *cityID;
@property (nonatomic, copy)NSString *cityName;
@property (nonatomic, strong)NSMutableArray *districtList;
@property (nonatomic, copy)NSString *provinceCode;
@end

@interface Province : NSObject
@property (nonatomic, copy)NSString *provinceID;
@property (nonatomic, copy)NSString *provinceName;
@property (nonatomic, strong)NSArray *cityList;

@end

@interface CityManager : NSObject
@property (nonatomic, strong)NSArray *provinceList;
@end
