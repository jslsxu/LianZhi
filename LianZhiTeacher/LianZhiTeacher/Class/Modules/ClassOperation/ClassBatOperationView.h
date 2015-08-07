//
//  ClassBatOperationView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassBatOperationDelegate <NSObject>
@optional
- (void)classBatOperationOnMessage;
- (void)classBatOperationOnPhotoShare;
- (void)classBatOperationOnGrowthTimeline;
- (void)classBatOperationCancel;
- (void)classBatOperationSelectAll;

@end

@interface ClassBatOperationView : UIView
{
    UIImageView*    _bgImageView;
    UIButton*       _messageButton;
    UIButton*       _photoButton;
    UIButton*       _growthButton;
    UIButton*       _cancelButton;
    UILabel*        _numLabel;
    UIButton*       _selectAllButton;
    UILabel*        _hintLabel;
}
@property (nonatomic, weak)id<ClassBatOperationDelegate> delegate;
@property (nonatomic, assign)BOOL show;
@property (nonatomic, strong)NSArray *sourceArray;
@property (nonatomic, assign)BOOL growthRecord;
- (void)reset;
@end
