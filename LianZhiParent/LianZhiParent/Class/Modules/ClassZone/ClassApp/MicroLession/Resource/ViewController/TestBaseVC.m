//
//  TestBaseVC.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TestBaseVC.h"
#import "TestResultVC.h"
#import "LZTestModel.h"
#import "QuestionView.h"
#import "LZQuestionsModel.h"
#import "SwipeView.h"
#import "LZTestModel.h"
#import "ThroughTrainingVC.h"
#import "ResourceMainVC.h"
#import "ParamUtil.h"

@implementation AnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 50, 40)];
        [self.titleLabel setTextColor:[UIColor colorWithHexString:@"616161"]];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:self.titleLabel];
        
        self.conrrectImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 40, 40)];
        [self addSubview:self.conrrectImage];
        
        self.answerTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 2, WIDTH - 90.f, 46)];
        [self.answerTextLabel setTextColor:[UIColor colorWithHexString:@"616161"]];
        [self.answerTextLabel setFont:[UIFont systemFontOfSize:16]];
        [self.answerTextLabel setTextAlignment:NSTextAlignmentLeft];
        self.answerTextLabel.numberOfLines = 0;
//        self.answerTextLabel.adjustsFontSiz·eToFitWidth = YES; // 这是主要讲的。
        [self addSubview:self.answerTextLabel];
        
        self.answerTextTxtField  = [[UITextField alloc] initWithFrame:CGRectMake(75, 5, WIDTH - 90.f, 40)];
        [self.answerTextTxtField setFont:[UIFont systemFontOfSize:16]];
        [self.answerTextTxtField setTextColor:[UIColor colorWithHexString:@"616161"]];
        [self.answerTextTxtField setPlaceholder:@"点击这里答题"];
        [self.answerTextTxtField setKeyboardType:UIKeyboardTypeDefault];
        self.answerTextTxtField.hidden = YES;
        self.answerTextTxtField.delegate = self;
        [self addSubview:self.answerTextTxtField];
                
       self.sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 2, 40)];
        [self.sepLabel setBackgroundColor:AnswerSepLineColor];

        [self addSubview:self.sepLabel];
        
    }
    return self;
}
-(void)setCellStyle:(BOOL)selected
{
    if(selected)
    {
        [self.titleLabel setTextColor:WhiteColor];
        [self.answerTextLabel setTextColor:WhiteColor];
        [self.sepLabel setBackgroundColor:WhiteColor];
        [self.answerTextTxtField setTextColor:WhiteColor];
    }
    else
    {
        [self.titleLabel setTextColor:[UIColor colorWithHexString:@"616161"]];
        [self.answerTextLabel setTextColor:[UIColor colorWithHexString:@"616161"]];
        [self.answerTextTxtField setTextColor:[UIColor colorWithHexString:@"616161"]];
        [self.sepLabel setBackgroundColor:AnswerSepLineColor];

    }
}
-(void)setAnswerItem:(AnswerItem *)aItem{
    self.aItem = aItem;
    // 编辑模式
    if(self.isEditModel == EditEnable_Status){
        // 填空题 需要显示文本框 隐藏答题文本标签
        if(self.type == LZTestFillInTheBlankType)
        {
            self.answerTextTxtField.hidden = NO;
            self.answerTextLabel.hidden = YES;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if(aItem.isChecked)
                self.answerTextTxtField.text = aItem.name;
        }
        else
        {
            // 非填空题 需要隐藏文本框 显示答题文本标签
            self.answerTextTxtField.hidden = YES;
            self.answerTextLabel.hidden = NO;
            self.selectionStyle = UITableViewCellSelectionStyleGray;
            self.answerTextLabel.text = aItem.name;
            
        }
        
        self.conrrectImage.hidden = YES;
        self.titleLabel.text = aItem.tag;
        
    }
    else if(self.isEditModel == NotEditEnable_Status){
        // 非编辑模式，只读 需要显示对与错
        self.conrrectImage.hidden = NO;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray * answerArray = [self.answer componentsSeparatedByString:@"^"];
        NSArray * useranswerArray = [self.userAnswer componentsSeparatedByString:@"^"];
        
        if(self.type == LZTestFillInTheBlankType)
        {
            self.answerTextLabel.hidden = YES;
            //   NSInteger tag = [aItem.tag integerValue];
            NSInteger celltag = self.tag;
            self.answerTextTxtField.enabled = NO;
            self.answerTextTxtField.placeholder = @"";
            self.answerTextTxtField.hidden = NO;
            
            if(answerArray.count > celltag){
                
                NSString *answerStr =  [answerArray objectAtIndex:celltag];
 
                if(useranswerArray.count > celltag){
                    NSString *useranswerStr =  [useranswerArray objectAtIndex:celltag];
                    self.answerTextTxtField.text = useranswerStr;
                    if(useranswerStr && ![useranswerStr isEqualToString:@""])
                    {
                        aItem.isChecked = YES;
                        self.selected = YES;
                    }
                    
                    if([useranswerStr isEqualToString:@""])
                    {
                        self.conrrectImage.image = [UIImage imageNamed:@"wrong"];
                    }
                    else if([answerStr isEqualToString:useranswerStr])
                    {
                        self.conrrectImage.image = [UIImage imageNamed:@"conrrect"];
                    }
                    else
                    {
                        self.conrrectImage.image = [UIImage imageNamed:@"wrong"];
                    }
                    
                }
                else
                {
                    self.conrrectImage.image = [UIImage imageNamed:@"wrong"];
                }
            }
        }
        else
        {
            self.answerTextLabel.text = aItem.name;
            if([useranswerArray containsObject:aItem.tag] && [answerArray containsObject:aItem.tag])
            {
                aItem.isChecked = YES;
                self.selected = YES;
                self.conrrectImage.image = [UIImage imageNamed:@"conrrect"];
            }
            else if([useranswerArray containsObject:aItem.tag] && ![answerArray containsObject:aItem.tag])
            {
                self.selected = YES;
                aItem.isChecked = YES;
                self.conrrectImage.image = [UIImage imageNamed:@"wrong"];
            }
            else if(![useranswerArray containsObject:aItem.tag] && [answerArray containsObject:aItem.tag])
            {
                self.conrrectImage.image = [UIImage imageNamed:@"conrrect"];
            }
            else if(![useranswerArray containsObject:aItem.tag] && ![answerArray containsObject:aItem.tag])
            {
                self.conrrectImage.image = nil;
                self.titleLabel.text = aItem.tag;
            }
            else
            {
                self.conrrectImage.image = nil;
                self.titleLabel.text = aItem.tag;
            }
        }

    }
    else
    {
        //Edited_Status,                   // 有做过的题目，允许编辑
        // 非编辑模式，只读 需要显示对与错
        self.conrrectImage.hidden = YES;
        self.titleLabel.hidden = NO;
//        NSArray * editUseranswerArray = [self.editAnswer componentsSeparatedByString:@"^"];
        self.titleLabel.text = aItem.tag;
      
        
        if(self.type == LZTestFillInTheBlankType)
        {//填空题
            self.answerTextLabel.hidden = YES;
//            NSInteger tag = [aItem.tag integerValue];
            self.answerTextTxtField.enabled = YES;
            self.answerTextTxtField.hidden = NO;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            if(aItem.isChecked)
                self.answerTextTxtField.text = aItem.name;
  
        }
        else
        {
            self.answerTextLabel.hidden = NO;
            self.answerTextTxtField.hidden = YES;
            self.answerTextLabel.text = aItem.name;
            self.selectionStyle = UITableViewCellSelectionStyleGray;
//            if([editUseranswerArray containsObject:aItem.tag])
//            {
//                aItem.isChecked = YES;
//            }

        }

    }
    
    
}

