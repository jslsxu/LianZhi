//
//  AcademicAnalysisVC.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/28.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AcademicAnalysisVC.h"
#import "HKPieChartView.h"
#import "MCRadarChartView.h"

#import "ResourceInstructionVC.h"
#import "RankingVC.h"
#import "ResourceDefine.h"
#import "NSString+UrlParams.h"

#import "LZStudyLevelModel.h"
#import "ResourceMainVC.h"
#import "ParamUtil.h"

#define  pieContentHeight   125
#define  menuContentHeight  48
#define  spaceOfContentView 10

@interface AcademicAnalysisVC ()<MCRadarChartViewDataSource>{

    NSMutableArray *titles;   // Pie图显示标签
    NSMutableArray *dataSource;
    NSMutableDictionary *studyDic;
   
}

@property (nonatomic, strong) MCRadarChartView *radarChartView;  // 雷达图
@property (nonatomic, strong) NSMutableArray *chartViewArray;    // 学力图数组
@property (nonatomic, strong) NSMutableArray *chartViewLblArray; // 学力图标签数组
@property (nonatomic, strong) UILabel *studyLabel;               // 学力标签
@property (nonatomic, assign) NSUInteger  currentTabIndex;
@property (nonatomic, strong) TNListModel*  analysisModel;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation AcademicAnalysisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  添加学力图显示用数据
    [self setupData];
    
    //  添加顶部Tabbar 的按钮
    [self addHeadViewTitle];
    
    
    [self addScrollView];
    
    //  添加雷达图
    [self addRadarChart];

    //  添加学力图
    [self addPieChartView];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    //  添加排名右侧导航按钮
    [self addRightNaviItem];
    
    //  刷新数据
    [self getAnalysis];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

#pragma mark -- 初始化各个控件
//添加学力图显示用数据
-(void)setupData
{
    self.currentTabIndex =  [[NSUserDefaults standardUserDefaults] integerForKey:@"AcademicAnalysisTabIndex"];
    
    studyDic = [NSMutableDictionary dictionary];
    [studyDic setObject:JXColor(0xf3,0x64,0x64,1) forKey:@"学霸"];
    [studyDic setObject:JXColor(0xff,0xaf,0x1b,1) forKey:@"高手"];
    [studyDic setObject:JXColor(0xf3,0xd2,0x18,1) forKey:@"优秀"];
    [studyDic setObject:JXColor(0x65,0xca,0x00,1) forKey:@"中等"];
    [studyDic setObject:JXColor(0x95,0x72,0xe5,1) forKey:@"普通"];
    
    self.analysisModel = [[AnalysisModel alloc]init];
    self.view.backgroundColor = BgGrayColor;
    
    _chartViewArray = [NSMutableArray array];              // 学力图数组
    _chartViewLblArray  = [NSMutableArray array];

}

//添加排名右侧导航按钮
-(void)addRightNaviItem
{
    self.baseRootVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排名" style:UIBarButtonItemStylePlain target:self action:@selector(rankingButtonClick:)];
}

// 设置标题菜单
-(void)addHeadViewTitle
{
    [self setTitleArray:@[@"综合",@"语文",@"数学",@"英语"]];
    
    [self setHeadViewCurrentIndex:self.currentIndex];
}

//添加雷达图右侧说明按钮
-(UIButton *)addInstructionBtn
{
    UIButton *titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    titleButton.frame= CGRectMake(WIDTH - 80, 3, 80, 30);
    titleButton.backgroundColor =[UIColor clearColor];
    [titleButton setTitle:@"说明" forState:UIControlStateNormal];
    [titleButton setTitleColor:JXColor(0x5c,0x5d,0x5d,1) forState:UIControlStateNormal];

    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton setTitleColor:[[UIColor blackColor]colorWithAlphaComponent:0.3] forState:UIControlStateSelected];
    [titleButton setImage:[UIImage imageNamed:@"instructions"] forState:UIControlStateNormal];
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20 , 0, 0);
    
    [titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return titleButton;

}

-(void)addScrollView{
    CGFloat frameHeight = self.view.frame.size.height - 64 - menuContentHeight;
    if ([self.baseRootVC isKindOfClass:[UITabBarController class]]) {
        frameHeight = frameHeight - ((UITabBarController *)self.baseRootVC).tabBar.frame.size.height;
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + menuContentHeight, WIDTH, frameHeight)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
//    [_scrollView setDelegate:self];
    [_scrollView setScrollsToTop:YES];
    [_scrollView setPagingEnabled:NO];
    _scrollView.bounces = NO;
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_scrollView];
    
    CGFloat height = 471.0f;
//    CGFloat height = 568.0f;
    if(frameHeight > height)
    {
        height = frameHeight;
    }
