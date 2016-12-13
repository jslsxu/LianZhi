//
//  RankingVC.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "RankingVC.h"
#import "HeadImageView.h"
#import "LZPullDownMenu.h"
#import "ResourceDefine.h"
#import "MXParallaxHeader.h"
#import "MXScrollView.h"
#import "LZSubjectModel.h"
#import "AcademicAnalysisVC.h"
#import "ResourceMainVC.h"
#import "UINavigationBar+BackgroundColor.h"
#import "ParamUtil.h"
@implementation RankingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 49, 45)];
        [_idLabel setTextColor:OrangeColor];
        [_idLabel setFont:[UIFont systemFontOfSize:18]];
        [_idLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:_idLabel];
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 7, 50, 50)];
        [_headerImageView setClipsToBounds:YES];
        [_headerImageView  setContentMode:UIViewContentModeScaleAspectFill];
     
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
   
        [_headerImageView.layer setCornerRadius:_headerImageView.frame.size.width/2];
        [_headerImageView.layer setMasksToBounds:YES];
        
        [self addSubview:_headerImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 10, WIDTH - 112.f - 65.0f, 25)];
        [_nameLabel setTextColor:GrayLblColor];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
        
        // 渐变进度条
        _processView = [[LZGradientProcessView alloc] initWithFrame:CGRectMake(112, 38.f, WIDTH - 112.f - 70.0f, 10.f)];
        
        [self addSubview:_processView];
        
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 65, 10, 65, 45)];
        [_levelLabel setTextColor:OrangeColor];
        [_levelLabel setFont:[UIFont systemFontOfSize:22]];
        [_levelLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_levelLabel];
        
//        _unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 20, 15, 20, 40)];
//        [_unitLabel setTextColor:OrangeColor];
//        [_unitLabel setFont:[UIFont systemFontOfSize:16]];
//        [_unitLabel setTextAlignment:NSTextAlignmentLeft];
//        _unitLabel.text = @"%";
//        [self addSubview:_unitLabel];

    }
    return self;
}

- (void)setRankingItem:(RankingItem *)rankingItem
{
    _rankingItem = rankingItem;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:rankingItem.head] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
  
    [_idLabel setText:[NSString stringWithFormat:@"%d",rankingItem.rank]];
    [_nameLabel setText:rankingItem.name];
    [_levelLabel setText:rankingItem.score];
    
//    NSUInteger rank = self.total - rankingItem.rank;
    _processView.percent = [rankingItem.score floatValue]; //  (rank * 100)/ self.total;
}

- (void)setStyle:(BOOL)isTop
{
    if (!isTop) {
        [_levelLabel setTextColor:GreenLineColor];
        [_idLabel setTextColor:LightGrayLblColor];
        [_unitLabel setTextColor:GreenLineColor];
        self.backgroundColor = WhiteColor;
    } else {
        [_levelLabel setTextColor:OrangeColor];
        [_idLabel setTextColor:OrangeColor];
        [_unitLabel setTextColor:OrangeColor];
        self.backgroundColor = JXColor(0xd6, 0xf4, 0xec, 1);
    }
}
@end

@interface RankingVC ()<MXScrollViewDelegate,
UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    //头像
    UIImageView *_headerImg;
    NSInteger  subjectcodeIndex;
    NSString * skillcodeIndex;
    NSInteger  ranktypeIndex;

}

@property(nonatomic,strong)LZPullDownMenu *menu ;       //下拉视图
@property(nonatomic,strong)HeadImageView *headImageView;//滚动视图上部的头视图
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITableView *tableView;       //表视图
@property(nonatomic,strong)MXScrollView *scrollView;    //滚动视图
@property(nonatomic,strong)RankingModel *rankingmodel;
@property(nonatomic,strong)LZSubjectList *subjectModelList;
@property(nonatomic,strong)NSMutableArray *skillArray;
@end