#pragma mark - UItextFieldDelegate


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceAndNewlineCharacterSet]]; // stri
    self.aItem.name = trimmedString;
//    if (_textEditedhandler) {
//        _textEditedhandler(trimmedString);
//    }
    
    if(self.aItem.name.length > 0)
    {
        self.aItem.isChecked = YES;
    }
    else
    {
        self.aItem.isChecked = NO;
    }
}

//第二步,实现回调函数
//- (void) textFieldDidChange:(id) sender {
//    UITextField *_field = (UITextField *)sender;
//    self.aItem.name = _field.text;
//}

@end



@interface TestBaseVC ()<SwipeViewDataSource, SwipeViewDelegate>
//<ZYBannerViewDataSource, ZYBannerViewDelegate>
{
    UITapGestureRecognizer *recognizer;
}
@property(nonatomic,strong)SwipeView *testView;
@property(nonatomic,strong)UILabel *nameLabel;   //顶部头视图 题型标签
@property(nonatomic,strong)UILabel *titleLabel;   //顶部头视图 题型标签
@property(nonatomic,strong)UILabel *pageLabel;   //顶部头视图 页数标签
@property(nonatomic,strong)UIView  *headView;    //顶部头视图

@end

@implementation TestBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeadView];
    
    // 配置测试视图
    [self setupTestView:0];

    [self updateTitle:_qItem.chapter_name];

    if(self.isEditModel){

        if(self.qItem.status == NotComplated_Status && self.isAgain == LZQuestionFirst)
        {
            [self loadCache];
            
            if(self.testModel == nil || self.testModel.praxisList.modelItemArray == nil
               || self.testModel.praxisList.modelItemArray.count == 0 )
            {
                 self.testModel= [[LZTestModel alloc]init];
                 [self getTestData];
            }
        }
        else{
            self.testModel= [[LZTestModel alloc]init];
            [self getTestData];
            // 错题加练不读缓存
        }
    }
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 配置试题视图
- (void)setupTestView:(NSUInteger)index
{
    if(!self.testView){
        // 初始化
        self.testView = [[SwipeView  alloc] init];//ZYBannerView
        self.testView.firstItemIndex = index;
        self.testView.dataSource = self;
        self.testView.delegate = self;
        
        [self.view addSubview:self.testView];
        
        self.testView.bounces = NO;
        // 设置frame
        self.testView.frame = CGRectMake(0,
                                       49,
                                       WIDTH,
                                       HEIGHT - 64 - 48);
    }
}



