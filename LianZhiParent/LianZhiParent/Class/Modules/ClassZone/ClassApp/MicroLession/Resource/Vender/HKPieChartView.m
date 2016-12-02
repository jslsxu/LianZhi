//
//  HKPieChartView.m
//  PieChart
//
//  Created by hukaiyin on 16/6/20.
//  Copyright © 2016年 HKY. All rights reserved.
//

#import "HKPieChartView.h"

@interface HKPieChartView()

@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIBezierPath *progressPath;
@property (nonatomic, assign) CGFloat percent; //饼状图显示的百分比，最大为100
@property (nonatomic, assign) CGFloat animationDuration;//动画持续时长
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, assign) CGFloat pathWidth;
@property (nonatomic, assign) CGFloat sumSteps;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, assign) BOOL panAnimationing;

@end

@implementation HKPieChartView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self updateUI];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
//    [self updateUI];
}

- (void)updateUI {
//    self.trackColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.000];//[UIColor blackColor];
//    self.progressColor = [UIColor greenColor];
    self.animationDuration = 3;
    self.pathWidth = self.bounds.size.width / 1.15;
 
    [self trackLayer];
    [self progressLayer];
//    [self gradientLayer];

}

#pragma mark - Load

- (void)loadLayer:(CAShapeLayer *)layer WithColor:(UIColor *)color {
    
    CGFloat layerWidth = self.pathWidth;
    CGFloat layerX = (self.bounds.size.width - layerWidth)/2;
    layer.frame = CGRectMake(layerX, layerX, layerWidth, layerWidth);
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineCap = kCALineCapButt;
    layer.lineWidth = self.lineWidth;
    layer.path = self.path.CGPath;
}

- (void)loadProgressLayer:(CAShapeLayer *)layer WithColor:(UIColor *)color {
    
    CGFloat layerWidth = self.pathWidth;
    CGFloat layerX = (self.bounds.size.width - layerWidth)/2;
    layer.frame = CGRectMake(layerX, layerX, layerWidth, layerWidth);
    layer.fillColor = nil;//[UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineWidth = self.lineWidth;
    [self setProgress];
//    layer.path = self.path.CGPath;
}



#pragma mark - Gesture Action

- (void)didPan:(UIPanGestureRecognizer *)pan {
    if (!self.panAnimationing) {
        
    }
}

#pragma mark - Animation

- (void)updatePercent:(NSString *)percent animation:(BOOL)animationed {
    
    self.percent = [percent floatValue];
   
    [self.progressLayer removeAllAnimations];
    
    if (!animationed) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [CATransaction setAnimationDuration:1];
        self.progressLayer.strokeStart = 0;
        self.progressLayer.strokeEnd =  1;
        
        [self loadProgressLayer:_progressLayer WithColor:self.progressColor];
        [CATransaction commit];
        
        
    } else {
        CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(0.0);
        animation.toValue = @(self.percent / 100.);
        animation.duration = self.animationDuration * self.percent / 100.0;
        animation.removedOnCompletion = YES;
        animation.delegate = self;
        animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

        self.progressLayer.strokeStart = 0;
        self.progressLayer.strokeEnd =  1;
        [self loadProgressLayer:_progressLayer WithColor:self.progressColor];
        [self.progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    self.timer = [NSTimer timerWithTimeInterval:1/60.f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self invalidateTimer];
        self.progressLabel.text = [NSString stringWithFormat:@"%0.f%%", self.percent];
    }
}

- (void)timerAction {
    id strokeEnd = [[_progressLayer presentationLayer] valueForKey:@"strokeEnd"];
    if (![strokeEnd isKindOfClass:[NSNumber class]]) {
        return;
    }
    CGFloat progress = [strokeEnd floatValue];
    self.progressLabel.text = [NSString stringWithFormat:@"%0.f%%",floorf(progress * 100)];
}

- (void)invalidateTimer {
    if (!self.timer) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Getters & Setters

- (CAShapeLayer *)trackLayer {
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer layer];
        
        [self.layer addSublayer:_trackLayer];
    }
    [self loadLayer:_trackLayer WithColor:self.trackColor];
    return _trackLayer;
}

- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _shadowImageView.image = [UIImage imageNamed:@"shadow"];
        [self addSubview:_shadowImageView];
    }
    return _shadowImageView;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        self.progressLayer.strokeEnd = self.percent / 100.0;
        [self.layer addSublayer:_progressLayer];
    }
   
    return _progressLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        [_gradientLayer setStartPoint:CGPointMake(0.5, 1.0)];
        [_gradientLayer setEndPoint:CGPointMake(0.5, 0.0)];
        [_gradientLayer setMask:self.progressLayer];
        [self.layer addSublayer:_gradientLayer];
    }
    
    return _gradientLayer;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _progressLabel.textColor = [UIColor colorWithRed:0.310 green:0.627 blue:0.984 alpha:1.000];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:18];

        [self addSubview:_progressLabel];
    }
    return _progressLabel;
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    _percent = _percent > 100 ? 100 : _percent;
    _percent = _percent < 0 ? 0 : _percent;
}

- (UIBezierPath *)path {
    if (!_path) {
        
        CGFloat halfWidth = self.pathWidth / 2;
        _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfWidth, halfWidth)
                                               radius:(self.pathWidth - self.lineWidth)/2
                                           startAngle:0     //-M_PI/2*3
                                             endAngle:2*M_PI //M_PI/2
                                            clockwise:YES];
    }
    return _path;
}

- (void)setProgress  {
    _progressPath = nil;
    CGFloat halfWidth = self.pathWidth / 2;
    _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfWidth, halfWidth) radius:(self.pathWidth - self.lineWidth)/2 startAngle: -M_PI_2 endAngle:((M_PI * 2) * (self.percent / 100.0) - M_PI_2 )  clockwise:YES]; //- M_PI_2
    _progressLayer.path = _progressPath.CGPath;
   
}

- (CGFloat)lineWidth {
    if (_lineWidth == 0) {
        _lineWidth = 2.5;
    }
    return _lineWidth;
}

- (void)updateTrackColor:(UIColor *)color
{
    self.trackColor = color;
}
- (void)setChartColor:(UIColor *)color  LabelString:(NSString *)string
{
    self.progressColor = color;
    self.progressLabel.textColor = color;
    self.progressLabel.text = string;
//    _gradientLayer= nil;
//    _progressLayer = nil;
    self.percent = 0;
    [self updateUI];
}
@end
