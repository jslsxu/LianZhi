//
//  ActionFadeView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/27.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ActionFadeView.h"
#import "NotificationSendVC.h"
#import "POP.h"
#import "NotificationHistoryVC.h"
#import "AttendanceVC.h"
#define kItemWidth                  66
#define kItemHeight                 96

@implementation WeatherInfo
+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper{
    return @{@"city" : @"location.name",
             @"temperature" : @"now.temperature",
             @"weather" : @"now.text"};
}

@end

@interface WeatherView ()<CLLocationManagerDelegate>
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)WeatherInfo *weatherInfo;
@end

@implementation WeatherView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        NSDate *date = [NSDate date];
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_dayLabel setFont:[UIFont systemFontOfSize:45]];
        [_dayLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_dayLabel setText:kStringFromValue([date day])];
        [_dayLabel sizeToFit];
        [self addSubview:_dayLabel];
        
        _weekdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_weekdayLabel setFont:[UIFont systemFontOfSize:12]];
        [_weekdayLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_weekdayLabel setText:[Utility weekdayStr:date]];
        [_weekdayLabel sizeToFit];
        [_weekdayLabel setOrigin:CGPointMake(_dayLabel.right + 10, _dayLabel.y + 10)];
        [self addSubview:_weekdayLabel];
        
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_monthLabel setFont:[UIFont systemFontOfSize:12]];
        [_monthLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_monthLabel setText:[NSString stringWithFormat:@"%02zd/%zd",[date month], [date year]]];
        [_monthLabel sizeToFit];
        [_monthLabel setOrigin:CGPointMake(_weekdayLabel.left, _dayLabel.bottom - _monthLabel.height - 10)];
        [self addSubview:_monthLabel];
        
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_temperatureLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_temperatureLabel setFont:[UIFont systemFontOfSize:14]];
        [_temperatureLabel setOrigin:CGPointMake(0, _dayLabel.bottom )];
        [self addSubview:_temperatureLabel];
        
        [self setHeight:_temperatureLabel.bottom];
        
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        if (IS_IOS8_LATER) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)setWeatherInfo:(WeatherInfo *)weatherInfo{
    _weatherInfo = weatherInfo;
    [_temperatureLabel setText:[NSString stringWithFormat:@"%@: %@ %@℃",_weatherInfo.city, _weatherInfo.weather, _weatherInfo.temperature]];
    [_temperatureLabel sizeToFit];
    [self setHeight:_temperatureLabel.bottom];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [manager stopUpdatingLocation];
    if(locations.count > 0){
        CLLocation *location = [locations firstObject];
        CGFloat latitude = location.coordinate.latitude;
        CGFloat longitude = location.coordinate.longitude;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:[NSString stringWithFormat:@"%f:%f",latitude, longitude] forKey:@"location"];
        [params setValue:@"cgvycx5p3rf794gi" forKey:@"key"];
        [params setValue:@"zh-Hans" forKey:@"language"];
        @weakify(self)
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"https://api.thinkpage.cn/v3/weather/now.json" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            @strongify(self)
            NSDictionary *dic = operation.responseObject;
            NSArray *array = dic[@"results"];
            if(array.count > 0){
                NSDictionary *weatherDic = array[0];
                WeatherInfo *weatherInfo = [WeatherInfo modelWithDictionary:weatherDic];
                [self setWeatherInfo:weatherInfo];
            }
        } fail:^(NSString *errMsg) {
            
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
}

@end
@interface ActionFadeView (){
    UIVisualEffectView* _effectView;
    UIView*             _contentView;
    WeatherView*        _weatherView;
    UIImageView*        _logoView;
    UIButton*           _cancelButton;
    NSMutableArray*     _buttonArray;
}
@end

@implementation ActionFadeView