// 配置试题视图
-(void)setHeadView
{
    if (!_headView) {
        _headView=[[UIView alloc]init];
        _headView.frame = CGRectMake(0, 0, self.view.width, 48);
        _headView.backgroundColor = [UIColor whiteColor];
        // 题型显示标签
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  5, 150, 38)];
        [self.nameLabel setTextColor:JXColor(0x45,0x45,0x45,1)];
        
        [self.nameLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [_headView addSubview:self.nameLabel];
        
//        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2 + 50 , 5, 100, 38)];
//        [self.titleLabel setTextColor:JXColor(0x45,0x45,0x45,1)];
//        
//        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
//        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
//        [_headView addSubview:self.titleLabel];
        // 页码显示标签
        self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 160, 5, 140, 38)];
        
        [self.pageLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.pageLabel setTextAlignment:NSTextAlignmentRight];
        [_headView addSubview:self.pageLabel];

        [self.view addSubview:_headView];
    }
    
}

- (EmptyHintView *)emptyView{
    if(!_emptyView){
        _emptyView = [[EmptyHintView alloc] initWithImage:@"NoInfo" title:@"网络不给力,点击空白处重新加载"];
        
        recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(getTestData)];
        //使用一根手指双击时，才触发点按手势识别器
        recognizer.numberOfTapsRequired = 1;
        recognizer.numberOfTouchesRequired = 1;
        [self.view addGestureRecognizer:recognizer];
        recognizer.enabled = NO;
    }
    return _emptyView;
}

