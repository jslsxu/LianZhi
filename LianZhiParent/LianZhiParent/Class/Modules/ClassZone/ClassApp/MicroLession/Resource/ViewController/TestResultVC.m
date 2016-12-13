//
//  TestResultVC.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/9.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TestResultVC.h"
#import "ResultHeaderView.h"
#import "LZTestModel.h"
#import "LZQuestionsModel.h"

#import "MXScrollView.h"
#import "ResultCollctionHeaderView.h"
#import "TestBaseVC.h"
#import "ResourceMainVC.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#define kFooterViewHeight  54

@implementation CourseResultItem


- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.courseID = [dataWrapper getStringForKey:@"course_id"];
    self.courseName = [dataWrapper getStringForKey:@"course_name"];

}

@end

@implementation CourseResultListModel

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    return YES;
}

@end

@implementation CourseResultCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
       
        [self.layer setMasksToBounds:YES];
        
        resultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [resultLabel setTextAlignment:NSTextAlignmentCenter];
        [resultLabel setFont:[UIFont systemFontOfSize:22]];
       
        [resultLabel.layer setCornerRadius:(self.width - 20 )/2];
        [resultLabel.layer setMasksToBounds:YES];
        [resultLabel setFrame:CGRectMake(10, 10, self.width - 20 , self.width - 20 )];
        
        [self addSubview:resultLabel];
    }
    return self;
}

- (void)setSubItem:(TNModelItem *)modelItem
{
//    CourseResultItem *courseItem = (CourseResultItem *)modelItem;
    TestItem  *testItem = (TestItem *)modelItem;
    resultLabel.text = [NSString stringWithFormat:@"%ld",(long)testItem.index];
    
    if(testItem.praxis.modelItemArray.count >0 &&  testItem.praxis.modelItemArray.count == 1)
    {
        TestSubItem *subItem = [testItem.praxis.modelItemArray firstObject];
        subItem.status = LZTestUnknown;
    
        if(subItem.is_correct == nil || [subItem.is_correct isEqualToString:@""])
            subItem.status = subItem.status | LZTestNoAnswer;
        else
        {
            if([subItem.is_correct isEqualToString:@"0"])
            {
                subItem.status = subItem.status | LZTestCorrect;
            }
            else
            {
                subItem.status = subItem.status | LZTestWrong;
            }
        }
        
        [self setLabelStyle:subItem.status];
    }
    else
    {
        LZTestStatus status = LZTestUnknown;
        for(TestSubItem *subItem in testItem.praxis.modelItemArray)
        {
            if(subItem.is_correct == nil || [subItem.is_correct isEqualToString:@""]){
                status = status | LZTestNoAnswer;
            }
            else if([subItem.is_correct isEqualToString:@"0"])
            {
                status = status | LZTestCorrect;
            }
            else
            {
                status = status | LZTestWrong;
                break;
            }
            
        }
        
         [self setLabelStyle:status];
    }

}

-(void) setLabelStyle:(LZTestStatus)status
{
    switch (status) {
        case LZTestCorrect:
            [resultLabel setBackgroundColor:GreenResultInstructionColor];
            [resultLabel setTextColor:WhiteColor];
            resultLabel.layer.borderColor = ClearColor.CGColor;
            break;
        case LZTestNoAnswer:
            [resultLabel setBackgroundColor:ClearColor];
            resultLabel.layer.borderWidth = 1;
            resultLabel.layer.borderColor = GreenLblColor.CGColor;
            [resultLabel setTextColor:GreenLblColor];
            break;
        default:
        {
            [resultLabel setBackgroundColor:RedResultColor];
            [resultLabel setTextColor:WhiteColor];
            resultLabel.layer.borderColor = ClearColor.CGColor;
        }
            break;
    }
}
//交卷按钮点击 传入代理
-(void)questionButtonClick:(UIButton*)button
{
    if([self.selectDelegate respondsToSelector:@selector(answerViewSelected:)])
        [self.selectDelegate answerViewSelected:self.item];

}


@end


//测试结果页面
@interface TestResultVC ()<MXScrollViewDelegate>
{
    UIView *footerView;
}
@property (nonatomic, strong) MXScrollView *scrollView;

@end

@implementation TestResultVC
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.cellName = @"CourseResultCell";
        self.modelName = @"LZTestModel";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //  添加集合视图
    [self addCollectionView];
    
    //  添加学力图
    [self addFooterView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//变换导航条的底色
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0 , -20, WIDTH , self.navigationController.navigationBar.frame.size.height + 20);
    bgView.backgroundColor = GreenLineColor;

    [CurrentROOTNavigationVC.navigationBar setValue:bgView  forKey:@"backgroundView"];
    
    [CurrentROOTNavigationVC.navigationBar setTintColor:WhiteColor];
    [CurrentROOTNavigationVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WhiteColor,NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    //  添加排名右侧导航按钮
//    [self addRightNaviItem];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.fd_interactivePopDisabled = YES;
}