+ (void)showActionView{
    ActionFadeView *actionView = [[ActionFadeView alloc] init];
    [actionView show];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        _buttonArray = [NSMutableArray array];
//        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.6]];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectView.frame = self.bounds;
        [self addSubview:_effectView];
        
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self setupContentView:_contentView];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)setupContentView:(UIView *)viewParent{
    
    _weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(10, 40, viewParent.width - 10 * 2, 0)];
    [viewParent addSubview:_weatherView];
    
    _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_title"]];
    [_logoView setOrigin:CGPointMake((_contentView.width - _logoView.width) / 2, 160)];
    [_contentView addSubview:_logoView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setSize:CGSizeMake(50, 50)];
    [_cancelButton setCenter:CGPointMake(_contentView.width / 2, _contentView.height - _cancelButton.height / 2)];
    [_cancelButton setImage:[UIImage imageNamed:@"ActionCancel"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_cancelButton];
    
    if([UserCenter sharedInstance].curSchool.canSendNotification)
    {
        [_buttonArray addObject:[self actionViewWithTitle:@"发通知" image:@"SendNotification" action:@selector(sendNotification)]];
    }
    [_buttonArray addObject:[self actionViewWithTitle:@"新聊天" image:@"NewChat" action:@selector(newChat)]];
    [_buttonArray addObject:[self actionViewWithTitle:@"学生考勤" image:@"StudentAttendance" action:@selector(studentAttendance)]];
    
    NSInteger count = _buttonArray.count;
    CGFloat innerHMargin = (_contentView.width - kItemWidth * count) / (2 + 1.5 * (count - 1));
    for (NSInteger i = 0; i < count; i++) {
        UIView *itemView = _buttonArray[i];
        [_contentView addSubview:itemView];
        [itemView setOrigin:CGPointMake(innerHMargin + (kItemWidth + innerHMargin * 1.5 ) * i, _contentView.height)];
    }
    
}

- (UIView *)actionViewWithTitle:(NSString *)title image:(NSString *)imageName action:(SEL)action{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kItemWidth, kItemHeight)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setSize:CGSizeMake(kItemWidth, kItemWidth)];
    [view addSubview:button];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, button.bottom, view.width, kItemHeight - button.bottom)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    
    return view;
}

- (void)sendNotification{
    [self dismissWithCompletion:^{
//        NotificationSendVC *sendVC = [[NotificationSendVC alloc] init];
//        [CurrentROOTNavigationVC pushViewController:sendVC animated:YES];
        NotificationHistoryVC *notificationHistoryVC = [[NotificationHistoryVC alloc] init];
        [CurrentROOTNavigationVC pushViewController:notificationHistoryVC animated:YES];
    }];
}

- (void)newChat{
    [ApplicationDelegate.homeVC selectAtIndex:1];
    [self dismiss];
}

- (void)studentAttendance{

    [self dismissWithCompletion:^{
        AttendanceVC *classAttendanceVC = [[AttendanceVC alloc] init];
        [CurrentROOTNavigationVC pushViewController:classAttendanceVC animated:YES];
    }];
}

- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.alpha = 0.f;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.f;
    }completion:^(BOOL finished) {
        [self showItems];
    }];
}

- (void)dismiss{
    [self dismissItems];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showItems{
    CGRect fromRect;
    CGRect toRect;
    NSInteger spaceYStart = (_cancelButton.y + _logoView.bottom - kItemHeight) / 2;
    for (NSInteger i = 0; i < _buttonArray.count; i++) {
        UIView* itemView = _buttonArray[i];
        itemView.y = _contentView.height;
        fromRect = itemView.frame;
        toRect = fromRect;
        toRect.origin.y = spaceYStart;
        
        float delayInseconds = i * 0.1;
        [self initailzerAnimationWithToPostion:toRect formPostion:fromRect atView:itemView beginTime:delayInseconds];
    }
}

- (void)dismissItems{
    CGRect fromRect;
    CGRect toRect;
    for (NSInteger i = 0; i < _buttonArray.count; i++) {
        UIView* itemView = _buttonArray[i];
        fromRect = itemView.frame;
        toRect = CGRectMake(fromRect.origin.x, _contentView.height, fromRect.size.width, fromRect.size.height);
        
        float delayInseconds = i * 0.1;
        [self initailzerAnimationWithToPostion:toRect formPostion:fromRect atView:itemView beginTime:delayInseconds];
    }

}

- (void)dismissWithCompletion:(void (^)())completion{
    [self dismissItems];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.f;
    }completion:^(BOOL finished) {
        if(completion){
            completion();
        }
        [self removeFromSuperview];
    }];
}

- (void)initailzerAnimationWithToPostion:(CGRect)toRect formPostion:(CGRect)fromRect atView:(UIView *)view beginTime:(CFTimeInterval)beginTime {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = beginTime + CACurrentMediaTime();
    CGFloat springBounciness = 10 - beginTime * 2;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    
    CGFloat springSpeed = 12 - beginTime * 2;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGRect:toRect];
    springAnimation.fromValue = [NSValue valueWithCGRect:fromRect];
    
    [view pop_addAnimation:springAnimation forKey:@"POPSpringAnimationKey"];
}

@end
