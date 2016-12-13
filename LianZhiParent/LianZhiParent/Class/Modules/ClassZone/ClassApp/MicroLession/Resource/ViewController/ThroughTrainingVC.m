//
//  ThroughTrainingVC.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/28.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ThroughTrainingVC.h"
#import "EDStarRating.h"
#import "Masonry.h"
#import "ResourceDefine.h"
#import "TestBaseVC.h"
#import "TestResultVC.h"
#import "LZQuestionsModel.h"
#import "HKPieChartView.h"
#import "LZThrougnAlertView.h"
#import "ResourceMainVC.h"
#import "LZTestModel.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ParamUtil.h"

@implementation ThroughTrainingCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _mainContentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_mainContentView];

        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_bgView.layer setCornerRadius:10];
        _bgView.image = [UIImage imageNamed:@"ThroughTrainingNormal"];
        [_mainContentView addSubview:_bgView];
        
        NSUInteger height = self.bounds.size.height;
        _nameLabel = [[UILabel alloc] init];//WithFrame:CGRectMake( 0,  25, self.width, 20)];
        _nameLabel.frame = CGRectMake( 0,  height/3 , self.width, 20);
        [_nameLabel setTextColor:JXColor(0x45,0x8c,0x06,1)];
        [_nameLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_mainContentView addSubview:_nameLabel];
        
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height * 82 / 107, self.width, height * 25 /107)];
        [_statusLabel setTextColor:JXColor(0x02,0xa4,0x79,1)];
        [_statusLabel setFont:[UIFont systemFontOfSize:15]];
        [_statusLabel setTextAlignment:NSTextAlignmentCenter];
        [_mainContentView addSubview:_statusLabel];
        _statusLabel.text = @"开始闯关";
    }
    return self;
}


- (void)setQuestionItem:(QuestionItem *)quesionItem
{
    _questionItem = quesionItem;

    _nameLabel.text = quesionItem.chapter_name;
    
    if(quesionItem.status == NotComplated_Status)
         [self setNotCompletedPercent];
    
    if(quesionItem.status == Complated_Status)
         [self setStar];
}

- (void)setStar{
    
}

- (void)setNotCompletedPercent{
    
}
@end

@implementation ThroughTrainingNotComplatedCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //设置背景图的样式
        _bgView.image = [UIImage imageNamed:@"ThroughTrainingPause"];
        [_statusLabel setTextColor:JXColor(0x02,0xa4,0x79,1)];
        _statusLabel.text = @"查看";
        
         NSUInteger height = self.bounds.size.height;
        //调整关卡标签的位置
        _nameLabel.frame = CGRectMake( 0,  height/3, self.width, 20);
        
        //设置Pie图的样式
        _pieChartView = [[HKPieChartView alloc]initWithFrame:CGRectMake(10,height * 8 /107, self.width-20, self.width-20)];
        [_mainContentView addSubview:_pieChartView];
        [_pieChartView updateTrackColor:WhiteColor];
        [_pieChartView setChartColor:JXColor(0xf3, 0xb3, 0x03, 1) LabelString:@""];
    }
    return self;

}

// 设置Pie 图的数值
- (void)setNotCompletedPercent{

    NSString *cachename = [NSString stringWithFormat: @"TestBaseVC/%@",self.questionItem.q_id];
    NSUInteger  haveTestedCount = 0;
    NSData *data = [NSData dataWithContentsOfFile:cachename];
    if(data.length > 0){
        LZTestModel *testModel= [[LZTestModel alloc]init];
        testModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        haveTestedCount = [testModel checkHaveComplatedCount];
    }
    
    _statusLabel.text = @"继续闯关";
    CGFloat percent = 50;
//    CGFloat percent = haveTestedCount/self.questionItem.qcount;
   
    [_pieChartView updatePercent:[NSString stringWithFormat:@"%f",percent] animation:NO];
}

@end

@implementation ThroughTrainingComplatedCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //设置背景图的样式
        _bgView.image = [UIImage imageNamed:@"ThroughTrainingNormal"];
        
        NSUInteger height = self.bounds.size.height;
        //调整关卡标签的位置与颜色
        [_nameLabel setTextColor:JXColor(0x45,0x8c,0x06,1)];
        _nameLabel.frame = CGRectMake( 0,  height/4, self.width, 20);
        
        [_statusLabel setTextColor:JXColor(0x02,0xa4,0x79,1)];
        
        _statusLabel.text = @"查看";
        
        //设置星星视图的样式
        starRating = [[EDStarRating alloc] initWithFrame:CGRectMake(self.width * 0.17, height/2 - 5, self.width * 0.66, 15.0)];
        starRating.starImage = [UIImage imageNamed:@"StarEmpty"];
        starRating.starHighlightedImage = [UIImage imageNamed:@"StarFull"];
        starRating.maxRating = 3.0;
        starRating.userInteractionEnabled = NO;
        //    starRating.delegate = self;
        starRating.horizontalMargin = 0.0;
        starRating.editable = NO;
        starRating.displayMode = EDStarRatingDisplayFull;
        starRating.backgroundColor = [UIColor clearColor];
        [_mainContentView addSubview:starRating];
        
    }
    return self;
    
}

- (void)setStar{
    starRating.rating = self.questionItem.star;
}

@end

@implementation ThroughTrainingLockCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _bgView.image = [UIImage imageNamed:@"ThroughTrainingLock"];
        [_nameLabel setTextColor:JXColor(0x85,0x85,0x85,1)];
         NSUInteger height = self.bounds.size.height;
        
        _nameLabel.frame = CGRectMake( 0,  height * 0.35 , self.width, 20);
        [_statusLabel setTextColor:JXColor(0x73,0x73,0x73,1)];
        _statusLabel.text = @"未解锁";
    }
    return self;
    
}
@end



@interface ThroughTrainingVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView*           _headerView;
}
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, assign) BOOL isGetThroughTrainingDataing;
@property (nonatomic, strong) QuestionsModel*  chineseModel;
@property (nonatomic, strong) QuestionsModel*  mathModel;
@property (nonatomic, strong) QuestionsModel*  englishModel;
@end

@implementation ThroughTrainingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化数据
    [self setupData];
    
    // 取消排名右侧按钮
    [self addRightNaviItem];
    
    // 添加集合视图
    [self addCollectionView];
    
    // 设置顶部Tabbar 的视图
    [self addHeadViewTitle];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    // 获取本页的数据 默认是获取语文
    [self getThroughTrainingData];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

#pragma mark - 初始化
//添加学力图显示用数据
-(void)setupData
{
    _isGetThroughTrainingDataing = NO;
    _chineseModel = [[QuestionsModel alloc]init];
    _mathModel = [[QuestionsModel alloc]init];
    _englishModel = [[QuestionsModel alloc]init];
    
    NSUInteger academicAnalysisTabIndex =  [[NSUserDefaults standardUserDefaults] integerForKey:@"AcademicAnalysisTabIndex"];
    self.currentIndex =  academicAnalysisTabIndex == 0? 0 : academicAnalysisTabIndex -1;
    
    [self loadCache];
    
}

// 添加 MenuTab 视图
-(void)addHeadViewTitle
{
    [self setTitleArray:@[@"语文",@"数学",@"英语"]];
    
    [self initViewCurrentIndex];
}

//取消右侧导航按钮
-(void)addRightNaviItem
{
    self.baseRootVC.navigationItem.rightBarButtonItem = nil;
}


// 添加CoolectionView 闯关集合视图
-(void)addCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _headerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 112, self.view.frame.size.width, self.view.frame.size.height - 112 - 48 ) collectionViewLayout:layout];
    [_headerView setShowsHorizontalScrollIndicator:NO];
    [_headerView setAlwaysBounceHorizontal:YES];
    [_headerView setBackgroundColor:[UIColor clearColor]];
    [_headerView setDataSource:self];
    [_headerView setDelegate:self];
    _headerView.bounces = NO;
    
    [_headerView registerClass:[ThroughTrainingCell class] forCellWithReuseIdentifier:@"ThroughTrainingCell"];
    
    [_headerView registerClass:[ThroughTrainingNotComplatedCell class] forCellWithReuseIdentifier:@"ThroughTrainingNotComplatedCell"];

    [_headerView registerClass:[ThroughTrainingComplatedCell class] forCellWithReuseIdentifier:@"ThroughTrainingComplatedCell"];
    
    [_headerView registerClass:[ThroughTrainingLockCell class] forCellWithReuseIdentifier:@"ThroughTrainingLockCell"];
    [self.view addSubview:_headerView];
}


