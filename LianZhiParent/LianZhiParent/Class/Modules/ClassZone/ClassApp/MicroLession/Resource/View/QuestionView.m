
//
//  QuestionSelectTypeCell.m
//  LianzhiParent
//
//  Created by chen on 16/10/12.
//  Copyright © 2016年 SJWY. All rights reserved.
//
#import "QuestionView.h"
#import "ResourceDefine.h"
#import "LZTestModel.h"
#import "TestBaseVC.h"
#import "ChatVoiceButton.h"
#import "TPKeyboardAvoidingTableView.h"
//#import "NCMusicEngine.h"

#define  kQuestionBarHeight  44
#define  kQuestionAnswerViewHeight  44

#import "DOUAudioStreamer.h"
#import "Track.h"
//#import "DOUAudioVisualizer.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@implementation TestVoiceButton

#pragma mark - life
- (id)initWithFrame:(CGRect)frame UrlString:(NSString *)songUrlString
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp:songUrlString];
    }
    return self;
}



- (void)setUp:(NSString *)songUrlString
{
    // 如果有需要 下载的时候加入菊花
    // [self addSubview:self.indicator];
    if(!songUrlString || [songUrlString isEqualToString:@""])
        return;
    
    [self _cancelStreamer];
    
    Track *track = [[Track alloc]init];
    track.audioFileURL = [NSURL URLWithString:songUrlString];
    
    
    _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius= 2;

   

}

// 如果有需要 下载的时候加入菊花
//- (UIActivityIndicatorView *)indicator
//{
//    if (!_indicator) {
//        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        
//    }
//    return _indicator;
//}


- (void)_cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
}

- (void)_resetStreamer:(NSString *)songUrlString
{
//    
//    if(!songUrlString || [songUrlString isEqualToString:@""])
//        return;
//    
//    [self _cancelStreamer];
//    
//    Track *track = [[Track alloc]init];
//    track.audioFileURL = [NSURL URLWithString:songUrlString];
//    [DOUAudioStreamer setHintWithAudioFile:track];
    // 测试数据，暂且屏蔽
    // songUrlString = @"http://datashat.net/music_for_programming_18-konx_om_pax.mp3";


//
//    
//    _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
//    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
//    [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
//    [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
//    
////    [_streamer play];
//    
//    [self _updateBufferingStatus];

}

// 测试数据，下载进度的显示 暂且屏蔽
- (void)_updateBufferingStatus
{
//    [_miscLabel setText:[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]];
    
//    if ([_streamer bufferingRatio] >= 1.0) {
//        NSLog(@"sha256: %@", [_streamer sha256]);
//    }
}


// 按钮的点击事件处理
- (void)_actionPlayPause:(id)sender
{
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
    }
    else if ([_streamer status] ==DOUAudioStreamerFinished){
        // 播完可以重播
        [_streamer play];
    }
    else{
        // 不允许暂停 必须播完
        return;
        //        [_streamer pause];
    }
}

- (void)_actionClose
{
    [_streamer stop];
    [self _cancelStreamer];
}
// 刷新状态处理
- (void)_updateStatus
{
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            self.imageView.image = [UIImage animatedImageNamed:@"play" duration:1.0f];
            break;
            
        case DOUAudioStreamerPaused:
        case DOUAudioStreamerIdle:
        case DOUAudioStreamerFinished:
        case DOUAudioStreamerBuffering:
            self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"play3"]];
            break;
            
        case DOUAudioStreamerError:
            self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"play3"]];
            break;
    }
}

// 刷新进度
- (void)_timerAction:(id)timer
{
    if ([_streamer duration] == 0.0) {
//        刷新进度
//        [_progressSlider setValue:0.0f animated:NO];
    }
    else {
//        [_progressSlider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
    }
}

// KVO 监听事件处理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(_timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(_updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end

@interface QuestionSelectTypeView (){
    NSMutableArray *selectedPaths;
    TestVoiceButton *playButton;
    UIActivityIndicatorView  *activityIndicator;
    float ShowImage_HH;
}

@property(strong,nonatomic)NSIndexPath *lastSelected;
@end


@implementation QuestionSelectTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
      
        self.backgroundColor = BgGrayColor;
        selectedPaths = [NSMutableArray array];
        ShowImage_HH = 0.0f;
        self.lastSelected = [NSIndexPath indexPathForRow:0 inSection:1];