@implementation RankingVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化数据源
    [self setupData];

    //创建TableView
    [self createTableView];
    
    //设置TableView的头部View，一定要放在TableView初始化之后
    [self setupHeaderView];
    
    // 获取排名数据
    [self getRankingList];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *bgView = [[UIView alloc]init];
    
    // 改变导航条背景色与Top 头的背景同色
    // 改变barTintColor 的话导航条最下面会有黑色线，需要去除
    bgView.frame = CGRectMake(0 , -20, WIDTH , self.navigationController.navigationBar.frame.size.height + 20);
    bgView.backgroundColor = GreenLineColor;
    [CurrentROOTNavigationVC.navigationBar setValue:bgView  forKey:@"backgroundView"];
//    [CurrentROOTNavigationVC.navigationBar lt_setBackgroundColor:GreenLineColor];
    //导航条上面字为白色
    [CurrentROOTNavigationVC.navigationBar setTintColor:WhiteColor];
    [CurrentROOTNavigationVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WhiteColor,NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
//    UIView *addStatusBar = [[UIView alloc] init];
//    addStatusBar.frame = CGRectMake(0, 0, WIDTH, 20);
//    addStatusBar.tag = 2100;
//    addStatusBar.backgroundColor = GreenLineColor; //You can give your own color pattern
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    [keyWindow.rootViewController.view addSubview:addStatusBar];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 恢复导航条背景色
    [CurrentROOTNavigationVC.navigationBar setValue:nil  forKey:@"backgroundView"];
//    [CurrentROOTNavigationVC.navigationBar lt_setBackgroundColor:BgGrayColor];
//    [CurrentROOTNavigationVC.navigationBar.o
     //恢复导航条上面字为灰色
    [CurrentROOTNavigationVC.navigationBar setTintColor:[UIColor colorWithHexString:@"525252"]];
    [CurrentROOTNavigationVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"525252"],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    CurrentROOTNavigationVC.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    [[keyWindow.rootViewController.view  viewWithTag:2100] removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 初始化各个控件
//创建数据源
-(void)setupData{
    self.title = @"排名";
    self.view.backgroundColor = JXColor(0xf7,0xf7,0xf9,1);
    _rankingmodel = [[RankingModel alloc]init];
    
    // 下拉列表数据的初始化
    _skillArray = [NSMutableArray array];
    self.subjectModelList = [[LZSubjectList alloc]init];
 
    // 获取下拉列表的缓存 默认获取的是语文维度数据
    [self loadCache:0];
}



//创建TableView
-(void)createTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.tag = 2001;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    
    
    [self.view addSubview:self.scrollView];
   
    
    self.scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64);
    self.scrollView.contentSize = self.scrollView.frame.size;
    
    // 设置scrollView 顶部的头视图
    self.scrollView.parallaxHeader.view = self.headImageView;
    self.scrollView.parallaxHeader.height = 181;
    self.scrollView.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.scrollView.parallaxHeader.minimumHeight = 0;
    
     [self.scrollView addSubview:self.tableView];

}

// 设置scrollView
- (MXScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[MXScrollView alloc] init];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

//头视图
-(HeadImageView *)headImageView{
    if (!_headImageView) {
        _headImageView= [NSBundle.mainBundle loadNibNamed:@"HeadImageView" owner:self options:nil].firstObject;
 
        _headImageView.backgroundColor=[UIColor clearColor];
//
//        [self updateHeaderView];
        
    }
    return _headImageView;
}

// 头部视图的数据刷新
-(void)setupHeaderView
{
   
    _headImageView.imageFirstView.image = [UIImage imageNamed:@"defaultHeader"];
    _headImageView.nameFirstLbl.text = @"暂无";
    _headImageView.contentFirstLbl.text = @"";
    
    _headImageView.imageSecondView.image =[UIImage imageNamed:@"defaultHeader"];
    
    _headImageView.nameSecondLbl.text = @"暂无";
    _headImageView.contentSecondLbl.text = @"";
    
    _headImageView.imageThirdView.image =[UIImage imageNamed:@"defaultHeader"];

    _headImageView.nameThirdLbl.text = @"暂无";
    _headImageView.contentThirdLbl.text = @"";
}

