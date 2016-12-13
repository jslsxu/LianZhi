//
//  FVCustomAlertView.m
//  FVCustomAlertView
//
//  Created by Francis Visoiu Mistrih on 13/07/2014.
//  Copyright (c) 2014 Francis Visoiu Mistrih. All rights reserved.
//

#import "LZCustomAlertView.h"
#import "ResourceDefine.h"

#define ImageW  30

static const NSUInteger kFinalViewTag = 1337;
static const NSUInteger kAlertViewTag = 1338;
static const NSUInteger kCloseBtnTag = 1400;
static const CGFloat kFadeOutDuration = 0.5f;
static const CGFloat kFadeInDuration = 0.2f;


@interface LZAlertAction ()

@property (weak, nonatomic) UIButton *actionButton;

@end

@implementation LZAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style
                        handler:(void (^)(LZAlertAction *action))handler {
    LZAlertAction *action = [[LZAlertAction alloc] init];
    action.title = title;
    action.style = style;
    action.handler = handler;
    
    return action;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _enabled = YES;
    }
    
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    
    self.actionButton.enabled = enabled;
}

@end




@implementation LZAlertViewButton


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)layoutSubviews
{    [super layoutSubviews];

    if(self.isNeedLayoutSubviews)
    {
    
        CGSize size = [self.titleLabel.text sizeWithAttributes: @{NSFontAttributeName: self.titleLabel.font}];
        CGFloat labelWidth = size.width + 5;
        
        CGRect titleRect = self.titleLabel.frame;
        titleRect.origin.x = (self.frame.size.width/2 - labelWidth/2);
        
        CGSize imageSize = self.imageView.image.size;
        CGRect imageRect = self.imageView.frame;
        imageRect.origin.x = (self.frame.size.width/2 + labelWidth/2 - 10) ;
        imageRect.origin.y = 0.0f;
        imageRect.size = imageSize;
        
        self.imageView.frame = imageRect;
        self.titleLabel.frame = titleRect;
    }
    
}


- (void)commonInit {
    
    [self setTitleColor:LightGrayLblColor forState:UIControlStateNormal];
    [self setTitleColor:LightGrayLblColor forState:UIControlStateHighlighted];
    [self setTitleColor:LightGrayLblColor forState:UIControlStateDisabled];

}


@end

@interface LZCustomAlertView ()

+ (NSArray *)setupCustomActivityIndicator;
+ (void)fadeOutView:(UIView *)view completion:(void (^)(BOOL finished))completion;
+ (void)hideAlertByTap:(UITapGestureRecognizer *)sender;

@end

static UIView *currentView = nil;
static UIView *myContentView = nil;

@implementation LZCustomAlertView

+ (UIView *)currentView
{
    return currentView;
}

+ (UIView *)myContentView
{
    return myContentView;
}

+ (void)showAlertOnView:(UIView *)view
              withTitle:(NSString *)title
             titleColor:(UIColor *)titleColor
                  width:(CGFloat)width
                 height:(CGFloat)height
                   blur:(BOOL)blur
        backgroundImage:(UIImage *)backgroundImage
        backgroundColor:(UIColor *)backgroundColor
           cornerRadius:(CGFloat)cornerRadius
            shadowAlpha:(CGFloat)shadowAlpha
                  alpha:(CGFloat)alpha
            contentView:(UIView *)contentView
                   type:(FVAlertType)type
               allowTap:(BOOL)tap
{
    if ([view viewWithTag:kFinalViewTag]) {
        //don't allow 2 alerts on the same view
        NSLog(@"Can't add two FVCustomAlertViews on the same view. Hide the current view first.");
        return;
    }

    //get window size and position
    CGRect windowRect = [[UIScreen mainScreen] bounds];

    //create the final view with a special tag
    UIView *resultView = [[UIView alloc] initWithFrame:windowRect];
    resultView.tag = kFinalViewTag; //set tag to retrieve later
    resultView.alpha = 0.0f;

    if (blur) {
      UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

      UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
      visualEffectView.frame = windowRect;
      [resultView addSubview:visualEffectView];
    }

    //create shadow view by adding a black background with custom opacity
    UIView *shadowView = [[UIView alloc] initWithFrame:windowRect];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = shadowAlpha;
    [resultView addSubview:shadowView];

    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(windowRect.size.width/2 - width/2,
                                                                 windowRect.size.height/2 - height/2,
                                                                 width, height)];
    alertView.tag = kAlertViewTag; //set tag to retrieve later

    //set background color
    //if a background image is used, use the image instead.
    alertView.backgroundColor =  backgroundColor;//   backgroundColor;
    if (backgroundImage) {
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.image = backgroundImage;
        bgImgView.frame = alertView.bounds;
        [alertView addSubview:bgImgView];
    }
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeButton setTintColor:[UIColor whiteColor]];
    closeButton.tag = kCloseBtnTag;
    [closeButton setImage:[UIImage imageNamed:@"alertClose"] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    
    closeButton.frame = CGRectMake(alertView.frame.size.width - closeButton.frame.size.width - 10,  30 + closeButton.frame.size.height, closeButton.frame.size.width, closeButton.frame.size.height);
     [closeButton addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [alertView addSubview:closeButton];
    alertView.layer.cornerRadius = cornerRadius;
    alertView.alpha = alpha;

    [resultView addSubview:alertView];
    //check wether the alert is of custom type or not
    //if it is, set the custom view
    myContentView =  contentView;
    [alertView addSubview:contentView];

    
    if (tap) {
        //tap the alert view to hide and remove it from the superview
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:
                                              [LZCustomAlertView class] action:@selector(hideAlertByTap:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [resultView addGestureRecognizer:tapGesture];
    }

    [view addSubview:resultView];
    [self fadeInView:resultView completion:nil];
    currentView = view;
}




+ (NSArray *)setupCustomActivityIndicator {
    NSMutableArray *array = [NSMutableArray array];
    //iterate through all the images and add it to the array for the animation
    for (int i = 1; i <= 20; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [array addObject:image];
    }
    return array;
}



+ (void)fadeInView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:kFadeInDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [view setAlpha:1.0];
                     }
                     completion:completion];
}