//回复导航条的底色
-(void)viewWillDisappear:(BOOL)animated{
 
    [super viewWillDisappear:animated];
    
    // 恢复导航条背景色
    [CurrentROOTNavigationVC.navigationBar setValue:nil  forKey:@"backgroundView"];
    [CurrentROOTNavigationVC.navigationBar setTintColor:[UIColor colorWithHexString:@"525252"]];
    [CurrentROOTNavigationVC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:
                                                                          [UIColor colorWithHexString:@"525252"],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    self.fd_interactivePopDisabled = NO;

    CurrentROOTNavigationVC.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    
}

//添加排名右侧导航按钮
//-(void)addRightNaviItem
//{
//    CurrentROOTNavigationVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一关" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextButtonClick:)];
//}

#pragma mark -- 初始化方法
// Override 右侧导航按钮 的按下事件
// 返回到闯关训练的下一关主画面
//- (void)nextTextButtonClick:(UIButton*)button{
//    
//}


// Override 左侧导航按钮 的按下事件
// 返回到闯关训练的主画面
- (void)back{
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[ResourceMainVC class]]) {
            ResourceMainVC *testVC  = (ResourceMainVC *)temp;

            [self.navigationController popToViewController:testVC animated:YES];
        }
    }
}

// 添加集合视图
-(void)addCollectionView{
    CGFloat height = WIDTH * 208 / 320;
    ResultHeaderView *head = [[ResultHeaderView alloc]initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               WIDTH,
                                                                               height)];
    
    // 设置星星画面
    [head setStar:self.testResultitem.star];
    [self.view addSubview:head];
    
    ResultCollctionHeaderView *head2 = [[ResultCollctionHeaderView alloc]initWithFrame:CGRectMake(0,
                                                                                        height,
                                                                                        WIDTH,
                                                                                        30)];
    
    [self.view addSubview:head2];
    // Parallax Header