// 添加下拉菜单
- (UIView *)addPullDownMenu{
    [super viewDidLoad];
    
    if(!self.menu){
        self.menu = [[LZPullDownMenu alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, 44) menuTitleArray:@[@"全科",@"能力",@"班级"]];
        
        NSArray *regionArray =@[@"全科",@"语文",@"数学",@"英语"];
        
        if(_skillArray.count == 0)
           [_skillArray addObject:@"能力"];
        
        NSArray *sortRuleArray=@[@"班级",@"学校",@"平台"];
        
        self.menu.menuDataArray = [NSMutableArray arrayWithObjects:regionArray, _skillArray , sortRuleArray, nil];
        
        [self.view addSubview:self.menu];
        
        __weak typeof(self) wself = self;
        [self.menu setHandleSelectDataBlock:^(NSString *selectTitle, NSUInteger selectIndex, NSUInteger selectButtonTag) {
            if(selectButtonTag == 0){
                [wself loadCache:selectIndex];
                subjectcodeIndex =  selectIndex;
                
                skillcodeIndex = nil;
                //按下第一列的选项，需要重置第二列选项
                [wself.menu resetMiddleButtonTitle];
            }
            else if(selectButtonTag == 1)
            {
                SkillItem *skillItem = nil;
                skillcodeIndex = nil;
                
                if(subjectcodeIndex == 1)
                {
                    if(self.subjectModelList.chineseModel.skills.modelItemArray.count >
                       selectIndex -1){
                    skillItem = [self.subjectModelList.chineseModel.skills.modelItemArray
                                 objectAtIndex:selectIndex -1];
                    }
                }
                else if(subjectcodeIndex == 2)
                {
                    if(self.subjectModelList.mathModel.skills.modelItemArray.count >
                       selectIndex -1){
                    skillItem = [self.subjectModelList.mathModel.skills.modelItemArray
                                 objectAtIndex:selectIndex -1];
                    }
                }
                else if(subjectcodeIndex == 3)
                {
                    if(self.subjectModelList.englishModel.skills.modelItemArray.count >
                       selectIndex -1){
                    skillItem = [self.subjectModelList.englishModel.skills.modelItemArray
                                 objectAtIndex:selectIndex -1];
                    }
                }
                
                if(skillItem)
                    skillcodeIndex = skillItem.skill_code;
            }
            else
            {
                ranktypeIndex = selectIndex;
            }
        }];
        
        // 点击下拉菜单蒙版后的关闭处理
        [self.menu setCloseViewBlock:^( ) {
            wself.titleLabel.hidden = NO;
            [wself getRankingList];
        }];
        
        // 点击下拉菜单菜单选项处理
        [self.menu setHandleTitleSelectDataBlock:^(NSInteger index) {
            wself.titleLabel.hidden = YES;
            //        wself.tableView.userInteractionEnabled = NO;
            if(wself.scrollView.contentOffset.y < 161){
                [wself.scrollView setContentOffset:CGPointMake(0, 161) animated:YES];
                wself.scrollView.bouncesZoom = NO;
            }
            
        }];
    }
    
    return  self.menu;
    
}