#pragma mark -- 私有方法
-(void)toTestViewPage:(NSUInteger)index
{
    // 配置测试视图
    [self setupTestView:index];
    
    [self.testView scrollToPage:index duration:0.0f];
}

- (void)back{
    NSLog(@"back");
    
    [self.view endEditing:YES];
    
    if(self.isEditModel == NotEditEnable_Status)
    {
        [CurrentROOTNavigationVC popViewControllerAnimated:YES];
        
    }
    else
    {
        if(self.qItem.status == NotComplated_Status && self.isAgain == LZQuestionFirst){
            [self getAnswerString];
            [self saveCache];
        }
        else if(self.qItem.status == NotComplated_Status){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您确定放弃本次答题吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[ResourceMainVC class]]) {
                        ResourceMainVC *testVC  = (ResourceMainVC *)temp;
                        
                        [self.navigationController popToViewController:testVC animated:YES];
                    }
                }
                
            }];
            
            // Add the actions.
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[ResourceMainVC class]]) {
                ResourceMainVC *testVC  = (ResourceMainVC *)temp;
                
                [self.navigationController popToViewController:testVC animated:YES];
            }
        }
    }
    
}



//交卷按钮点击 传入代理
-(void)commitButtonClick:(UIButton*)button
{
    [self.view endEditing:YES];
    
    NSMutableArray *anserList = [self getAnswerString];
    
    if(![self.testModel checkIsComplated])
    {
        [self showAlert:@"您还有题未完成，确认交卷吗？"  ParaAnswerList:anserList SubmitIButton:button];
        return;
    }
 
    [self submitQuestion:anserList SubmitIButton:button];
    
}

//显示对话框
-(void)showAlert:(NSString *)message   ParaAnswerList:(NSMutableArray *)anserList
   SubmitIButton:(UIButton*)button
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
         [self submitQuestion:anserList SubmitIButton:button];
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

// 刷新标题
-(void)updateTitle:(NSString *)title
{
     self.title = title;
}

// 刷新顶部Head视图
// 显示题型    当前页数/总页数
-(void)updateHeadView:(TestItem *)item  Index:(NSString *)page
{
    if(item){
        self.nameLabel.text = [NSString stringWithFormat:@"%@ (%@)",item.skill_name,[item getTypeString]];
    }
    else
    {
        self.nameLabel.text = @"";
    }
  
//    if(self.isAgain == LZQuestionWrongAgain)
//    {
//        self.titleLabel.text = @"错题加练";
//    }
//    else
//    {
//         self.titleLabel.text = @"";
//    }
    NSString *string = page;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSUInteger length = [string length];
    
    //设置字体
    NSRange greenStartRange = [string rangeOfString:@"/"];
    
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
    
    [attrString setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                NSForegroundColorAttributeName :greencolor}
                        range:NSMakeRange(0,greenLength)];
    
    
    
    if(self.isAgain == LZQuestionWrongAgain)
    {
        NSMutableAttributedString *misattrString = [[NSMutableAttributedString alloc] initWithString:@"(错题加练) "];
        [misattrString appendAttributedString:attrString];
        self.pageLabel.attributedText = misattrString;
        return;
    }
    
    self.pageLabel.attributedText = attrString;
    //    [attrString addAttribute:NSForegroundColorAttributeName
    //                       value:greencolor
    //                       range:NSMakeRange(0,greenLength)];
    

    
}



//刷新排名右侧导航按钮
-(void)updateRightNaviItem
{
    if(self.isEditModel){
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"交卷"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(commitButtonClick:)];
       
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)applicationDidEnterBackground:(id)sender {
    
    [self saveCache];
}

#pragma mark -- 获取数据
- (NSString *)cacheFileName
{
    NSString *cachename = @"TestBaseVC";
    return cachename;

}

