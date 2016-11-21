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

static const NSInteger kInsetValue = 6;
static const NSUInteger kFinalViewTag = 1337;
static const NSUInteger kAlertViewTag = 1338;
static const NSUInteger kCloseBtnTag = 1400;
static const CGFloat kFadeOutDuration = 0.5f;
static const CGFloat kFadeInDuration = 0.2f;
//static const CGFloat kActivityIndicatorSize = 50;
//static const CGFloat kOtherIconsSize = 30;

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

+ (id)buttonWithType:(UIButtonType)buttonType {
    return [super buttonWithType:UIButtonTypeCustom];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
      
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)layoutSubviews
{    [super layoutSubviews];
    
//    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    
    CGSize size = [self.titleLabel.text sizeWithAttributes: @{NSFontAttributeName: self.titleLabel.font}];
    CGFloat labelWidth = size.width + 5;
    
    CGRect titleRect = self.titleLabel.frame;
    titleRect.origin.x = (self.frame.size.width/2 - labelWidth/2);
//    titleRect.origin.y = 0;
    
    CGSize imageSize = self.imageView.image.size;
    CGRect imageRect = self.imageView.frame;
//    imageRect.size = CGSizeMake(30, 30);
    imageRect.origin.x = (self.frame.size.width/2 + labelWidth/2 - 10) ;
    imageRect.origin.y = 0.0f;
    imageRect.size = imageSize;
    
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
    
}