// 头部视图的数据刷新
-(void)updateHeaderView
{
    RankingItem *firstItem = self.rankingmodel.topThree.modelItemArray.count > 0? [self.rankingmodel.topThree.modelItemArray firstObject]:nil;
    
    RankingItem *secondItem = self.rankingmodel.topThree.modelItemArray.count > 1? [self.rankingmodel.topThree.modelItemArray objectAtIndex:1]:nil;
    
    RankingItem *thirdItem = self.rankingmodel.topThree.modelItemArray.count > 2? [self.rankingmodel.topThree.modelItemArray objectAtIndex:2]:nil;
    
    [_headImageView.imageFirstView sd_setImageWithURL:[NSURL URLWithString:firstItem.head] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    _headImageView.nameFirstLbl.text = (firstItem == nil) ?@"暂无":firstItem.name;
    _headImageView.contentFirstLbl.text = (firstItem == nil) ?@"":firstItem.score;
    
    
    
    [_headImageView.imageSecondView sd_setImageWithURL:[NSURL URLWithString:secondItem.head] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    
    _headImageView.nameSecondLbl.text = (secondItem == nil) ?@"暂无":secondItem.name;
    _headImageView.contentSecondLbl.text = (secondItem == nil) ?@"":secondItem.score;
    
    [_headImageView.imageThirdView sd_setImageWithURL:[NSURL URLWithString:thirdItem.head] placeholderImage:[UIImage imageNamed:@"defaultHeader"]];
    
    _headImageView.nameThirdLbl.text = (thirdItem == nil) ?@"暂无":thirdItem.name;
    _headImageView.contentThirdLbl.text = (thirdItem == nil) ?@"":thirdItem.score;
    
    _headImageView.imageFirstView.layer.masksToBounds=YES;
    _headImageView.imageFirstView.layer.cornerRadius= _headImageView.imageFirstView.frame.size.width/2;
    _headImageView.imageFirstView.layer.borderWidth = 4;
    _headImageView.imageFirstView.layer.borderColor = JXColor(0x04,0xae,0x81,1).CGColor;
    
    _headImageView.imageSecondView.layer.masksToBounds=YES;
    _headImageView.imageSecondView.layer.cornerRadius= _headImageView.imageSecondView.frame.size.width/2;
    _headImageView.imageSecondView.layer.borderWidth = 4;
    _headImageView.imageSecondView.layer.borderColor = JXColor(0x04,0xae,0x81,1).CGColor;
    
    
    _headImageView.imageThirdView.layer.masksToBounds=YES;
    _headImageView.imageThirdView.layer.cornerRadius= _headImageView.imageThirdView.frame.size.width/2;
    _headImageView.imageThirdView.layer.borderWidth = 4;
    _headImageView.imageThirdView.layer.borderColor = JXColor(0x04,0xae,0x81,1).CGColor;
}


#pragma mark ---- UITableViewDelegate ----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 44;
    else
        return 23;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 0;
    else
        return self.rankingmodel.rankList.modelItemArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        UIView *pulldownView = [self addPullDownMenu];
        return pulldownView;
    }
    else if(section == 1)
    {

        if (!_titleLabel) {
            _titleLabel=[[UILabel alloc]init];
            _titleLabel.frame=CGRectMake(0, 0, WIDTH, 23);
            _titleLabel.backgroundColor = JXColor(0xf7, 0xf7, 0xf9, 1);
            [_titleLabel setTextColor:GrayLblColor];
            [_titleLabel setFont:[UIFont systemFontOfSize:12]];
            [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        }

        return _titleLabel;
    }
    
    return nil;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"RankingCell";
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(nil == cell)
    {
        cell = [[RankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    RankingItem *item = [self.rankingmodel.rankList.modelItemArray objectAtIndex:indexPath.row];
    cell.total = [self.rankingmodel.total floatValue];
    [cell setRankingItem:item];
    
    if(indexPath.row == 0)
    {
        if(self.rankingmodel.isTop == 0)
            [cell setStyle:YES];
        else
            [cell setStyle:NO];
    }else
    {
        [cell setStyle:NO];
    }
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell被点击恢复
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}





#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"progress %f", - self.scrollView.parallaxHeader.progress);

    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1 +  self.scrollView.parallaxHeader.progress];
    
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    UIView *barView = [keyWindow.rootViewController.view  viewWithTag:2100];
//    [barView setAlpha:1 +  self.scrollView.parallaxHeader.progress];
    
    if(-  self.scrollView.parallaxHeader.progress > 0.5){
        [CurrentROOTNavigationVC.navigationBar setTintColor:JXColor(0x52, 0x52, 0x52, -  self.scrollView.parallaxHeader.progress)];
        

        [CurrentROOTNavigationVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:JXColor(0x52, 0x52, 0x52, - self.scrollView.parallaxHeader.progress),NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    }
    else
    {
        [CurrentROOTNavigationVC.navigationBar setTintColor:WhiteColor];
        [CurrentROOTNavigationVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WhiteColor,NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    }

}


#pragma mark -- 获取数据
- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];

    [task setRequestUrl:@"evaluation/getRankList"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    return task;
}

#pragma mark -- 获取数据
- (NSString *)cacheFileName
{
    return @"SkillsBySubject";
}

- (BOOL)supportCache
{
    return YES;
}

- (void)loadCache:(NSInteger)index
{
    if([self supportCache])//支持缓存，先出缓存中读取数据
    {
        NSData *data = [NSData dataWithContentsOfFile:[self cacheFilePath]];
        if(data.length > 0){
            self.subjectModelList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
             [_skillArray removeAllObjects];
            
            if(!self.subjectModelList){
                self.subjectModelList = [[LZSubjectList alloc]init];
            }

            
            if(index == 0)
            {
                [_skillArray insertObject:@"能力" atIndex:0];
                if(self.menu.menuDataArray.count > 1){
                    [self.menu.menuDataArray replaceObjectAtIndex:1 withObject:_skillArray];
                }
                
            }
            else if(index == 1)
            {
                if(!self.subjectModelList.chineseModel ||
                   self.subjectModelList.chineseModel.skills.modelItemArray.count <= 1 )
                {
                    [self getSkillsBySubject:1];
                }
                else
                {
    
                    for(SkillItem *item in self.subjectModelList.chineseModel.skills.modelItemArray)
                    {
                        [_skillArray addObject:item.skill_name];
                    }
                     [_skillArray insertObject:@"能力" atIndex:0];
                    if(self.menu.menuDataArray.count > 1){
                        [self.menu.menuDataArray replaceObjectAtIndex:1 withObject:_skillArray];
                    }
                }
            }
            else if(index == 2)
            {
                if(!self.subjectModelList.mathModel ||
                   self.subjectModelList.mathModel.skills.modelItemArray.count <= 1 )                {
                    [self getSkillsBySubject:2];
                }
                else
                {

                    for(SkillItem *item in self.subjectModelList.mathModel.skills.modelItemArray)
                    {
                        [_skillArray addObject:item.skill_name];
                    }
                     [_skillArray insertObject:@"能力" atIndex:0];
                    if(self.menu.menuDataArray.count > 1){
                        [self.menu.menuDataArray replaceObjectAtIndex:1 withObject:_skillArray];
                    }
                }
                    
            }
            else
            {
                if(!self.subjectModelList.englishModel ||
                   self.subjectModelList.englishModel.skills.modelItemArray.count <= 1 )                {
                    [self getSkillsBySubject:3];
                }
                else
                {

                    for(SkillItem *item in self.subjectModelList.englishModel.skills.modelItemArray)
                    {
                        [_skillArray addObject:item.skill_name];
                    }
                    
                     [_skillArray insertObject:@"能力" atIndex:0];
                    if(self.menu.menuDataArray.count > 1){
                        [self.menu.menuDataArray replaceObjectAtIndex:1 withObject:_skillArray];
                    }

                }
            }
        }
        else{
            [self getSkillsBySubject:1];
        }
    }
}

- (void)saveCache{
    if([self supportCache])
    {
        NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:self.subjectModelList];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success = [modelData writeToFile:[self cacheFilePath] atomically:YES];
            if(success)
                DLOG(@"save success");
        });
    }
    
}