//设置顶部菜单按钮视图当前Index
-(void)refreshHeadLine:(NSInteger)currentIndex
{
    self.currentIndex=currentIndex;
    [self getThroughTrainingData];

}

- (EmptyHintView *)emptyView{
    if(!_emptyView){
        _emptyView = [[EmptyHintView alloc] initWithImage:@"nogateImage" title:@""];
    }
    return _emptyView;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger count = 0;
    if(self.currentIndex == 0){
        count = [self.chineseModel.qustionList.modelItemArray count];
    }
    else if(self.currentIndex == 1){
        count = [self.mathModel.qustionList.modelItemArray count];
      
    }else
    {
        count = [self.englishModel.qustionList.modelItemArray count];
    }
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ThroughTrainingCell *cell ;

    QuestionItem *item = nil;
    if(self.currentIndex == 0){
        item = [self.chineseModel.qustionList.modelItemArray
                objectAtIndex:indexPath.row];
    }
    else if(self.currentIndex == 1){
        item = [self.mathModel.qustionList.modelItemArray objectAtIndex:indexPath.row];
        
    }
    else{
        item = [self.englishModel.qustionList.modelItemArray objectAtIndex:indexPath.row];
        
    }
  
    if(item.status == NotComplated_Status){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThroughTrainingNotComplatedCell" forIndexPath:indexPath];
    }
    else if(item.status == Complated_Status){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThroughTrainingComplatedCell" forIndexPath:indexPath];
    }
    else if(item.status == UnLocked_Status){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThroughTrainingCell" forIndexPath:indexPath];
    }
    else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThroughTrainingLockCell" forIndexPath:indexPath];
    }
    
    
    [cell setQuestionItem:item];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    self.scrolled = NO;
    self.curIndex = indexPath.row;
    
    ThroughTrainingCell *cell = (ThroughTrainingCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(cell.questionItem.status != Lock_Status){
        NetworkStatus status = [ApplicationDelegate.hostReach currentReachabilityStatus];
        
        if(status == NotReachable)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            hud.labelText = @"请确认当前是否有可使用网络!";
            // 隐藏时候从父控件中移除
            hud.removeFromSuperViewOnHide = YES;
            // YES代表需要蒙版效果
            hud.dimBackground = YES;
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:2];
            return;
        }
        else
            [self showCustomUIAlertView:cell.questionItem];
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemWidth = (self.view.width - 60)/ 3 ;
    NSInteger itemHeight = itemWidth*214/172;
    return CGSizeMake(itemWidth, itemHeight);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 15, 20, 15);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// 按下集合石图之后的弹框处理
- (void)showCustomUIAlertView:(QuestionItem *)item{
 
    if(item.status == Complated_Status)
    {
//        NSInteger count = (long)item.qcount - (long)item.correctNum > 0 ?  item.qcount - item.correctNum : 0;
//        
//        BOOL enable = (count == 0?NO:YES);
//        [alertView setActionButtonEnable:enable];
        [self getCurrentResultData:(QuestionItem *)item];
    }
    else
    {
        LZThrougnAlertView *alertView = [[LZThrougnAlertView alloc]initWithViewController:self
                                                                                   Status:item.status];
        [alertView setItem:item];
        
        alertView.subjectCode = self.currentIndex  + 1;
    }
    
}


- (NSString *)cacheFileName
{
    if(self.currentIndex == 0){
        return @"ThroughTrainingVC-chineseModel";
    }
    else if(self.currentIndex == 1){
        return @"ThroughTrainingVC-mathModel";
    }else
    {
        return @"ThroughTrainingVC-englishModel";
    }

}

#pragma mark - 缓存相关
- (BOOL)supportCache
{
    return NO;
}