- (void)commonInit {
    
    [self setTitleColor:LightGrayLblColor forState:UIControlStateNormal];
    [self setTitleColor:LightGrayLblColor forState:UIControlStateHighlighted];
    [self setTitleColor:LightGrayLblColor forState:UIControlStateDisabled];
    
//    [self tintColorDidChange];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [self invalidateIntrinsicContentSize];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGSize)intrinsicContentSize {
    if (self.hidden) {
        return CGSizeZero;
    }
    
    return CGSizeMake([super intrinsicContentSize].width + 12.0f, 30.0f);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

@end

@interface LZCustomAlertView ()

+ (NSArray *)setupCustomActivityIndicator;
//+ (UIView *)contentViewFromType:(FVAlertType)type;
+ (void)fadeOutView:(UIView *)view completion:(void (^)(BOOL finished))completion;
+ (void)hideAlertByTap:(UITapGestureRecognizer *)sender;

@end

static UIView *currentView = nil;

@implementation LZCustomAlertView

+ (UIView *)currentView
{
    return currentView;
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

    //create the main alert view centered
    //with custom width and height
    //and custom background
    //and custom corner radius
    //and custom opacity
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
//        alertView.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
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

    //create the title label centered with multiple lines
    //and custom color
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = titleColor;

    //set the number of lines to 0 (unlimited)
    //set a maximum size to the label
    //then get the size that fits the maximum size
    titleLabel.numberOfLines = 0;
    CGSize requiredSize = CGSizeMake(width - kInsetValue, height - kInsetValue);
    titleLabel.frame = CGRectMake(width/2 - requiredSize.width / 2, kInsetValue, requiredSize.width, requiredSize.height);
    [alertView addSubview:titleLabel];
    [resultView addSubview:alertView];
    //check wether the alert is of custom type or not
    //if it is, set the custom view
    UIView *content =  contentView;

//    content.frame = CGRectApplyAffineTransform(content.frame, CGAffineTransformMakeTranslation(width/2 - content.frame.size.width/2, titleLabel.frame.origin.y + titleLabel.frame.size.height + kInsetValue));

    [alertView addSubview:content];

    
    if (tap) {
        //tap the alert view to hide and remove it from the superview
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:[LZCustomAlertView class] action:@selector(hideAlertByTap:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [resultView addGestureRecognizer:tapGesture];
    }

    [view addSubview:resultView];
    [self fadeInView:resultView completion:nil];
    currentView = view;
}

+ (void)showDefaultLoadingAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap {
    [self showAlertOnView:view
                withTitle:title
               titleColor:[UIColor whiteColor]
                    width:100.0
                   height:100.0
                     blur:blur
          backgroundImage:nil
          backgroundColor:[UIColor blackColor]
             cornerRadius:10.0
              shadowAlpha:0.1
                    alpha:0.8
              contentView:nil
                     type:FVAlertTypeLoading
                 allowTap:tap];
}

+ (void)showDefaultDoneAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap {
    [self showAlertOnView:view
                withTitle:title
               titleColor:[UIColor whiteColor]
                    width:100.0
                   height:100.0
                     blur:blur
          backgroundImage:nil
          backgroundColor:[UIColor blackColor]
             cornerRadius:10.0
              shadowAlpha:0.1
                    alpha:0.8
              contentView:nil
                     type:FVAlertTypeDone
                 allowTap:tap];
}

+ (void)showDefaultErrorAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap {
    [self showAlertOnView:view
                withTitle:title
               titleColor:[UIColor whiteColor]
                    width:100.0
                   height:100.0
                     blur:blur
          backgroundImage:nil
          backgroundColor:[UIColor blackColor]
             cornerRadius:10.0
              shadowAlpha:0.1
                    alpha:0.8
              contentView:nil
                     type:FVAlertTypeError
                 allowTap:tap];
}

+ (void)showDefaultWarningAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap {
    [self showAlertOnView:view
                withTitle:title
               titleColor:[UIColor whiteColor]
                    width:100.0
                   height:100.0
                     blur:blur
          backgroundImage:nil
          backgroundColor:[UIColor blackColor]
             cornerRadius:10.0
              shadowAlpha:0.1
                    alpha:0.8
              contentView:nil
                     type:FVAlertTypeWarning
                 allowTap:tap];
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
    NSMutableArray *buttons = [NSMutableArray array];
    
    // Create buttons for each action
    UIView *resultView = [currentView viewWithTag:kFinalViewTag];
    UIView *alertView = [resultView viewWithTag:kAlertViewTag];
    [self removeActionButtons];
    
    for (int i = 0; i < [actions count]; i++) {
        LZAlertAction *action = actions[i];
        
        LZAlertViewButton *button = [LZAlertViewButton buttonWithType:UIButtonTypeCustom];
        button.action = action;
        button.tag = i;
        [button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button setTitle:action.title forState:UIControlStateNormal];
        UIFont *buttonTitleFont = [UIFont systemFontOfSize:17.0f];
        button.titleLabel.font = buttonTitleFont;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.enabled = action.enabled;
        
        if(status == UnLocked_Status  || status == NotComplated_Status)
        {
            [button setImage:[UIImage imageNamed:@"btnFreeBadge"] forState:UIControlStateNormal];
            
        }
        else if(status == Complated_Status)
        {
            if(i == 0)
            {
                [button setImage:[UIImage imageNamed:@"btnMoneyBadge"] forState:UIControlStateNormal];
            }
            else
            {
                [button setImage:[UIImage imageNamed:@"btnFreeBadge"] forState:UIControlStateNormal];
          
            }
            
        }
 
        if(i == 0)
        {
            [button setTitleColor:JXColor(0x5d,0x5d,0x5d,1) forState:UIControlStateSelected];
            [button setTitleColor:JXColor(0x02,0xc9,0x94,1) forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:JXColor(0x5d,0x5d,0x5d,1) forState:UIControlStateNormal];
            [button setTitleColor:JXColor(0x02,0xc9,0x94,1) forState:UIControlStateSelected];
        }
        
        [buttons addObject:button];
        [alertView addSubview:button];
        action.actionButton = button;
    }
    
    [self setActionButtons:buttons];
}

+ (void)removeActionButtons{
    UIView *alertView = [currentView viewWithTag:kAlertViewTag];
    for (UIView *button  in alertView.subviews) {
        
        if([button isKindOfClass:[UIButton class]] && button.tag != kCloseBtnTag){
            [button removeFromSuperview];
        }
    }
}


+ (void)setActionButtons:(NSArray *)actionButtons {
    
    
    UIView *resultView = [currentView viewWithTag:kFinalViewTag];
    UIView *alertView = [resultView viewWithTag:kAlertViewTag];
    NSLog(@"alertView (%f,%f)",alertView.frame.size.width,alertView.frame.size.height);

    if ([actionButtons count] == 2) {
        UIButton *firstButton = actionButtons[0];
        UIButton *lastButton = actionButtons[1];

        firstButton.frame = CGRectMake(5, CGRectGetHeight(alertView.frame) - 38, CGRectGetWidth(alertView.frame)/2 -10, 38);
        lastButton.frame = CGRectMake(CGRectGetWidth(alertView.frame)/2 + 5, CGRectGetHeight(alertView.frame) - 38, CGRectGetWidth(alertView.frame)/2 -10, 38);
        
       

    } else if ([actionButtons count] == 1){
        UIButton *actionButton = actionButtons[0];
        
        actionButton.frame = CGRectMake(5, CGRectGetHeight(alertView.frame) - 38,
                                        CGRectGetWidth(alertView.frame) -10, 38);
        
//        [alertView addSubview:actionButton];
    }
}



+ (void)setActionButtonEnable:(BOOL)enable {
    UIView *resultView = [currentView viewWithTag:kFinalViewTag];
    UIView *alertView = [resultView viewWithTag:kAlertViewTag];
    
//    UIView *alertView = [currentView viewWithTag:kAlertViewTag];
    
    for(UIView * btn in alertView.subviews)
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