- (NSString *)cacheFileIdName
{
    NSString *cachename = [NSString stringWithFormat: @"%@/TestBaseVC_%@",
                           [self cacheFilePath],self.qItem.q_id];
    return cachename;
    
}

- (BOOL)supportCache
{
    return YES;
}

- (void)loadCache
{
    if([self supportCache])//支持缓存，先出缓存中读取数据
    {
        NSData *data = [NSData dataWithContentsOfFile:[self cacheFileIdName]];
        if(data.length > 0){
            self.testModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
}

- (void)removeCache
{
    if([self supportCache])//支持缓存，先出缓存中读取数据
    {
        NSString *delelteFilePath  = [self cacheFileIdName];
        if (delelteFilePath) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                //下面这玩意是线程安全的，不用害怕
                if ([[NSFileManager defaultManager] fileExistsAtPath:delelteFilePath]) {
                    [[NSFileManager defaultManager] removeItemAtPath:delelteFilePath
                                                               error:NULL];
                }
                
            });
        }

    }
}

- (void)saveCache{
    
    // 错题加练不读缓存
    if([self supportCache])
    {
        if(![[NSFileManager defaultManager] fileExistsAtPath:[self cacheFilePath]]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
            NSLog(@"first run");
        
            [[NSFileManager defaultManager] createDirectoryAtPath:[self cacheFilePath] withIntermediateDirectories:YES attributes:nil error:nil];
     
        }
        
        NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:self.testModel];
        
        if(modelData){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                BOOL success = [modelData writeToFile:[self cacheFileIdName] atomically:YES];
                if(success)
                    DLOG(@"save success");
            });
        }
    }
    
}


// 获取学力相关数据
- (void)getTestData
{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *childId = [UserCenter sharedInstance].curChild.uid;
    NSString  *sqid = self.qItem.sq_id == nil ? @"":self.qItem.sq_id;
    NSString  *again = [NSString stringWithFormat:@"%ld",(long)self.isAgain];
    NSString  *subject_code = [NSString stringWithFormat:@"%ld",(long)self.subjectCode];
    [params setValue:childId forKey:@"child_id"];  // 当前孩子id
    [params setValue:sqid forKey:@"sq_id"];        // 当前sq_id   闯关答案ID
    [params setValue:again forKey:@"again"];       // 0 第一次答题 1 重新答题 2 错题重答
    [params setValue:subject_code forKey:@"subject_code"];
    [params setValue:self.qItem.q_id forKey:@"q_id"];  //self.qItem.q_id
    
    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在获取信息" toView:self.view];
    [self showEmptyView:NO
     ];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"evaluation/startQuestions"
                                                    method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil
                                                completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        
        if(responseObject){
            [wself.testModel parseData:responseObject type:REQUEST_REFRESH];
            wself.qItem.sq_id = wself.testModel.sq_id;
            wself.qItem.status = NotComplated_Status;
            
            [wself.testView reloadData];
            [wself saveCache];
            [wself toTestViewPage:0];
            recognizer.enabled = NO;
        }
 
        [hud hide:YES];
        
    } fail:^(NSString *errMsg) {
        [hud hide:YES];
        
        BOOL isShow = wself.testModel.praxisList.modelItemArray.count == 0;
        [self showEmptyView:isShow];
        
        recognizer.enabled = isShow;
//        [ProgressHUD showHintText:errMsg];
    }];
    
}