//    height = height - 64 - menuContentHeight;
//    if ([self.baseRootVC isKindOfClass:[UITabBarController class]]) {
//        height = height - ((UITabBarController *)self.baseRootVC).tabBar.frame.size.height;
//    }
    _scrollView.contentSize = CGSizeMake(WIDTH, height);
    
    [self.view addSubview:_scrollView];
}
// 添加雷达图
- (void)addRadarChart
{
 
    dataSource = [NSMutableArray array];
    titles = [NSMutableArray array];
    
    CGFloat height = 316;//self.view.frame.size.height - 64 - menuContentHeight - pieContentHeight - 3* spaceOfContentView;
//    if ([self.baseRootVC isKindOfClass:[UITabBarController class]]) {
//        height = height - ((UITabBarController *)self.baseRootVC).tabBar.frame.size.height;
//    }
    
//    UIView *radarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + menuContentHeight  + spaceOfContentView, self.view.frame.size.width, height)];
    
    UIView *radarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, height)];
    radarContentView.backgroundColor = [UIColor whiteColor];
    [radarContentView addSubview: [self addInstructionBtn]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon"]];
    [imageView setFrame:CGRectMake(8, 8, 19, 19)];
    imageView.image = [UIImage imageNamed:@"zhxlt"];
    [radarContentView addSubview:imageView];
    
    self.studyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 2, 150, 30)];
    self.studyLabel.textColor = JXColor(0x45,0x45,0x45,1);
    self.studyLabel.textAlignment = NSTextAlignmentCenter;
    self.studyLabel.font = [UIFont boldSystemFontOfSize:15];
    [radarContentView addSubview:self.studyLabel];
    
    
    _radarChartView = [[MCRadarChartView alloc] initWithFrame:CGRectMake(20, 35, [UIScreen mainScreen].bounds.size.width-40, height - 35)];
    _radarChartView.dataSource = self;
    
    _radarChartView.radius = 100;
    _radarChartView.pointRadius = 2;
    _radarChartView.strokeColor = [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:1.0];
    _radarChartView.fillColor = [UIColor colorWithRed:0/255.0 green:207/255.0 blue:187/255.0 alpha:0.2];
    [radarContentView addSubview:_radarChartView];
    [_scrollView addSubview:radarContentView];

}

// 添加学力图
- (void)addPieChartView {
    CGFloat height = 316 + 10*2;
//    CGFloat height = self.view.frame.size.height  - spaceOfContentView - pieContentHeight;
//    if ([self.baseRootVC isKindOfClass:[UITabBarController class]]) {
//        height = height - ((UITabBarController *)self.baseRootVC).tabBar.frame.size.height;
//    }
    
    
    UIView *chartContentView = [[UIView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, pieContentHeight)];
    chartContentView.backgroundColor = [UIColor whiteColor];

    CGFloat width = 80;
    CGFloat paddingOfPieChartView = (WIDTH - 3*80)/4;
    HKPieChartView *_pieChartView1 = [[HKPieChartView alloc]initWithFrame:CGRectMake(paddingOfPieChartView, 10, width, width)];
    [chartContentView addSubview:_pieChartView1];
    [_chartViewArray addObject:_pieChartView1];
                                
    UILabel *_nameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake( paddingOfPieChartView,  95, width, 20)];
    [_nameLabel1 setTextColor:JXColor(0x45,0x45,0x45,1)];
    [_nameLabel1 setFont:[UIFont boldSystemFontOfSize:13]];
    [_nameLabel1 setTextAlignment:NSTextAlignmentCenter];
    [chartContentView addSubview:_nameLabel1];
    [_chartViewLblArray addObject:_nameLabel1];
    
    HKPieChartView *_pieChartView2 = [[HKPieChartView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - width)/2, 10, width, width)];

    [chartContentView addSubview:_pieChartView2];
    [_chartViewArray addObject:_pieChartView2];
    
    UILabel *_nameLabel2 = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - width)/2,  95, width, 20)];
    [_nameLabel2 setTextColor:JXColor(0x45,0x45,0x45,1)];
    
    [_nameLabel2 setFont:[UIFont boldSystemFontOfSize:13]];
    [_nameLabel2 setTextAlignment:NSTextAlignmentCenter];
    [chartContentView addSubview:_nameLabel2];
    [_chartViewLblArray addObject:_nameLabel2];
    
    HKPieChartView *_pieChartView3 = [[HKPieChartView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - width - paddingOfPieChartView), 10, width, width)];

    [chartContentView addSubview:_pieChartView3];
    [_chartViewArray addObject:_pieChartView3];
    
    UILabel *_nameLabel3 = [[UILabel alloc] initWithFrame:CGRectMake( (self.view.frame.size.width - width - paddingOfPieChartView),  95, width, 20)];
    [_nameLabel3 setTextColor:JXColor(0x45,0x45,0x45,1)];
    [_nameLabel3 setFont:[UIFont boldSystemFontOfSize:13]];
    [_nameLabel3 setTextAlignment:NSTextAlignmentCenter];
    [chartContentView addSubview:_nameLabel3];
    [_chartViewLblArray addObject:_nameLabel3];
    
    [_scrollView addSubview: chartContentView];
}
#pragma mark -- 私有方法
//按钮点击 传入代理
-(void)buttonClick:(UIButton*)button
{
    ResourceInstructionVC *instructionVC = [[ResourceInstructionVC alloc] init];

    NSString *childId = [UserCenter sharedInstance].curChild.uid;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:childId forKey:@"child_id"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://uc.edugate.cn/evaluating.manage/mobileStudyExplain.htm?uid=%@&subject_code=%ld",childId,(long)self.currentTabIndex];
//    TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] init];
    NSString *url = [NSString appendUrl:urlString withParams:nil];
    [instructionVC setUrl:[NSURL URLWithString:url]];
    [instructionVC setTitle:@"说明"];
    
    [CurrentROOTNavigationVC pushViewController:instructionVC animated:YES];
}