//    self.collectionView.parallaxHeader.view = head;
//    self.collectionView.parallaxHeader.height = height;
//    self.collectionView.parallaxHeader.mode = MXParallaxHeaderModeTop;
//    self.collectionView.parallaxHeader.minimumHeight = 50;
//    [self.collectionView registerClass:[ResultHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ResultHeader"];

    
//    [self.collectionView registerClass:[ResultCollctionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ResultCollctionHeaderViewID"];
    [self.collectionView registerClass:[CourseResultCell class] forCellWithReuseIdentifier:@"CourseResultCell"];
  
    self.collectionView.frame = CGRectMake(0, height + 30 , self.view.frame.size.width, self.view.frame.size.height - kFooterViewHeight - 34 - height);
}
// 添加底部按钮数组视图
-(void)addFooterView
{
    footerView = [[UIView alloc] init];  //self.collectionView.frame.size.height
    footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *linelabel=[[UILabel alloc]initWithFrame:CGRectMake(0 , 0, WIDTH , 1)];
    linelabel.backgroundColor = SepLineColor ;
    [footerView addSubview:linelabel];
    
    CGFloat btnWidth = (WIDTH - 3*kViewPadding) /2;
    UIButton *trainingMistakeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    trainingMistakeButton.frame= CGRectMake(kViewPadding, 10, btnWidth, 34);
    trainingMistakeButton.backgroundColor =[UIColor clearColor];
    [trainingMistakeButton setTitle:@"错题加练" forState:UIControlStateNormal];
    [trainingMistakeButton setTitleColor:GreenLineColor forState:UIControlStateNormal];
    [trainingMistakeButton.layer setCornerRadius:3];
    [trainingMistakeButton.layer setMasksToBounds:YES];
    trainingMistakeButton.layer.borderWidth = 1;
    trainingMistakeButton.layer.borderColor = GreenLblColor.CGColor;
    trainingMistakeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    [trainingMistakeButton addTarget:self action:@selector(trainingMistakeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:trainingMistakeButton];
    
    if([self checkIsAllConrrect]) // 答案全对//全部正确的话，禁止错题重联系
    {
        trainingMistakeButton.enabled = NO;
        trainingMistakeButton.layer.borderWidth = 0;
        trainingMistakeButton.layer.borderColor = AnswerSepLineColor.CGColor;
        [trainingMistakeButton setTitleColor:GrayColor forState:UIControlStateNormal];
        trainingMistakeButton.backgroundColor =AnswerSepLineColor;
    }
    
    
    UIButton *reTrainingButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    reTrainingButton.frame= CGRectMake(WIDTH - kViewPadding - btnWidth, 10,btnWidth, 34);
    reTrainingButton.backgroundColor = GreenLineColor;
    [reTrainingButton setTitle:@"重新闯关" forState:UIControlStateNormal];
    [reTrainingButton setTitleColor:WhiteColor forState:UIControlStateNormal];

    reTrainingButton.titleLabel.font = [UIFont systemFontOfSize:15];

    [reTrainingButton.layer setCornerRadius:3];
    [reTrainingButton.layer setMasksToBounds:YES];
    [reTrainingButton addTarget:self action:@selector(reTrainingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:reTrainingButton];
    
    [self.view addSubview:footerView];
}


// 添加CollectionView 的头视图
-(UIView *)addCollectionViewHeader
{
    CGFloat padding = 4;
    CGFloat widthOfLabel = 80;
    UIView *headerView = [[UIView alloc] init];  //self.collectionView.frame.size.height
    headerView.backgroundColor = ClearColor;
    headerView.frame= CGRectMake(0 , 0, WIDTH , 40);
    
    UILabel *correctImgLabel=[[UILabel alloc]initWithFrame:CGRectMake( WIDTH - 3 *widthOfLabel - 3*padding - 3*24 , 8, 24 , 24)];
    correctImgLabel.backgroundColor = SepLineColor ;
    [headerView addSubview:correctImgLabel];
    
    UILabel *correctLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    correctLabel.frame= CGRectMake(WIDTH - 3 *widthOfLabel - 3*padding - 2*24 , 0, widthOfLabel , 40);
    [correctLabel setBackgroundColor:[UIColor clearColor]];
    [correctLabel setTextAlignment:NSTextAlignmentCenter];
    [correctLabel setFont:[UIFont systemFontOfSize:15]];
    [correctLabel setTextColor:[UIColor grayColor]];
    [correctLabel setText:@"正确"];
    [correctLabel sizeToFit];
    [headerView addSubview:correctLabel];
    
    UILabel *wrongImgLabel=[[UILabel alloc]initWithFrame:CGRectMake( WIDTH - 2 *widthOfLabel - 2*padding - 2*24 , 8, 24 , 24)];
    correctImgLabel.backgroundColor = SepLineColor ;
    [headerView addSubview:wrongImgLabel];
    
    UILabel *wrongLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    wrongLabel.frame= CGRectMake(WIDTH - 2 *widthOfLabel - 2*padding - 24 , 0, WIDTH , 40);
    [wrongLabel setBackgroundColor:[UIColor clearColor]];
    [wrongLabel setTextAlignment:NSTextAlignmentCenter];
    [wrongLabel setFont:[UIFont systemFontOfSize:15]];
    [wrongLabel setTextColor:[UIColor grayColor]];
    [wrongLabel setText:@"错误"];
    [correctLabel sizeToFit];
    [headerView addSubview:wrongLabel];
    
    UILabel *noAnswerImgLabel=[[UILabel alloc]initWithFrame:CGRectMake( WIDTH - widthOfLabel - padding - 24 , 8, 24 , 24)];
    noAnswerImgLabel.backgroundColor = SepLineColor ;
    [headerView addSubview:noAnswerImgLabel];
    
    UILabel *noAnswerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    noAnswerLabel.frame= CGRectMake(0 , 0, WIDTH - 80 , 40);
    [noAnswerLabel setBackgroundColor:[UIColor clearColor]];
    [noAnswerLabel setTextAlignment:NSTextAlignmentCenter];
    [noAnswerLabel setFont:[UIFont systemFontOfSize:15]];
    [noAnswerLabel setTextColor:[UIColor grayColor]];
    [noAnswerLabel setText:@"未答"];
    [noAnswerLabel sizeToFit];
    [headerView addSubview:noAnswerLabel];
    
    return headerView;
}


#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"progress %f", self.scrollView.parallaxHeader.progress);
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.frame;
    
    self.scrollView.frame = frame;
    self.scrollView.contentSize = frame.size;
    
    
    footerView.frame = CGRectMake(0, self.view.frame.size.height - kFooterViewHeight ,
                                  self.view.frame.size.width, kFooterViewHeight);
}

//- (MXScrollView *)scrollView {
//    if(!_scrollView) {
//        _scrollView = [[MXScrollView alloc] init];
//        _scrollView.delegate = self;
//    }
//    return _scrollView;
//}

#pragma mark -- 私有方法
// 按钮点击 传入代理
// 错题加练
-(void)trainingMistakeButtonClick:(UIButton*)button
{
//    [CurrentROOTNavigationVC popViewControllerAnimated:NO];
    TestBaseVC *testVC  = [[TestBaseVC alloc] init];
    testVC.isAgain = LZQuestionWrongAgain;
    testVC.qItem = self.qItem;
    testVC.isEditModel = EditEnable_Status;
//    [testVC getTestData];
    
    [CurrentROOTNavigationVC pushViewController:testVC  animated:YES];
    
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[TestBaseVC class]]) {
//            TestBaseVC *testVC  = (TestBaseVC *)temp;            
//            testVC.isAgain = LZQuestionWrongAgain;
//            testVC.isEditModel = EditEnable_Status;
//            
//            [testVC getTestData];
//            [self.navigationController popToViewController:testVC animated:YES];
//        }
//    }
}

