//
//  CourseSelectVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "CourseSelectVC.h"

@implementation CourseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"send_sms_on"]];
        [_selectImageView setOrigin:CGPointMake(10, (self.height - _selectImageView.height) / 2)];
        [self addSubview:_selectImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_selectImageView.right + 10, 0, self.width - (_selectImageView.right + 10), self.height)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_nameLabel];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

- (void)setCourse:(NSString *)course{
    _course = [course copy];
    [_nameLabel setText:_course];
}

- (void)setCourseSelected:(BOOL)courseSelected{
    _courseSelected = courseSelected;
    [_selectImageView setHidden:!_courseSelected];
}
@end

@implementation CourseAddCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImageView* addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_target"]];
        [addImageView setOrigin:CGPointMake(38, (self.height - addImageView.height) / 2)];
        [self addSubview:addImageView];
        
        UILabel*    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setTextColor:kCommonTeacherTintColor];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setText:@"添加科目"];
        [titleLabel sizeToFit];
        [titleLabel setOrigin:CGPointMake(addImageView.right + 10, (self.height - addImageView.height) / 2)];
        [self addSubview:titleLabel];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

@end

#define kCourseCacheKey         @"courseCacheKey"

@interface CourseSelectVC ()<UITableViewDelegate, UITableViewDataSource, ReplyBoxDelegate>
@property (nonatomic, strong)UITableView*   tableView;
@property (nonatomic, strong)ReplyBox*      replyBox;
@property (nonatomic, strong)NSMutableArray*       courseArray;
@end

@implementation CourseSelectVC

+ (NSString *)defaultCourse{
    NSArray *courseArray = [[LZKVStorage userKVStorage] storageValueForKey:kCourseCacheKey];
    if([courseArray count] > 0){
        return courseArray[0];
    }
    return nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"科目管理";
    [self loadCourse];
    [self addCurCourse];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:[self replyBox]];
    // Do any additional setup after loading the view.
}

- (void)addCurCourse{
    if(self.course.length > 0){
        for (NSString *course in self.courseArray) {
            if([course isEqualToString:self.course]){
                return;
            }
        }
        [self.courseArray insertObject:self.course atIndex:0];
    }
}

- (void)loadCourse{
    NSArray *courseArray = [[LZKVStorage userKVStorage] storageValueForKey:kCourseCacheKey];
    if(!courseArray){
        courseArray = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物", @"政治", @"历史", @"地理"];
    }
    self.courseArray = [NSMutableArray arrayWithArray:courseArray];
}

- (void)saveCourse{
    [[LZKVStorage userKVStorage] saveStorageValue:self.courseArray forKey:kCourseCacheKey];
}

- (void)addCourse{
    [_replyBox setHidden:NO];
    [_replyBox assignFocus];
}

- (void)confirm{
    if(self.courseSelected){
        self.courseSelected(self.course);
    }
    //把选的科目放到第一个
    if([self.course length] > 0){
        [self.courseArray removeObject:self.course];
        [self.courseArray insertObject:self.course atIndex:0];
        [self saveCourse];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (ReplyBox *)replyBox{
    if(!_replyBox){
        _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, self.view.height - REPLY_BOX_HEIGHT, self.view.width, REPLY_BOX_HEIGHT)];
        [_replyBox setDelegate:self];
        [self.view addSubview:_replyBox];
        _replyBox.hidden = YES;
    }
    return _replyBox;
}

#pragma mark - ReplyBoxDelegate
- (void)onActionViewCancel{
    _replyBox.hidden = YES;
    [_replyBox resignFocus];
    [_replyBox setText:nil];
}

- (void)onActionViewCommit:(NSString *)content{
    if(content.length > 0){
        self.course = content;
        [self addCurCourse];
        [self saveCourse];
        [self.tableView reloadData];
        [self onActionViewCancel];
    }
    [_replyBox setText:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courseArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if(row < [self.courseArray count]){
        NSString *reuseID = @"CourseCell";
        CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil){
            cell = [[CourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        NSString *curCourse = self.courseArray[row];
        [cell setCourse:curCourse];
        [cell setCourseSelected:[self.course isEqualToString:curCourse]];
        return cell;
    }
    else{
        NSString *reuseID = @"CourseAddCell";
        CourseAddCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil){
            cell = [[CourseAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < [self.courseArray count]){
        NSString *course = self.courseArray[indexPath.row];
        if([course isEqualToString:self.course]){
            return NO;
        }
        else{
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSString *course = self.courseArray[row];
    [self.courseArray removeObject:course];
    [self saveCourse];
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if(row < [self.courseArray count]){
        self.course = self.courseArray[row];
        [tableView reloadData];
    }
    else{
        [self addCourse];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
