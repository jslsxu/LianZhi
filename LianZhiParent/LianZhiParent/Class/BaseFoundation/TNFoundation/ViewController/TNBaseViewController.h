//
//  TNBaseViewController.h
//  TNFoundation
//
//  Created by jslsxu on 14/10/20.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNModelItem.h"
#import "LoadingView.h"
@protocol TNBaseTableViewData <NSObject>
@optional
- (void)TNBaseTableViewControllerRequestStart;
- (void)TNBaseTableViewControllerRequestSuccess;
- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg;
- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath;
@end

@interface TNBaseViewController : UIViewController
{
    UILabel*        _emptyLabel;
    LoadingView *   _loadingView;
    UIImageView*    _showError;
    BOOL            _hasSetup;
}
@property (nonatomic, assign)BOOL hideNavigationBar;
@property (nonatomic, assign)BOOL shouldShowEmptyHint;
@property (nonatomic, assign)BOOL interactivePopDisabled;
- (void)setupSubviews;//ios7 viewDidLoad时不确定真是frame，需要在addsubview时重新计算
- (void)startLoading;
- (void)endLoading;
- (void)showEmptyLabel:(BOOL)show;
- (void)showError;
- (void)addKeyboardNotifications;
- (void)onKeyboardWillShow:(NSNotification *)note;
- (void)onKeyboardWillHide:(NSNotification *)note;
- (void)resignKeyboard;
@end