// 组合成答题答案
-(NSMutableArray *)getAnswerString{
    NSMutableArray *answerList = [NSMutableArray array];
    
    //（p_id习题表id ; s_id习题结构表id ; answer答案 ; sa_id学生答题表id(错题重练传ID，其他传0）; is_error是否正确（0正确 1错误））
    
    for(TestItem *item in self.testModel.praxisList.modelItemArray)
    {
        
        for(TestSubItem *subItem in item.praxis.modelItemArray )
        {
            NSMutableDictionary *answer= [NSMutableDictionary dictionary];
            [answer setValue:[NSString stringWithFormat:@"%ld",(long)item.p_id] forKey:@"p_id"];
            [answer setValue:[NSString stringWithFormat:@"%ld",(long)subItem.s_id] forKey:@"s_id"];
            [answer setValue:[NSString stringWithFormat:@"%@",item.skill_code] forKey:@"skill_code"];
            NSMutableString *answerStr = nil;
            for(AnswerItem *aItem in subItem.option.modelItemArray)
            {
                if(item.et_code == LZTestFillInTheBlankType)
                {

                    if(aItem.isChecked){
                        if(answerStr == nil)
                        {
                            answerStr = [NSMutableString string];
                            [answerStr  appendFormat:@"%@",aItem.name];
                        }
                        else
                            [answerStr  appendFormat:@"^%@",aItem.name];
                    }
                    else
                    {
                        if(answerStr == nil)
                        {
                            answerStr = [NSMutableString string];
                        }
                        else
                        {
                            // 未选中空白答案也要添加分隔符号
                            [answerStr  appendFormat:@"^"];
                        }
                    }
                  
                    
                }
                else{
                    if(aItem.isChecked)
                    {
                        if(answerStr == nil)
                        {
                            answerStr = [NSMutableString string];
                            [answerStr  appendString:aItem.tag];
                        }else
                        {
                            [answerStr  appendFormat:@"^%@",aItem.tag];
                        }

                    }
                    
                }
             
            }
            
            
            if(!answerStr){
                answerStr = [NSMutableString string];
            }

            subItem.userAnswer = answerStr;
            [answer setValue:answerStr forKey:@"answer"];
            [answer setValue:subItem.answer forKey:@"qanswer"];
        
            NSString *sa_id = [NSString stringWithFormat:@"%ld",(long)subItem.sa_id];
            [answer setValue:sa_id forKey:@"sa_id"];
            
            [answerList addObject:answer];
        }
    }
 
    return answerList;
}
// 获取学力相关数据
- (void)submitQuestion:(NSMutableArray *)anserList   SubmitIButton:(UIButton*)button
{

//    ThroughTrainingVC *throughTrainingVC = (ThroughTrainingVC *)(self.rootVC);
//    ResourceMainVC *mainVC= (ResourceMainVC *)throughTrainingVC.baseRootVC;
//    NSString *childId = [UserCenter sharedInstance].curChild.uid;
//    NSString *class_id =  mainVC.classInfo.classID;
//    NSString *school_id =  mainVC.classInfo.school.schoolID;
    
    NSMutableDictionary *params =  [[ParamUtil sharedInstance] getParam];
    
    NSString *again =  [NSString stringWithFormat:@"%ld",(long)self.isAgain];
    NSString *q_id =  [NSString stringWithFormat:@"%lu",(unsigned long)self.testModel.q_id];
    NSString *subject_code =  [NSString stringWithFormat:@"%lu",(unsigned long)self.testModel.subject_code];
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
//    [params setValue:childId forKey:@"child_id"];
//    [params setValue:class_id forKey:@"class_id"];
//    [params setValue:school_id forKey:@"school_id"];
    [params setValue:q_id forKey:@"q_id"];  //self.qItem.q_id
    [params setValue:again forKey:@"again"];
    
    [params setValue:self.testModel.sq_id == nil? @"0":self.testModel.sq_id forKey:@"sq_id"];
    
    [params setValue:subject_code forKey:@"subject_code"];
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:anserList options:kNilOptions error:nil];
    // OC对象 -> JSON数据 [数据传输只能以进制流方式传输,所以传输给我们的是进制流,但是本质是JSON数据
    NSString *answerJson =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [params setValue:answerJson forKey:@"answerList"];

    button.enabled = NO;
   
    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在提交试卷" toView:self.view];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"evaluation/submitQuestions" method:REQUEST_POST
                                                      type:REQUEST_REFRESH withParams:params observer:nil
                                                completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
       
        if(responseObject){
            [wself.testModel parseData:responseObject type:REQUEST_REFRESH];
            [wself removeCache];
           
            TestResultVC *resultVC = [[TestResultVC alloc]init];
            resultVC.testResultitem = wself.testModel;
            resultVC.qItem = wself.qItem;
            resultVC.rootVC = wself.rootVC;
            resultVC.title = wself.qItem.chapter_name;
            [CurrentROOTNavigationVC pushViewController:resultVC animated:YES];
        }
                                                    
        if(wself.qItem.status == NotComplated_Status){
            wself.qItem.status = Complated_Status;
        }
                                                    
        button.enabled = YES;
        [hud hide:YES];
        
    } fail:^(NSString *errMsg) {
        dispatch_async(dispatch_get_main_queue(), ^(){
            button.enabled = YES;
            [hud hide:YES];
            [ProgressHUD showHintText:errMsg];
         
        });
        
    }];
    
}