// 获取学力相关数据
- (void)getRankingList
{
//    ResourceMainVC *mainVC = nil;
//
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[ResourceMainVC class]]) {
//            mainVC  = (ResourceMainVC *)temp;
//            break;
//        }
//    }
//
//    NSString *childId = [UserCenter sharedInstance].curChild.uid;
//    NSString *class_id =  mainVC.classInfo.classID;
//    NSString *school_id =  mainVC.classInfo.school.schoolID;
    NSMutableDictionary *params =  [[ParamUtil sharedInstance] getParam];
//    subjectcodeIndex =  subjectcodeIndex;  //subjectcodeIndex == 0? 1 :
    NSString *subject_code =  [NSString stringWithFormat:@"%lu",(unsigned long)subjectcodeIndex];
    NSString *rank_type =  [NSString stringWithFormat:@"%lu",(unsigned long)ranktypeIndex + 1];
    
    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setValue:childId forKey:@"child_id"];   //当前孩子id
//    [params setValue:class_id forKey:@"class_id"];  //当前班级id
//    [params setValue:school_id forKey:@"school_id"];  //当前学校id
    
    skillcodeIndex = skillcodeIndex == nil?@"0":skillcodeIndex;
    [params setValue:skillcodeIndex forKey:@"skill_code"];  //技能ID
    [params setValue:subject_code forKey:@"subject_code"];  //科目编码
    [params setValue:rank_type forKey:@"rank_type"];  //排名类型 1 班级排名 2 校内排名 3 平台排名
  
    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在获取信息" toView:self.view];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"evaluation/getRankList" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        
        if(responseObject){
            [wself.rankingmodel parseData:responseObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong RankingVC *sself = wself;
                sself.titleLabel.text = [NSString stringWithFormat:@" 共%@人",sself.rankingmodel.total];
                [sself.tableView reloadData];
                
                [sself updateHeaderView];
            });
            
        }
       
        [hud hide:YES];
        
    } fail:^(NSString *errMsg) {
        [hud hide:YES];
        [ProgressHUD showHintText:errMsg];
    }];
    
}

