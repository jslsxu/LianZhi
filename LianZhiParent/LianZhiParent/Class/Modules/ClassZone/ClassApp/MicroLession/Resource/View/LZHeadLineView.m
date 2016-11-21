//
//  HeadLineView.m
//  LianzhiParent
//
//  Created by Chen qi on 15/11/12.
//  Copyright © 2016年 com.sjwy. All rights reserved.



#import "LZHeadLineView.h"
#import "ResourceDefine.h"



@interface LZHeadLineView()
{
    UIButton *currentSelected;

    //按钮的数据
    NSMutableArray * buttonArray;

}
@end
@implementation LZHeadLineView
-(instancetype)init
{
    if (self=[super init]) {
        // 初始化按钮数组
        buttonArray=[[NSMutableArray alloc]init];
    }
    return self;
}

//设置当前currentIndex
-(void)setCurrentIndex:(NSInteger)CurrentIndex
{
    // 改变currentIndex
    _CurrentIndex=CurrentIndex;
    // 刷新界面
    [self shuaxinJiemian:_CurrentIndex];
    // 执行代理事件
    if ([_delegate respondsToSelector:@selector(refreshHeadLine:)]) {
        [_delegate refreshHeadLine:_CurrentIndex];
    }
}


//刷新界面
-(void)shuaxinJiemian:(NSInteger)index;
{
    if (buttonArray.count>0) {//防止没创建前为空
        for (UIButton *labelView in buttonArray) {
            if (labelView.tag==index) {
                UILabel *label  = [self viewWithTag:1000 + index];
                // 底部指示线变成深绿线
                label.backgroundColor= GreenLblColor;
                // 保存当前选择按钮
                currentSelected=labelView;
                // 设置原先选择按钮的样式  变成绿色
                [currentSelected setTitleColor:GreenLblColor forState:UIControlStateNormal];
            }else{
                    UILabel *label  = [self viewWithTag:1000 + labelView.tag];
                    //取消原先选择按钮的样式  变成透明
                    label.backgroundColor= ClearColor;

            }
        }
    }
}

//按钮点击 传入代理
-(void)buttonClick:(UIButton*)button
{
    NSInteger viewTag=[button tag];
    
    if ([button isEqual:currentSelected]) {
        return;
    }
    
    [currentSelected setTitleColor:GrayLblColor forState:UIControlStateNormal];
    _CurrentIndex=viewTag;
    [self shuaxinJiemian:_CurrentIndex];
    if ([_delegate respondsToSelector:@selector(refreshHeadLine:)]) {
        [_delegate refreshHeadLine:_CurrentIndex];
    }
}

//传入顶部的title
-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray=titleArray;
    UIButton * btn=NULL;
    CGFloat width=WIDTH/_titleArray.count;
    NSUInteger count = _titleArray.count;
    
    UILabel *seplabel=[[UILabel alloc]initWithFrame:CGRectMake(0 , 0, WIDTH , 1)];
    seplabel.backgroundColor = JXColor(0xd7, 0xd7, 0xd7, 1) ;
    [self addSubview:seplabel];
    
    UILabel *linelabel=[[UILabel alloc]initWithFrame:CGRectMake(0 , 48, WIDTH , 2)];
    linelabel.backgroundColor = JXColor(0xd7, 0xd7, 0xd7, 1) ;
    [self addSubview:linelabel];
    
    for (int i=0; i< count; i++) {
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i*width, 1, width, 47);
        btn.tag=i;
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        btn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
  
        [btn setBackgroundColor:[UIColor whiteColor]];

        [btn setUserInteractionEnabled:YES];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:btn];
        [self addSubview:btn];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width * i + TitlePadding , 45.5, width- 2 * TitlePadding , 2.5)];
        label.tag = 1000 + i;
        [self addSubview:label];
        
        label.backgroundColor = ClearColor;
        [btn setTitleColor:GrayLblColor forState:UIControlStateNormal];
//        if (i==0) {
//            currentSelected=btn;
//            //深绿线
//            [btn setTitleColor:GreenLblColor forState:UIControlStateNormal];
//            label.backgroundColor = GreenLineColor ;
//          
//            //如果需要添加图片，请把注释去掉就可以了
////            [btn setTitleColor:JXColor(87, 173, 104, 1) forState:UIControlStateNormal];
////            [btn setBackgroundColor:[UIColor whiteColor]];
//            //[btn setImage:[UIImage imageNamed:@"ribbon-pressed@2x.png"] forState:UIControlStateNormal];
//        }else{
//            //绿线
//            label.backgroundColor = ClearColor;
//            [btn setTitleColor:GrayLblColor forState:UIControlStateNormal];
//        }
    }
}
@end