#pragma mark -
#pragma mark iCarousel methods
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return  self.testModel.praxisList.modelItemArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index
          reusingView:(UIView *)view
{
    NSLog(@"index %ld",(long)index + 1);
    
    //当前页码
    self.pageNumber = index + 1;
    
    //刷新导航栏按钮，最后一页的话需要显示交卷按钮
    [self updateRightNaviItem];
    
    // 取出数据
    TestItem *item = [self.testModel.praxisList.modelItemArray
                                                    objectAtIndex:index];

    

    if(item.et_code == LZTestReadingComprehensionType ||
       item.et_code == LZTestClozetestType)
    {
        //完形填空 或者 阅读理解
        ReadingQuestionTypeView *questionView = [[ReadingQuestionTypeView alloc]initWithFrame:self.testView.bounds];
        questionView.isEditModel = self.isEditModel;
        questionView.questionOfBarView.qcount = self.testModel.qcount;
        [questionView setTestItem:item];
        
        return questionView;
    }
    else
    {
        QuestionSelectTypeView *questionView = [[QuestionSelectTypeView alloc]initWithFrame:self.testView.bounds];
        questionView.isEditModel = self.isEditModel;
        questionView.qcount = self.testModel.qcount;
        [questionView setTestItem:item];
     
        return questionView;
        
    }

}

- (void)swipeViewDidScroll:(SwipeView *)swipeView
{
    // 刷新头视图
    // 取出数据
    // 错题加练有可能会超出数组范围，需要特殊处理
    
    if(self.testModel.praxisList.modelItemArray.count > 0 &&
       swipeView.currentItemIndex < self.testModel.praxisList.modelItemArray.count){
        TestItem *item = [self.testModel.praxisList.modelItemArray
                          objectAtIndex:swipeView.currentItemIndex];
        
        NSString * page = [NSString stringWithFormat:@"%ld/%lu",(long)item.index,
                           (unsigned long)self.testModel.qcount];
//        if(self.isAgain == LZQuestionWrongAgain)
//        {
//            page = [NSString stringWithFormat:@"%ld/%lu",(unsigned long)swipeView.currentItemIndex + 1,
//                           (unsigned long)self.testModel.praxisList.modelItemArray.count];
//        }
//        else if(self.isAgain == LZQuestionRetrain)
//        {
//            page = [NSString stringWithFormat:@"%ld/%lu",(unsigned long)swipeView.currentItemIndex + 1,
//                    (unsigned long)self.testModel.praxisList.modelItemArray.count];
//        }
//        else
//        {
//            page = [NSString stringWithFormat:@"%ld/%lu",(long)item.index,
//                               (unsigned long)self.testModel.qcount];
//
//        }
        
        [self updateHeadView:item  Index:(NSString *)page];
    }
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.testView.bounds.size;
}
@end
