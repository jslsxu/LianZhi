//
//  ExpText.h
// MFWIOS
//
//  Created by dong jianbo on 12-5-03.
//  Copyright (c) 2012年 mafengwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFWFace.h"
// 服务器返回
#define EXP_TYPE_ACTION          	100 // Action跳转	[|s|]text[|m|]action url[|m|]100[|e|]
#define EXP_TYPE_COLOR_TEXT         301 // 可变颜色字体，不可点击 [|s|]text=郎家园路[|m|]intColor=123456[|m|]type=301[|e|]

// 以下为兼容老版本，用EXP_TYPE_ACTION也可以正常跳转
#define EXP_TYPE_AT                 103 // @好友	[|s|]@张三[|m|]uid[|m|]103[|e|]
#define EXP_TYPE_POILINK            104 // 跳转到poi最终页[|s|]世贸天阶[|m|]poiId[|m|]104[|e|]
#define EXP_TYPE_MDDLINK            105 // 跳转指定的目的地页[|s|]北京[|m|]北京[|m|]105[|e|]
#define EXP_TYPE_PROFILE            106 // 跳转个人主页[|s|]张三[|m|]uid[|m|]106[|e|]
#define EXP_TYPE_LOCATION           107 //经纬度信息
// 本地自定义
#define EXP_TYPE_SENDSMS_FAILED     201 // 只有在消息详细中有，可点击
#define EXP_TYPE_NOCLICK_BEGIN      202 // 不可点击起始值，小于此值为可点击，大于等于此值为不可点击
#define EXP_TYPE_REPLY_INFO         202 // 不可点击
#define EXP_TYPE_REPLY_COUNT        203 // 不可点击

#define EXP_ACTION_BEGIN            @"[|s|]"
#define EXP_ACTION_END              @"[|e|]"
#define EXP_ACTION                  @"[|m|]"

typedef enum{
	ExpTokenTypeText,ExpTokenTypeFace,ExpTokenTypeImage,ExpTokenTypeAction
}ExpTokenType;


@interface ExpToken : NSObject
{
	ExpTokenType tokenType;
	int actionClass;
	long long action;
    NSString *actionStr;
	long long actionType;
	BOOL selected;
	NSString * text;
	CGRect frame;
	int cellIndex;
}
@property(nonatomic,assign) BOOL selected;
@property(nonatomic,assign) int actionClass;
@property(nonatomic,assign) long long  action;
@property(nonatomic,copy) NSString *actionStr;
@property(nonatomic,assign) long long  actionType;
@property(nonatomic,retain) NSString * text;
@property(nonatomic,assign) ExpTokenType tokenType;
@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) int cellIndex;
@end

@class ExpText;

@protocol ExpTextDataSource

@property(nonatomic,assign) BOOL isScrollMode;

-(CGSize)expText:(ExpText *)expText tokenSize:(NSString *) value tokenType:(ExpTokenType)tokenType;

-(void)expText:(ExpText *)expText drawRect:(CGRect)rect 
 lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment token:(ExpToken *)token;

-(BOOL)expText:(ExpText *)extText hasFace:(NSString *)face;

-(NSString *)expTextFaceBegin:(ExpText *)extText;

-(NSString *)expTextFaceEnd:(ExpText *)extText;

-(NSString *)expTextActionBegin:(ExpText *)extText;

-(NSString *)expTextActionEnd:(ExpText *)extText;

-(NSString *)expTextActionExist:(ExpText *)expText;

@end




@interface MessageFaceExpTextDataSource : NSObject<ExpTextDataSource>
{
    
}

@end


@interface ExpText : NSObject {
	NSMutableArray * tokens;
	UIFont * textFont;
	UIFont * actionFont;
	UIColor * textColor;
	UIColor * actionColor;
	UIColor * actionSelectColor;
	CGFloat  width;
	CGSize  contentSize;
	NSString * text;
	BOOL autoWarp;
	BOOL _change;
	id<ExpTextDataSource> dataSource;
	int cellIndex;
	int handleNumber;
    BOOL clipInRect; // 限制最大高度 
	NSInteger numberOfLines;
	BOOL srcollMode;
}
@property(nonatomic,retain) id<ExpTextDataSource> dataSource;
@property(nonatomic,retain) NSString *text;
@property(nonatomic,readonly) NSArray * tokens;
@property(nonatomic,retain) UIFont * textFont;
@property(nonatomic,retain) UIFont * actionFont;
@property(nonatomic,retain) UIColor * textColor;
@property(nonatomic,retain) UIColor * actionColor;
@property(nonatomic,retain) UIColor * actionSelectColor;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,readonly) CGSize contentSize;
@property(nonatomic,assign) BOOL autoWarp;
@property(nonatomic,assign) int cellIndex;
@property(nonatomic,assign) BOOL clipInRect;
@property(nonatomic,assign) NSInteger numberOfLines;

-(void) drawRect:(CGRect)rect lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment;

-(void) setWidthAndFont:(CGFloat) width font:(UIFont *)font;

-(void) setTextAndWidthAndFont:(NSString *)text width:(CGFloat)width font:(UIFont *)font;

-(void) setSrcollMode;
@end