//        [selectedPaths addObject:index];
        
        _answerView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        [_answerView setDelegate:self];
        [_answerView setDataSource:self];
        _answerView.separatorStyle = UITableViewCellSeparatorStyleNone;   
        self.answerView.backgroundColor= [UIColor clearColor];
        [self addSubview:self.answerView];
        
        
    }
        
        
    return self;
        
}

- (instancetype)initWithFullFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = BgGrayColor;
        selectedPaths = [NSMutableArray array];
        _answerView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)  style:UITableViewStyleGrouped];
        [_answerView setDelegate:self];
        [_answerView setDataSource:self];
        _answerView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.answerView.backgroundColor= [UIColor clearColor];
        [self addSubview:self.answerView];
    }
    
    
    return self;
    
}

- (void)dealloc
{
    // 如果有正在播放声音，需要停止播放
    if(playButton)
    {
        [playButton _actionClose];
    }
    DLOG(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)setTestItem:(TNModelItem *)modelItem
{
    _testItem = (TestItem *)modelItem;
    _optionArray = nil;
    self.et_code = _testItem.et_code;
    
    TestSubItem *subItem = [_testItem.praxis.modelItemArray firstObject];
    if(subItem){
        self.testSubItem = subItem;
        if(subItem.option && subItem.option.modelItemArray.count > 0){
            _optionArray =  subItem.option;
        }
    }
    self.lastSelected = nil;
    _answerView.tableHeaderView = [self headerView];
    
//    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:1];
//    [_answerView selectRowAtIndexPath:index animated:YES scrollPosition: UITableViewScrollPositionNone];
    
    [self.answerView reloadData];
}

- (void)setSubItem:(TNModelItem *)modelItem
{    
    TestSubItem *subItem = (TestSubItem *)modelItem;
    self.testSubItem = subItem;
    _optionArray = nil;
    _optionArray =  subItem.option;
    self.lastSelected = nil;
    _answerView.tableHeaderView = [self headerViewBySubItem:subItem];
    [self.answerView reloadData];
}


// 题干的初始化
- (UIView *)headerViewBySubItem:(TestSubItem *)subItem{
    if(subItem){
        _questionView = nil;
        [self  creatHeaderView:subItem];
    }
    
    return _questionView;
}

- (UIView *)headerView{
    TestSubItem *subItem = [_testItem.praxis.modelItemArray firstObject];
    if(subItem){
        _questionView = nil;
        
        [self  creatHeaderView:subItem];
    }
    
    return _questionView;
}



-(UIView *)creatTextView:(TestSubItem *)subItem
{
    if(!_questionView){
        _questionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.frame.size.height / 3)];
    }

    // 文字类型的题干
    UITextView *textView = [[UITextView alloc] init];
   
    [textView setFont:[UIFont systemFontOfSize:18]];
    textView.backgroundColor = ClearColor;
    textView.editable = NO;
    
    [_questionView addSubview:textView];
    
    if(!subItem)
       subItem = [_testItem.praxis.modelItemArray firstObject];
    
    if(subItem){
        textView.text = subItem.stem;
    }

    CGSize size = CGSizeMake(self.width - 40 -16.0, CGFLOAT_MAX); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18]};
    
    CGSize sizeToFit = [subItem.stem boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    [textView setFrame:CGRectMake(20, 0,  self.width - 40, sizeToFit.height + 26.0
                                   )];
    
    return _questionView;
}