-(void)rankingButtonClick:(UIButton*)button
{
   
    if(self.analysisModel.modelItemArray.count <= self.currentTabIndex)
        return;
    // 获取当前学力图的数据
    SubjectItem *subItem = [self.analysisModel.modelItemArray objectAtIndex:self.currentTabIndex];
    
    if(subItem.hasRank == 0){
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        hud.labelText = @"您还未答题，赶快去闯关吧！";
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // YES代表需要蒙版效果
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeText;

        [hud hide:YES afterDelay:2];
        
//        [hud showAnimated:YES whileExecutingBlock:^{
//            
//            sleep(2);
//        }completionBlock:^{
//            [(ResourceMainVC*)self.baseRootVC selectAtIndex:1];
//            [hud removeFromSuperview];
//        }];
        
        return;
    }
    
    RankingVC *rankingVC = [[RankingVC alloc] init];
    
    [CurrentROOTNavigationVC pushViewController:rankingVC animated:YES];
}



#pragma mark -- delegate for chart
- (NSInteger)numberOfValueInRadarChartView:(MCRadarChartView *)radarChartView {
    return titles.count;
}

- (id)radarChartView:(MCRadarChartView *)radarChartView valueAtIndex:(NSInteger)index {
 
    NSNumber *percentNumber = [NSNumber numberWithFloat: [dataSource[index] floatValue] / 100];
    return percentNumber;
}

- (NSString *)radarChartView:(MCRadarChartView *)radarChartView titleAtIndex:(NSInteger)index {
    return titles[index];
}

- (NSAttributedString *)radarChartView:(MCRadarChartView *)radarChartView attributedTitleAtIndex:(NSInteger)index {
//    @[@"语文\n (75)",@"数学\n (85)",@"英语\n (80)"]
    NSString *string = [NSString stringWithFormat:@"%@ \n (",titles[index]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSUInteger length = [string length];
    
    UIFont *sysFont = [UIFont systemFontOfSize:16.0]; //设置所有的字体
    // 设置颜色
    UIColor *color = JXColor(0x8c,0x8c,0x8c,1);
    
    [attrString addAttribute:NSFontAttributeName value:sysFont
                       range:NSMakeRange(0, length)];//设置T字体
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:NSMakeRange(0, length)];
    

    NSString *scoreString = [NSString stringWithFormat:@"%@",dataSource[index]];
    NSMutableAttributedString *addAttrString1 = [[NSMutableAttributedString alloc] initWithString:scoreString];
    [addAttrString1 addAttribute:NSFontAttributeName value:sysFont
                           range:NSMakeRange(0, scoreString.length)];//设置T字体
    UIColor *bluecolor = JXColor(0x84,0xb1,0xfa,1);
    [addAttrString1 addAttribute:NSForegroundColorAttributeName
                       value:bluecolor
                       range:NSMakeRange(0, scoreString.length)];
    
    [attrString appendAttributedString:addAttrString1];
    
    
    NSMutableAttributedString *addAttrString2 = [[NSMutableAttributedString alloc] initWithString:@")"];
    [addAttrString2 addAttribute:NSFontAttributeName value:sysFont
                          range:NSMakeRange(0, 1)];//设置T字体
    [addAttrString2 addAttribute:NSForegroundColorAttributeName
                           value:color
                           range:NSMakeRange(0, 1)];

    [attrString appendAttributedString:addAttrString2];
    
    
    return attrString;

}


#pragma mark -- headLineDelegate