// 获取下拉列表相关数据
- (void)getSkillsBySubject:(NSUInteger)subject_code
{
    
    if(subject_code > 3)
        return;
    
    NSString *subjectCodeString = [NSString stringWithFormat:@"%lu",(unsigned long)subject_code];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:subjectCodeString forKey:@"subject_code"];
    
    __weak typeof(self) wself = self;
   
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"evaluation/getSkillsBySubject" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        
        [_skillArray removeAllObjects];
        
        if(subject_code == 1)
        {
            if(!wself.subjectModelList.chineseModel)
                wself.subjectModelList.chineseModel = [[LZSubjectModel alloc]init];
            
             [wself.subjectModelList.chineseModel parseData:responseObject type:REQUEST_REFRESH];
            
            for(SkillItem *item in wself.subjectModelList.chineseModel.skills.modelItemArray)
            {
                [_skillArray addObject:item.skill_name];
            }
        }
        else if(subject_code == 2)
        {
            if(!wself.subjectModelList.mathModel)
                wself.subjectModelList.mathModel = [[LZSubjectModel alloc]init];
            
            [wself.subjectModelList.mathModel parseData:responseObject type:REQUEST_REFRESH];
      
            for(SkillItem *item in wself.subjectModelList.mathModel.skills.modelItemArray)
            {
                [_skillArray addObject:item.skill_name];
            }
        }
        else
        {
            if(!wself.subjectModelList.englishModel)
                wself.subjectModelList.englishModel = [[LZSubjectModel alloc]init];
            
            [wself.subjectModelList.englishModel parseData:responseObject type:REQUEST_REFRESH];
 
            for(SkillItem *item in wself.subjectModelList.englishModel.skills.modelItemArray)
            {
                [_skillArray addObject:item.skill_name];
            }
         
        }

        [_skillArray insertObject:@"能力" atIndex:0];
        [wself saveCache];
        
        if(wself.menu.menuDataArray.count > 1){
            [wself.menu.menuDataArray replaceObjectAtIndex:1 withObject:_skillArray];
            [wself.menu tableViewReloadData];
        }

        
    } fail:^(NSString *errMsg) {
//        [hud hide:YES];
        [ProgressHUD showHintText:errMsg];
    }];
    
}

@end