-(UIView *)creatHeaderView:(TestSubItem *)subItem
{
    if(!_questionView){
        _questionView = [[UIView alloc] init];
    }
    
    CGSize size = CGSizeMake(self.width - 40 -16.0, CGFLOAT_MAX); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18]};
    
    CGSize sizeToFit = [subItem.stem boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    CGFloat height = sizeToFit.height + 20;
    // 文字类型的题干
    UITextView *textView = [[UITextView alloc] init];
    [textView setFrame:CGRectMake(5, 0,  self.width -10, height)];
    [textView setFont:[UIFont systemFontOfSize:18]];
    textView.backgroundColor = ClearColor;
    textView.editable = NO;
    
    [_questionView addSubview:textView];
    
//    if(self.testItem.et_code != LZTestReadingComprehensionType &&
//       self.testItem.et_code != LZTestClozetestType)
//    {
//        NSString *stemStr = [NSString stringWithFormat:@"(题号) %ld/%lu \r\n %@",(long)self.testItem.index, self.qcount,subItem.stem];
//        textView.text = stemStr;
//    }
//    else
//    {
//        textView.text = subItem.stem;
//    }
    textView.text = subItem.stem;
    height = height + 10;
    // 听力类型的题干
    if(subItem.soundAudioItem && subItem.soundAudioItem.audioUrl &&
            ![subItem.soundAudioItem.audioUrl isEqualToString:@""])
    {
        playButton = [[TestVoiceButton alloc]initWithFrame:CGRectMake(WIDTH/2 - 38, height, 76, 27) UrlString:subItem.soundAudioItem.audioUrl];
    
        
        [playButton setBackgroundColor:GreenLineColor];
        [playButton setImage:[UIImage imageNamed:@"play1"] forState:UIControlStateNormal];
        
        [playButton addTarget:self action:@selector(onAudioClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_questionView addSubview:playButton];
        
        height = height + 37;
        
        
    }
 
    if(subItem.img_url && ![subItem.img_url isEqualToString:@""]){
        UIImageView *imageView = [[UIImageView alloc] init];
        
        CGFloat imageHeight =  ShowImage_HH == 0? (self.width -10)*0.6 : ShowImage_HH;
        [imageView setFrame:CGRectMake(5, height,  self.width -10, imageHeight)];
        [_questionView addSubview:imageView];
        
        height = height + 20;
        self.viewHeight = height > self.frame.size.height / 3 ? height : self.frame.size.height / 3;
        _questionView.frame = CGRectMake(0, 0, self.width, self.viewHeight);
        

//        [imageView sd_setImageWithURL:[NSURL URLWithString:subItem.img_url]
//                     placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:subItem.img_url] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            if (!activityIndicator)
            {
                activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.center = imageView.center;
                //把更新UI放到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [imageView addSubview:activityIndicator];
                });
                
                [activityIndicator startAnimating];
            }
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            float a = image.size.width;
            float b = image.size.height;
            if(a > 0)
                ShowImage_HH = (self.width -10)*b/a;//600/4;
            else
                ShowImage_HH = 0;
            
            float image_height = height;
            NSLog(@"----width--%f----height--%f-------",a,b);

            imageView.frame = CGRectMake(5, image_height,  self.width -10, ShowImage_HH);
            image_height = image_height + ShowImage_HH + 20;
            
            self.viewHeight = image_height > self.frame.size.height / 3 ? image_height : self.frame.size.height / 3;
            _questionView.frame = CGRectMake(0, 0, self.width, self.viewHeight);

            //改变图片的显示方式-----让它不压缩，部分显示
  
            [activityIndicator stopAnimating];
            
            [_answerView beginUpdates];
            [_answerView setTableHeaderView:_questionView];
            [_answerView endUpdates];
            
//            [_answerView reloadData];
        }];
        
        
//        height = height + (self.width -10)*0.6;
    }
    else{
        height = height + 20;
        self.viewHeight = height > self.frame.size.height / 3 ? height : self.frame.size.height / 3;
        _questionView.frame = CGRectMake(0, 0, self.width, self.viewHeight);
    }
    
//
    return _questionView;
}

-(UIView *)creatImageView:(TestSubItem *)subItem
{
    if(!_questionView){
        _questionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.frame.size.height / 3)];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setFrame:CGRectMake(5, 5,  self.width -10, self.frame.size.height / 3- 10)];
    [_questionView addSubview:imageView];
    
    if(!subItem)
         subItem = [_testItem.praxis.modelItemArray firstObject];
    
    if(subItem){
        [imageView sd_setImageWithURL:[NSURL URLWithString:subItem.img_url]
                     placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    }
    
    
    
    [_questionView addSubview:imageView];
    
    return _questionView;
}

