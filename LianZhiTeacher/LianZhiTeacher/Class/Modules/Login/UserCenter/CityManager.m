//
//  CityManager.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/25.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "CityManager.h"
#import "FMDB.h"
@implementation District

@end

@implementation City

@end

@implementation Province


@end

@implementation CityManager

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        NSMutableArray *provinceList = [NSMutableArray array];
        NSString *codeDatabase = [[NSBundle mainBundle] pathForResource:@"City" ofType:@"db"];
        FMDatabase *dataBase = [FMDatabase databaseWithPath:codeDatabase];
        [dataBase open];
        NSString *sql = nil;
        FMResultSet *rs = nil;
        
        NSMutableArray *districtArray = [NSMutableArray array];
        sql = @"SELECT * FROM region_area";
        rs = [dataBase executeQuery:sql];
        while ([rs next])
        {
            District *district = [[District alloc] init];
            [district setDistrictID:[rs stringForColumn:@"code"]];
            [district setDistrictName:[rs stringForColumn:@"name"]];
            [district setCityCode:[rs stringForColumn:@"citycode"]];
            [districtArray addObject:district];
        }
        
        NSMutableArray *cityArray = [NSMutableArray array];
        sql = @"SELECT * FROM region_city";
        rs = [dataBase executeQuery:sql];
        while ([rs next])
        {
            City *city = [[City alloc] init];
            [city setCityID:[rs stringForColumn:@"code"]];
            [city setCityName:[rs stringForColumn:@"name"]];
            [city setProvinceCode:[rs stringForColumn:@"provincecode"]];
            NSMutableArray *disticeList = [NSMutableArray array];
            for (District *district in districtArray)
            {
                if([city.cityID isEqualToString:district.cityCode])
                    [disticeList addObject:district];
            }
            [city setDistrictList:disticeList];
            [cityArray addObject:city];
        }
        
        //province
        sql = @"SELECT * FROM region_province";
        rs = [dataBase executeQuery:sql];
        while ([rs next])
        {
            Province *province = [[Province alloc] init];
            [province setProvinceID:[rs stringForColumn:@"code"]];
            [province setProvinceName:[rs stringForColumn:@"name"]];
            
            NSMutableArray *cityList = [NSMutableArray array];
            for (City *city in cityArray)
            {
                if([province.provinceID isEqualToString:city.provinceCode])
                    [cityList addObject:city];
            }
            [province setCityList:cityList];
            
            [provinceList addObject:province];
        }
        
        self.provinceList = provinceList;
    }
    return self;
}
@end