// 按钮点击 传入代理
// 重新闯关
-(void)reTrainingButtonClick:(UIButton*)button
{
    TestBaseVC *testVC  = [[TestBaseVC alloc] init];
    testVC.isAgain = LZQuestionRetrain;
    testVC.isEditModel = EditEnable_Status;
    testVC.qItem = self.qItem;
//    [testVC getTestData];
//    [CurrentROOTNavigationVC popViewControllerAnimated:NO];
    [CurrentROOTNavigationVC pushViewController:testVC  animated:YES];
    
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[TestBaseVC class]]) {
//                TestBaseVC *testVC  = (TestBaseVC *)temp;
//                testVC.isAgain = LZQuestionRetrain;
//                testVC.isEditModel = EditEnable_Status;
//                [testVC getTestData];
//            
//                [self.navigationController popToViewController:temp animated:YES];
//            
//        }
//    }

}

-(BOOL)checkIsAllConrrect
{
    // YES  全队  NO 有错题
    BOOL result = [self.testResultitem  checkIsAllConrrect];
    
    return result;
    
}
#pragma mark -- 获取数据的方法
- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
//    [task setRequestUrl:@"class/app_list_all"];
//    [task setRequestMethod:REQUEST_GET];
//    [task setRequestType:requestType];
//    [task setObserver:self];
    return task;
    
}

- (void)TNBaseTableViewControllerRequestStart
{
    [self startLoading];
}

- (void)TNBaseTableViewControllerRequestSuccess
{
  
    [self.collectionViewModel.modelItemArray removeAllObjects];
    CourseResultListModel * listModel = [[CourseResultListModel alloc] init];
   
        for (NSInteger i = 0; i < listModel.modelItemArray.count; i++) {
            CourseResultItem *item = [listModel.modelItemArray  objectAtIndex:i];
     
            [self.collectionViewModel.modelItemArray addObject:item];
        }
    
    
    [self endLoading];
}

- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg
{
    [self endLoading];
}

- (void)TNBaseCollectionViewControllerModifyLayout:(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
    [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
    [flowLayout setItemSize:CGSizeMake((self.view.width - 20 * 2) / 5, (self.view.width - 20 * 2) / 5)];
    [flowLayout setMinimumLineSpacing:5];
    [flowLayout setMinimumInteritemSpacing:0];
//    flowLayout.headerReferenceSize = CGSizeMake(WIDTH, 30);
}


#pragma mark -- UICollectionView Delegate
//这个方法是返回 Header的大小 size
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    if(section == 0)
//        return CGSizeMake(WIDTH, WIDTH * 208 / 320);
//    else
//        return CGSizeMake(WIDTH, 30);
//}




//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section == 0)
//    {
//        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//            ResultCollctionHeaderView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ResultHeader" forIndexPath:indexPath];
//            return view;
//        }
//    }
//    else if(indexPath.section == 1)
//    {
//        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//            ResultCollctionHeaderView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ResultCollctionHeaderViewID" forIndexPath:indexPath];
//            return view;
//        }
////    }
//    
//    return nil;
//}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if(section == 0)
//        return 0;
    
    return self.testResultitem.praxisList.modelItemArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CourseResultCell" forIndexPath:indexPath];
    [cell setSubItem:self.testResultitem.praxisList.modelItemArray[indexPath.row]];
    return cell;
}


- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    TestBaseVC *testVC = [[TestBaseVC alloc] init];
    testVC.rootVC = self;
    testVC.isEditModel = NotEditEnable_Status;
    testVC.qItem = self.qItem;
    testVC.qItem.status = Complated_Status;
    testVC.testModel = self.testResultitem;
    [testVC toTestViewPage:indexPath.row];
    [CurrentROOTNavigationVC pushViewController:testVC animated:YES];
}

#pragma mark -- UICollectionViewCell Delegate
- (void)answerViewSelected:(TestItem *)item
{
    TestBaseVC *testVC = [[TestBaseVC alloc] init];
    testVC.rootVC = self;
    testVC.qItem = self.qItem;
    testVC.qItem.status = Complated_Status;
    testVC.isEditModel = NotEditEnable_Status;
    testVC.testModel = self.testResultitem;
    [CurrentROOTNavigationVC pushViewController:testVC animated:YES];
}


@end