- (void)onAudioClicked:(UIButton *)sender{
    //http://v.test.img.5tree.cn/voice/28/61/2286105.amr
    //    2016-10-18 10:30:25.247600
    TestVoiceButton *playBtn = (TestVoiceButton *)sender;
    TestSubItem *subItem = [_testItem.praxis.modelItemArray firstObject];
    if(subItem){
        AudioItem *audioItem = subItem.soundAudioItem;
        [playBtn _resetStreamer:audioItem.audioUrl];
        [playBtn _actionPlayPause:audioItem.audioUrl];
    }
    
//    NCMusicEngine *_player = [[NCMusicEngine alloc] init];
//    _player.delegate = self;
//    [_player playUrl:[NSURL URLWithString:@"http://datashat.net/music_for_programming_18-konx_om_pax.mp3"]];
    
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _optionArray.modelItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 圆角弧度半径
    CGFloat cornerRadius = 6.f;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, 10, 0);
    
    // CGRectGetMinY：返回对象顶点坐标
    // CGRectGetMaxY：返回对象底点坐标
    // CGRectGetMinX：返回对象左边缘坐标
    // CGRectGetMaxX：返回对象右边缘坐标
    // CGRectGetMidX: 返回对象中心点的X坐标
    // CGRectGetMidY: 返回对象中心点的Y坐标
    
    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    
    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMidY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
//        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        // 添加cell的rectangle信息到path中（不包括圆角）
        //假如用填充色，用这个
        //        CGPathAddRect(pathRef, nil, bounds);
        
        //假如只要边框
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.strokeColor = ClearColor.CGColor;//  [UIColor blackColor].CGColor;
    layer.fillColor =  WhiteColor.CGColor; //[UIColor clearColor].CGColor;
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    cell.backgroundView = roundView;
    
    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor =JXColor(0x88, 0x88, 0x88, 1).CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
    
    NSInteger section = indexPath.section;
    AnswerItem *aItem = _optionArray.modelItemArray[section];
 
    [cell setSelected:aItem.isChecked animated:NO];
    
    if(self.testItem.et_code != LZTestFillInTheBlankType)
        [(AnswerCell *)cell setCellStyle:aItem.isChecked];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.section;
   
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell"];
    if(cell == nil)
    {
        cell = [[AnswerCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"AnswerCell"];
    }
    
    AnswerItem *aItem = _optionArray.modelItemArray[row];
    cell.tag = row;
    cell.isEditModel = self.isEditModel;
    cell.type = self.testItem.et_code;
    cell.userAnswer = [NSString stringWithString:self.testSubItem.userAnswer];
    cell.answer = self.testSubItem.answer;
//    cell.editAnswer = self.testSubItem.editAnswer;
//    __weak typeof(self) wself = self;
//    cell.textEditedhandler =  ^(NSString *text) {
//        //        [self dismissViewControllerAnimated:YES completion:nil];
//        wself.testSubItem.editAnswer = [NSMutableString stringWithString:text];
//    };
    
    
    [cell setAnswerItem:aItem];
    
//  [cell setCellStyle:aItem.isChecked];
    if(!self.lastSelected && self.testSubItem.answerCount == 1 && aItem.isChecked == YES)
    {
        self.lastSelected = indexPath;
    }

    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.isEditModel == NotEditEnable_Status && (self.testItem && self.testItem.et_code == LZTestFillInTheBlankType) && section == _optionArray.modelItemArray.count -1)
    {
        return (MAX(60, (self.testSubItem.option.modelItemArray.count + 1 ) * 40 ));
    }
    else
        return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(self.isEditModel == NotEditEnable_Status && (self.testItem && self.testItem.et_code == LZTestFillInTheBlankType) && section == _optionArray.modelItemArray.count -1){
        // 文字类型的题干
        UITextView *textView = [[UITextView alloc] init];
        [textView setFrame:CGRectMake(5, 0,  self.width -10, 60)];
        [textView setFont:[UIFont systemFontOfSize:16]];
        textView.backgroundColor = ClearColor;
        textView.editable = NO;
        
        NSArray * answerArray = [self.testSubItem.answer componentsSeparatedByString:@"^"];
        NSMutableString *answer = [NSMutableString string];
        [answer appendFormat:@"\n 正确答案: \n"];
        NSUInteger index = 1;
        for(NSString * anserItem in answerArray){
            [answer appendFormat:@"(%lu) %@ \n",(unsigned long)index++, anserItem];
        }
        textView.text = answer;
        return textView;
    }
    else
    {
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [selectedPaths removeAllObjects];
    
    if(self.isEditModel == Edited_Status)
    {
//        self.testSubItem.editAnswer = nil;
//        self.testSubItem.editAnswer = [NSMutableString string];
    }
    else if(self.isEditModel == NotEditEnable_Status)
    {
        return;
    }
    
    if((self.testItem && self.testItem.et_code == LZTestMultiSelectTypType) ||
       (self.testItem.et_code == LZTestReadingComprehensionType && self.testSubItem.answerCount > 1 ) ||
       (self.testItem.et_code == LZTestClozetestType && self.testSubItem.answerCount > 1 ))
    {
        NSLog(@"Select indexPath row = %ld",(long)indexPath.row);
    }else
    {
        NSIndexPath *temp = self.lastSelected;//暂存上一次选中的行
        if(temp && temp!=indexPath)//如果上一次的选中的行存在,并且不是当前选中的这一样,则让上一行不选中
        {
            AnswerItem *lItem = _optionArray.modelItemArray[temp.section];
            lItem.isChecked = !lItem.isChecked;
            [selectedPaths addObject:temp];

        }
    }
   [selectedPaths addObject:indexPath];
    self.lastSelected = indexPath;//选中的修改为当前行
    AnswerItem *aItem = _optionArray.modelItemArray[indexPath.section];

    aItem.isChecked = !aItem.isChecked;

    [tableView reloadData];

}


