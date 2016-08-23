//
//  WelcomeView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/2/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "WelcomeView.h"
static __strong UIWindow *welcomeWindow = nil;

#define kWelcomViewShowKey              @"WelcomViewShowKey"

#define kWelcomePhotoNum                5

@implementation WelcomeView

- (void)dealloc
{
    DLOG(@"%@ dealloc",[self class]);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIViewController *rootVC = [[UIViewController alloc] init];
        self.rootViewController = rootVC;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setBounces:NO];
        [_scrollView setDelegate:self];
        [_scrollView setContentSize:CGSizeMake(_scrollView.width * kWelcomePhotoNum, _scrollView.height)];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [rootVC.view addSubview:_scrollView];
        
        for (NSInteger i = 0; i < kWelcomePhotoNum; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.width, 0, _scrollView.width, _scrollView.height)];
            NSString *imageStr = nil;
            if(kScreenHeight > 480)
                imageStr = [NSString stringWithFormat:@"guide%ld.png",(long)(i + 1)];
            else
                imageStr = [NSString stringWithFormat:@"small_guide%ld.png",(long)i + 1];
            NSString *path = [[NSBundle mainBundle] pathForResource:imageStr ofType:nil];
            [imageView setImage:[UIImage imageWithContentsOfFile:path]];
            [_scrollView addSubview:imageView];
            
            if(i == kWelcomePhotoNum - 1)//最后一张添加按钮
            {
                [imageView setUserInteractionEnabled:YES];
                UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
                if(self.height == 480)
                    [enterButton setFrame:CGRectMake(self.width / 4, self.height - 45 - 45, self.width / 2, 45)];
                else
                     [enterButton setFrame:CGRectMake(self.width / 4, self.height - 70 * self.height / 568, self.width / 2, 30 * self.height / 568)];
                [enterButton addTarget:self action:@selector(onEnterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:enterButton];
            }
        }
        
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl setNumberOfPages:kWelcomePhotoNum];
        [_pageControl setCurrentPage:0];
        [_pageControl setCenter:CGPointMake(self.width / 2, self.height - 20 * self.height / 480)];
        [rootVC.view addSubview:_pageControl];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.width;
    [_pageControl setCurrentPage:index];
}

- (void)onEnterButtonClicked
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        welcomeWindow = nil;
    }];
    if([self.welcomeDelegate respondsToSelector:@selector(welcomeViewDidFinished)])
        [self.welcomeDelegate welcomeViewDidFinished];
}

+ (void)showWelcome
{
    NSString *applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *showKey = [NSString stringWithFormat:@"%@%@",kWelcomViewShowKey,applicationVersion];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL welcomeShown = [[userDefaults objectForKey:showKey] boolValue];
    if(!welcomeShown)
    {
        WelcomeView *welcome = [[WelcomeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        welcomeWindow = welcome;
        welcome.windowLevel = UIWindowLevelAlert;
        welcome.hidden = NO;
        
        welcomeShown = !welcomeShown;
        [userDefaults setValue:@(welcomeShown) forKey:showKey];
        [userDefaults synchronize];
    }
    
}
@end
