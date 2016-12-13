//
//  QuestionSelectTypeCell.h
//  LianzhiParent
//
//  Created by chen on 16/10/12.
//  Copyright © 2016年 SJWY. All rights reserved.

#import <UIKit/UIKit.h>
#import "LZTestModel.h"
#import "SGTopTitleView.h"


@class TPKeyboardAvoidingTableView,DOUAudioStreamer;

@interface TestVoiceButton : UIButton{
    DOUAudioStreamer *_streamer;
}
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
- (id)initWithFrame:(CGRect)frame UrlString:(NSString *)songUrlString;
- (void)_actionPlayPause:(id)sender;
- (void)_actionClose;
@end


@interface QuestionSelectTypeView : UIView
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSUInteger qcount;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign)LZTestType et_code;
@property(nonatomic,strong) UIView * questionView;
@property(nonatomic,assign) EditModel_Status isEditModel;
@property(nonatomic,strong) TPKeyboardAvoidingTableView * answerView;
@property(nonatomic,strong) TestItem *testItem;
@property(nonatomic,strong) TestSubItem *testSubItem;
@property(nonatomic,strong) TNListModel *optionArray;

- (instancetype)initWithFullFrame:(CGRect)frame;
- (void)setSubItem:(TNModelItem *)modelItem;

@end


@interface ReadingQuestionTypeView : UIView
<SGTopTitleViewDelegate, UIScrollViewDelegate>
{
    
}

@property (nonatomic,assign) EditModel_Status isEditModel;
@property(nonatomic,strong) UIView * questionView;
@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) UIView * barView;
@property(nonatomic,strong) UILabel *introLabel;
@property(nonatomic, strong)SGTopTitleView *topTitleView;
@property(nonatomic,strong) QuestionSelectTypeView * questionOfBarView;

@property(nonatomic,strong) NSMutableArray *titles;
@property(nonatomic,strong) TestItem *testItem;
@property(nonatomic,strong) TNListModel *optionArray;


@end