@end

@implementation ReadingQuestionTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = BgGrayColor;

        // 1.添加所有子控制器
        self.titles = [NSMutableArray array];

        CGFloat height = self.frame.size.height * 0.6  -  kQuestionBarHeight  - kQuestionAnswerViewHeight;
        _questionOfBarView = [[QuestionSelectTypeView alloc] initWithFullFrame:CGRectMake(0, frame.size.height - kQuestionAnswerViewHeight, self.frame.size.width, height)];
        _questionOfBarView.answerView.backgroundColor = TrackBgColor;
        
        [self addSubview:self.questionOfBarView];
        
        [self creatTextView];
        
        self.topTitleView = [SGTopTitleView topTitleViewWithFrame:CGRectMake(0, frame.size.height - kQuestionAnswerViewHeight, self.frame.size.width, kQuestionAnswerViewHeight)];
        
        _topTitleView.delegate_SG = self;
        [self addSubview:_topTitleView];
        [self creatBarView];
    }
    
    
    return self;
    
}


- (void)setTestItem:(TNModelItem *)modelItem
{
    _testItem = (TestItem *)modelItem;
    _optionArray = nil;
    _questionOfBarView.isEditModel = self.isEditModel;
    _questionOfBarView.et_code = _testItem.et_code;
    self.questionOfBarView.testItem = _testItem;
    
    TestSubItem *subItem = [_testItem.praxis.modelItemArray firstObject];
    if(subItem){
        if(subItem.option && subItem.option.modelItemArray.count > 0){
            _optionArray =  subItem.option;
        }

        self.textView.text = _testItem.material;

        NSString  *page = [NSString stringWithFormat:@"1/%lu",(unsigned long)_testItem.praxis.modelItemArray.count];
        [self updateBarPage:page];
  
        for(TestSubItem *subItem in _testItem.praxis.modelItemArray){
            [self.titles addObject:[NSString stringWithFormat:@"%ld",(long)subItem.index]];
        }
        _topTitleView.scrollTitleArr = nil;
        _topTitleView.scrollTitleArr = [NSArray arrayWithArray:_titles];
        
        [self.questionOfBarView setSubItem:subItem];
        [self.questionOfBarView.answerView reloadData];
    }
  
}