+ (void)fadeOutView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:kFadeOutDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [view setAlpha:0.0];
                     }
                     completion:completion];
}

+ (void)hideAlertFromView:(UIView *)view fading:(BOOL)fading {
    if (fading) {
        [self fadeOutView:[view viewWithTag:kFinalViewTag] completion:^(BOOL finished) {
            [[view viewWithTag:kFinalViewTag] removeFromSuperview];
        }];
    } else {
        [[view viewWithTag:kFinalViewTag] removeFromSuperview];
    }
    currentView = nil;
}

+ (void)hideAlertByTap:(UITapGestureRecognizer *)sender {
    //fade out and then remove from superview
    [self fadeOutView:sender.view
           completion:^(BOOL finished) {
               [[sender.view viewWithTag:kFinalViewTag] removeFromSuperview];
               currentView = nil;
           }];
}

+ (void)createActionButtons:(NSArray *)actions Status:(ThroughTraining_Status)status{
    
    [self removeActionButtons];
    
    NSUInteger buttonCount = [actions count];

    for (int i = 0; i < buttonCount; i++) {
        LZAlertAction *action = actions[i];
        LZAlertViewButton *button = nil;
        if(i == 0)
        {
           
            if(buttonCount == 2)
            {
                // 2 个按钮的情况 第一个按钮
                button = [[LZAlertViewButton alloc]initWithFrame:CGRectMake(5, CGRectGetHeight(myContentView.frame) - 38,
                                                                                               CGRectGetWidth(myContentView.frame)/2 -10, 38)];
                [button setTitleColor:JXColor(0x5d,0x5d,0x5d,1) forState:UIControlStateSelected];
                [button setTitleColor:JXColor(0x02,0xc9,0x94,1) forState:UIControlStateNormal];
            }
            else
            {
                // 1 个按钮的情况
                button = [[LZAlertViewButton alloc]initWithFrame:CGRectMake(5, CGRectGetHeight(myContentView.frame) - 38,
                                                                                      CGRectGetWidth(myContentView.frame) -10, 38)];
                [button setTitleColor:JXColor(0x5d,0x5d,0x5d,1) forState:UIControlStateNormal];
                [button setTitleColor:JXColor(0x02,0xc9,0x94,1) forState:UIControlStateSelected];
            }
        }
        else
        {
            // 2 个按钮的情况 第二个按钮
            button = [[LZAlertViewButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(myContentView.frame)/2 + 5, CGRectGetHeight(myContentView.frame) - 38, CGRectGetWidth(myContentView.frame)/2 -10, 38)];
            [button setTitleColor:JXColor(0x5d,0x5d,0x5d,1) forState:UIControlStateNormal];
            [button setTitleColor:JXColor(0x02,0xc9,0x94,1) forState:UIControlStateSelected];
        }
        
        button.isNeedLayoutSubviews = NO;
        button.action = action;
        button.tag = i;
        [button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
//        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button setTitle:action.title forState:UIControlStateNormal];
        UIFont *buttonTitleFont = [UIFont systemFontOfSize:17.0f];
        button.titleLabel.font = buttonTitleFont;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.enabled = action.enabled;
       
        
//        if(status == UnLocked_Status  || status == NotComplated_Status)
//        {
//            [button setImage:[UIImage imageNamed:@"btnFreeBadge"] forState:UIControlStateNormal];
//            
//        }
//        else if(status == Complated_Status)
//        {
//            if(i == 0)
//            {
//                [button setImage:[UIImage imageNamed:@"btnMoneyBadge"] forState:UIControlStateNormal];
//            }
//            else
//            {
//                [button setImage:[UIImage imageNamed:@"btnFreeBadge"] forState:UIControlStateNormal];
//            }
//            
//        }

        [myContentView addSubview:button];
        action.actionButton = button;
    }

}

+ (void)removeActionButtons{
  
    for (UIView *button  in myContentView.subviews) {
        
        if([button isKindOfClass:[UIButton class]] && button.tag != kCloseBtnTag){
            [button removeFromSuperview];
        }
    }
}




+ (void)setActionButtonEnable:(BOOL)enable {
  
    for(UIView * btn in myContentView.subviews)
    {
        if( [btn isKindOfClass:[LZAlertViewButton class]] )
        {
            LZAlertAction *tAction = ((LZAlertViewButton *)btn).action;
            if([tAction.title isEqualToString:@"错题加练"])
            {
                tAction.enabled = enable;
                return;
            }
        }
    }
}

//按钮点击 传入代理
+(void)closeClick:(UIButton*)sender
{
    UIView *finalView = [currentView viewWithTag:kFinalViewTag];
    [self fadeOutView:finalView
           completion:^(BOOL finished) {
               [finalView removeFromSuperview];
           }];
}

+ (void)actionButtonPressed:(LZAlertViewButton *)sender {
    LZAlertAction *action = sender.action;
    
    action.handler(action);
}
@end