- (void)loadCache
{
    if([self supportCache])//支持缓存，先出缓存中读取数据
    {
        NSData *data = [NSData dataWithContentsOfFile:[self cacheFilePath]];
        if(data.length > 0){
            if(self.currentIndex == 0){
                self.chineseModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            else if(self.currentIndex == 1){
                self.mathModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }else
            {
                self.englishModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
        }
    }
}

- (void)saveCache{
    if([self supportCache])
    {
        NSData *modelData = nil;
        if(self.currentIndex == 0){
            modelData = [NSKeyedArchiver archivedDataWithRootObject:self.chineseModel];
        }
        else if(self.currentIndex == 1){
            modelData = [NSKeyedArchiver archivedDataWithRootObject:self.mathModel];
        }else
        {
            modelData = [NSKeyedArchiver archivedDataWithRootObject:self.englishModel];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success = [modelData writeToFile:[self cacheFilePath] atomically:YES];
            if(success)
                DLOG(@"save success");
        });
    }
    
}

#pragma mark - 获取数据
// 获取学力相关数据
- (void)getCurrentResultData:(QuestionItem *)item
{
    
    NSString *sq_id =  [NSString stringWithFormat:@"%@",item.sq_id];
    NSString *q_id =  [NSString stringWithFormat:@"%@",item.q_id];
   
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setValue:q_id forKey:@"q_id"];  //self.qItem.q_id
    [params setValue:sq_id forKey:@"sq_id"];


    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在获取上次试卷结果" toView:self.view];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"evaluation/getStudentAnswer?" method:REQUEST_POST
                                                      type:REQUEST_REFRESH withParams:params observer:nil
                                                completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                                                    
                                                    if(responseObject){
                                                        LZTestModel *testModel = [[LZTestModel alloc]init];
                                                        [testModel parseData:responseObject type:REQUEST_REFRESH];
                                                      
                                                        TestResultVC *resultVC = [[TestResultVC alloc]init];
                                                        resultVC.testResultitem = testModel;
                                                        resultVC.qItem = item;
                                                        resultVC.rootVC = wself;
                                                        resultVC.title = item.chapter_name;
                                                        [CurrentROOTNavigationVC pushViewController:resultVC animated:YES];
                                                    }
                                                    
                                               
                                                    [hud hide:YES];
                                                    
                                                } fail:^(NSString *errMsg) {
                                                    dispatch_async(dispatch_get_main_queue(), ^(){
                                                    
                                                        [hud hide:YES];
                                                        [ProgressHUD showHintText:errMsg];
                                                        
                                                    });
                                                    
                                                }];
    
}


// 获取学力相关数据
- (void)getThroughTrainingData
{
    if(_isGetThroughTrainingDataing)
        return;
    

    
    [self showEmptyView:NO];
    _isGetThroughTrainingDataing = YES;
    
    NSMutableDictionary *params =  [[ParamUtil sharedInstance] getParam];
    
//    NSString *childId = [UserCenter sharedInstance].curChild.uid;
    NSString *subject_id = [NSString stringWithFormat:@"%lu",(self.currentIndex + 1)];
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setValue:childId forKey:@"child_id"];
    [params setValue:subject_id forKey:@"subject_code"];
    
//    ResourceMainVC *mainVC = nil;
//    
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[ResourceMainVC class]]) {
//            mainVC  = (ResourceMainVC *)temp;
//            break;
//        }
//    }
//    
//    NSString *class_id =  mainVC.classInfo.classID;
//    [params setValue:class_id forKey:@"class_id"];
    
    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在获取信息" toView:self.view];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"evaluation/getQuestions" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        
        if(responseObject){
            NSUInteger count = 0;
            if(wself.currentIndex == 0){
                [wself.chineseModel parseData:responseObject];
                count = [self.chineseModel.qustionList.modelItemArray count];
                [self showEmptyView:count == 0];
            }
            else if(wself.currentIndex == 1){
                [wself.mathModel parseData:responseObject];
                count = [self.mathModel.qustionList.modelItemArray count];
                [self showEmptyView:count == 0];
            }else
            {
                [wself.englishModel parseData:responseObject];
                count = [self.englishModel.qustionList.modelItemArray count];
                [self showEmptyView:count == 0];
            }
        }
        
        wself.isGetThroughTrainingDataing = NO;
        [wself saveCache];
        [_headerView reloadData];
        [hud hide:YES];
        
    } fail:^(NSString *errMsg) {
        wself.isGetThroughTrainingDataing = NO;
        [hud hide:YES];
        [_headerView reloadData];
        [ProgressHUD showHintText:errMsg];
        
    }];
    
}


@end