-(void)updateBarPage:(NSString *)page
{
    self.introLabel.hidden = YES;
//    NSString *string = @"6/28";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:page];
    NSUInteger length = [page length];
    
    //设置字体
    NSRange greenStartRange = [page rangeOfString:@"/"];
    
    UIFont *sysFont = [UIFont systemFontOfSize:16.0]; //设置所有的字体
    
    [attrString addAttribute:NSFontAttributeName value:sysFont
                       range:NSMakeRange(0, length)];//设置T字体
    
    
    
    // 设置颜色
    UIColor *color = GrayLblColor;
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:NSMakeRange(0, length)];
    
    UIColor *greencolor = GreenLblColor;
    NSUInteger greenLength = 0 ;
    
    
    if(greenStartRange.length > 0)
    {
        greenLength = greenStartRange.location - 0;
    }
    
    [attrString setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18],NSForegroundColorAttributeName :greencolor} range:NSMakeRange(0,greenLength)];
    
    self.introLabel.attributedText = attrString;
}
-(UIView *)creatBarView
{
  
    // 文字类型的题干
    self.barView = [[UIView alloc] init];
    [self.barView setFrame:CGRectMake(0,
                                      self.frame.size.height  - kQuestionBarHeight - kQuestionAnswerViewHeight,  self.width , kQuestionBarHeight)];
    self.barView.backgroundColor = WhiteColor;
    
    UILabel *sepLabel=[[UILabel alloc]initWithFrame:CGRectMake(0 ,0, self.width , 1)];

    [sepLabel setBackgroundColor:SepLineColor];
    [self.barView addSubview:sepLabel];
    
    self.introLabel=[[UILabel alloc]initWithFrame:CGRectMake(10 , 8, 100 , 25)];
    self.introLabel.textColor = JXColor(0x61, 0x61, 0x61, 1) ;
    [self.introLabel setTextAlignment:NSTextAlignmentLeft];

    [self.barView addSubview:self.introLabel];

    
    UIButton *updownButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    updownButton.frame= CGRectMake(WIDTH - 44, 11, 22, 22);
    
    [updownButton setBackgroundImage:[UIImage imageNamed:@"arrowSq"] forState:UIControlStateNormal];
    [updownButton setBackgroundImage:[UIImage imageNamed:@"arrowTc"] forState:UIControlStateSelected];
    
    [updownButton addTarget:self action:@selector(onHeightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.barView addSubview:updownButton];
 
    [self addSubview:self.barView];
    [self onHeightClicked:updownButton];
    return self.barView;
}

-(UIView *)creatTextView
{
    // 文字类型的题干
    self.textView = [[UITextView alloc] init];
    [self.textView setFrame:CGRectMake(20, 5,  self.width - 40, self.frame.size.height  - 88)];
    [self.textView setFont:[UIFont systemFontOfSize:18]];
    self.textView.backgroundColor = ClearColor;
    self.textView.editable = NO;
    
    [self addSubview:self.textView];
    
    
    return self.textView;
}

- (void)onHeightClicked:(UIButton *)sender{
   
    sender.selected = !sender.selected;
    
    NSInteger height = self.barView.frame.origin.y;
    NSInteger tableHeight = self.questionOfBarView.frame.size.height;
    NSInteger textHeight = self.frame.size.height  - 88;
    if(height == self.frame.size.height  -   kQuestionBarHeight  - kQuestionAnswerViewHeight)
    {
        height = self.frame.size.height/2;
        tableHeight = height -  kQuestionBarHeight  - kQuestionAnswerViewHeight;
        textHeight = self.frame.size.height/2;
    }
    else
    {
        height = self.frame.size.height   -   kQuestionBarHeight  - kQuestionAnswerViewHeight;
        tableHeight = 0;

    }
    
     __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.25 animations:^{
        [wself.questionOfBarView setFrame:CGRectMake(0, height + kQuestionBarHeight , wself.barView.frame.size.width,
                                          tableHeight)];
        [wself.questionOfBarView.answerView setFrame:CGRectMake(0, 0 , wself.barView.frame.size.width,
                                                    tableHeight)];
        [wself.textView setFrame:CGRectMake(20, 5,  wself.width - 40, textHeight)];
        
        [wself.questionOfBarView.answerView reloadData];

        [wself.barView setFrame:CGRectMake(0, height,
                                          wself.barView.frame.size.width,
                                          wself.barView.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
        
    
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    NSString  *page = [NSString stringWithFormat:@"%ld/%lu",index + 1,(unsigned long)_testItem.praxis.modelItemArray.count];
    [self updateBarPage:page];
    
    // 回滚到顶部
    [self.questionOfBarView.answerView setContentOffset:CGPointMake(0,0) animated:NO];
    
    if(index < _testItem.praxis.modelItemArray.count){
        TestSubItem *subItem =  [_testItem.praxis.modelItemArray objectAtIndex:index];
        [self.questionOfBarView setSubItem:subItem];
   
    }

}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 2.把对应的标题选中
    UILabel *selLabel = self.topTitleView.allTitleLabel[index];
    
    
    [self.topTitleView scrollTitleLabelSelecteded:selLabel];
    // 3.让选中的标题居中
    [self.topTitleView scrollTitleLabelSelectededCenter:selLabel];
}


@end