- (void)refreshHeadLine:(NSInteger)currentIndex
{
   self.currentTabIndex = currentIndex;
   [[NSUserDefaults standardUserDefaults] setInteger:self.currentTabIndex forKey:@"AcademicAnalysisTabIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   [self updateData:currentIndex];
}


#pragma mark -- 更新数据
-(void) updatePieChartView:(HKPieChartView *)view  Level:(ScoreItem *)score
{
    
    LZStudyLevel level = [ScoreItem getStudyLevel:[score.score floatValue]];
    [view updateTrackColor:TrackBgColor];

    switch (level) {
        case LZStudyLevelPerfect:
            
            [view setChartColor:studyDic[@"学霸"] LabelString:@"学霸"];
            break;
        case LZStudyLevelExcellent:
            [view setChartColor:studyDic[@"高手"] LabelString:@"高手"];
            break;
        case LZStudyLevelHigh:
            [view setChartColor:studyDic[@"优秀"] LabelString:@"优秀"];
            break;
        case LZStudyLevelNormal:
            [view setChartColor:studyDic[@"中等"] LabelString:@"中等"];
            break;
        default:
            [view setChartColor:studyDic[@"普通"] LabelString:@"普通"];
            break;
    }
    
    [view updatePercent:score.score animation:NO];
}


// 更新学力图数据
-(void) updatePieChartView:(NSArray*)scoreArray
{
    int index = 0;
    for(ScoreItem *item in scoreArray){
     
        if(index < 3)
        {
            HKPieChartView *view = [self.chartViewArray objectAtIndex:index];
            UILabel *label = [self.chartViewLblArray objectAtIndex:index];
            label.text = item.name;
            [self updatePieChartView:view Level:item];
        }
        index ++;
    }
    
}

-(void) updateData:(NSInteger)index
{
    
    if(self.analysisModel.modelItemArray.count <= index)
        return;
    // 获取当前学力图的数据
    SubjectItem *subItem = [self.analysisModel.modelItemArray objectAtIndex:index];
    
    if(subItem.hasRank == 0){
        [self  showEmptyView:YES];
        return;
    }
    else
    {
        [self  showEmptyView:NO];
    }
    
    // 顶部学力图标签字段 的更新
    NSUInteger average = subItem.average;
    
    self.studyLabel.text = [NSString stringWithFormat:@"%@学力图（%lu）",subItem.name,average];
    
    // 战力图的更新
    [self updatePieChartView:subItem.rankList.modelItemArray];

    [dataSource removeAllObjects];
    [titles removeAllObjects];
    
    if(!subItem.skills.modelItemArray  || subItem.skills.modelItemArray.count ==0)
    {
        [self showEmptyLabel:YES];
    }
    else
    {
        for(ScoreItem *sItem in subItem.skills.modelItemArray)
        {
            [dataSource addObject:[NSNumber numberWithString:sItem.score]];
            [titles addObject:sItem.name];
        }
        
        [_radarChartView reloadDataWithAnimate:YES];
    }

}

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return @"academicAnalysisVC";
}

- (void)loadCache
{
    if([self supportCache])//支持缓存，先出缓存中读取数据
    {
        NSData *data = [NSData dataWithContentsOfFile:[self cacheFilePath]];
        if(data.length > 0){
            self.analysisModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self  updateData:self.currentTabIndex];
        }
    }
}

- (void)saveCache{
    if([self supportCache])
    {
        NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:self.analysisModel];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success = [modelData writeToFile:[self cacheFilePath] atomically:YES];
            if(success)
                DLOG(@"save success");
        });
    }
    
}

#pragma mark -- 获取数据
// 获取学力相关数据
- (void)getAnalysis
{
    
//    NSString *childId = [UserCenter sharedInstance].curChild.uid;
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setValue:childId forKey:@"child_id"];
//    
//    NSString *class_id =  ((ResourceMainVC *)self.baseRootVC).classInfo.classID;
//    [params setValue:class_id forKey:@"class_id"];
//    
//    NSString *school_id =  ((ResourceMainVC *)self.baseRootVC).classInfo.school.schoolID;
//    [params setValue:school_id forKey:@"school_id"];
    
    NSMutableDictionary *params =  [[ParamUtil sharedInstance] getParam];
    __weak typeof(self) wself = self;

    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"evaluation/getAnalysis" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
    
        if(responseObject){
            TNDataWrapper *childWrapper = [responseObject getDataWrapperForKey:@"list"];

            [wself.analysisModel parseData:childWrapper type:REQUEST_REFRESH];

            [wself  updateData:wself.currentTabIndex];
            
            [wself saveCache];
        }
  
    } fail:^(NSString *errMsg) {
        // 网络不给力的时候读取缓存
        [wself loadCache];
    }];
    
}

- (void)showEmptyView:(BOOL)show
{
    if([self.emptydataView superview] == nil){
        [self.view addSubview:self.emptydataView];
    }
    [self.view bringSubviewToFront:self.emptydataView];
    
    [self.emptydataView setHidden:!show];
    
}


@end
