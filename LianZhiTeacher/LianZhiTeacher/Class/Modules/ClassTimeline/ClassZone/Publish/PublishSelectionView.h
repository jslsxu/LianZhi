//
//  PublishSelectionView.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/20.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublishSelectDelegate <NSObject>
- (void)publishContentDidSelectAtIndex:(NSInteger)index;
- (void)publishContentDidCancel;
@end

@interface PublishSelectionView : UIView
{
    UIButton *_textButton;
    UIButton *_photoButton;
    UIButton *_audioButton;
}
@property (nonatomic, assign)id<PublishSelectDelegate> delegate;
- (void)show;
@end
