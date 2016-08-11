//
//  FunctionView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FunctionType){
    FunctionTypePhoto,
    FunctionTypeCamera,
    FunctionTypeShortVideo,
    FunctionTypeSendGift,
    FunctionTypeTelephone
};

@interface FunctionItem : TNBaseObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *image;
@property (nonatomic, assign)FunctionType functionType;
+ (FunctionItem *)functionItemWithTitle:(NSString *)title image:(NSString *)image type:(FunctionType)functionType;
@end

@interface FunctionItemCell : UICollectionViewCell
{
    UIImageView*    _imageView;
    UILabel*        _titleLabel;
}
@property (nonatomic, strong)FunctionItem*  functionItem;
@end

@protocol FunctionViewDelegate <NSObject>

- (void)functionViewDidSelectWithType:(FunctionType)functionType;

@end

@interface FunctionView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView*   _collectionView;
}
@property (nonatomic, assign)BOOL canSendGift;
@property (nonatomic, assign)BOOL canCalltelephone;
@property (nonatomic, weak)id<FunctionViewDelegate> delegate;
@end
