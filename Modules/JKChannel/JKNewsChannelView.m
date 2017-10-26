//
//  JKNewsChannelView.m
//  Chanel
//
//  Created by chinabyte on 2017/8/14.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKNewsChannelView.h"
#import "JKType.h"

#define JKScreenHeight [UIScreen mainScreen].bounds.size.height
#define JKScreenWidth [UIScreen mainScreen].bounds.size.width
const CGFloat TTNewsChannelsScrollerHeight = 44;

const CGFloat CurrentColorRed = 0.75;
const CGFloat CurrentColorGreen = 0.22;
const CGFloat CurrentColorBlue = 0.20;

const CGFloat NormalColorRed = 0.00;
const CGFloat NormalColorGreen = 0.00;
const CGFloat NormalColorBlue = 0.00;

@interface JKNewsChannelView ()
@property (nonatomic, weak) UIScrollView * scrollerView;
@property (nonatomic, weak) UIButton * addChannelButotn;
@end

@implementation JKNewsChannelView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubViews];
    }
    return self;
}
+ (instancetype)newsChannelsView{
    JKNewsChannelView *channelsView = [[JKNewsChannelView alloc] initWithFrame:CGRectMake(0, 0, JKScreenWidth, 64)];
    return channelsView;
}

#pragma mark - 布局子View
- (void)addSubViews{
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:217/255.0 blue:202/255.0 alpha:255/255.0];
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height - TTNewsChannelsScrollerHeight, width, TTNewsChannelsScrollerHeight)];
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:scrollerView];
    self.scrollerView = scrollerView;
    
    // 加号按钮
    UIButton *addChannelButotn = [[UIButton alloc]initWithFrame:CGRectMake(width - TTNewsChannelsScrollerHeight, height - TTNewsChannelsScrollerHeight, TTNewsChannelsScrollerHeight, TTNewsChannelsScrollerHeight)];
    [addChannelButotn setTitle:@"十" forState:UIControlStateNormal];
    addChannelButotn.backgroundColor = [UIColor blueColor];
    [addChannelButotn addTarget:self action:@selector(addChannel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addChannelButotn];
    self.addChannelButotn = addChannelButotn;
}

#pragma mark - 重写频道列表
- (void)setNewsChannels:(NSArray *)newsChannels{
    _newsChannels = newsChannels;
    [self.scrollerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < newsChannels.count; i++) {
        JKType *type = newsChannels[i];
        //添加标题
        NSString *title = type.title;
        CGFloat titleWidth = [title boundingRectWithSize:CGSizeMake(JKScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.width;
        
        UILabel *label = [UILabel new];
        label.text = title;
        label.font = [UIFont systemFontOfSize:15.0];
        label.userInteractionEnabled = YES;
        label.tag = i + 100;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedNewsChannelsItem:)];
        [label addGestureRecognizer:gesture];
        if (i==0) {
            CGRect frame = CGRectMake(10, 0, titleWidth, TTNewsChannelsScrollerHeight);
            label.frame = frame;
        } else {
            UILabel *preLabel = self.scrollerView.subviews.lastObject;
            CGRect frame = CGRectMake(CGRectGetMaxX(preLabel.frame) + 10, 0, titleWidth, TTNewsChannelsScrollerHeight);
            label.frame = frame;
        }
        [self.scrollerView addSubview:label];
    }
    
    UILabel *currentLabel = self.scrollerView.subviews[self.currentIndex];
    
    currentLabel.textColor = [UIColor colorWithRed:0.75 green:0.22 blue:0.20 alpha:1.0];
    currentLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
    UILabel *lastLabel = self.scrollerView.subviews.lastObject;
    // 判断是否已经隐藏加号按钮
    if (self.hideAddButton) {
        self.scrollerView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame) + 10, 0);
    } else {
        self.scrollerView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame) + 10 + TTNewsChannelsScrollerHeight, 0);
    }
}

#pragma mark - 重写隐藏加号按钮
- (void)setHideAddButton:(BOOL)hideAddButton{
    _hideAddButton = hideAddButton;
    self.addChannelButotn.hidden = hideAddButton;
    UILabel *lastLabel = self.scrollerView.subviews.lastObject;
    if (lastLabel == nil) {
        return;
    }
    if (hideAddButton) {
        self.scrollerView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame) + 10, 0);
    } else {
        self.scrollerView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame) + 10 + TTNewsChannelsScrollerHeight, 0);
    }
}

#pragma mark - 选中某个频道
- (void)selectedNewsChannelsItem:(UIGestureRecognizer*)ges{
    NSInteger tag = ges.view.tag;
    //判断是否已选中情况下点击
    if (tag - 100 == self.currentIndex) {
        return;
    }
    //当前选中
    UILabel *currentLabel = [self.scrollerView viewWithTag:100 + self.currentIndex];
    //判断左右滑
    UILabel *nextLabel = [self.scrollerView viewWithTag:tag];
    [UIView animateWithDuration:.2 animations:^{
        currentLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        nextLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        //改变字体颜色
        currentLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        nextLabel.textColor = [UIColor colorWithRed:0.75 green:0.22 blue:0.20 alpha:1.0];
    }];
    self.currentIndex = tag - 100;
    [self scrollerToCenterWithIndex:self.currentIndex];
    // 通知外界的scrollerView根据Index滚动到相应位置
    if ([self.jkDelegate respondsToSelector:@selector(JKNewsChannelsView:didSelectedNewsChannelItemAtIndex:)]) {
        [self.jkDelegate JKNewsChannelsView:self didSelectedNewsChannelItemAtIndex:self.currentIndex];
    }
}

#pragma mark - 选中某个频道后，滚动到中心点
- (void)scrollerToCenterWithIndex:(NSInteger)index{
    self.currentIndex = index;
    if (self.scrollerView.contentSize.width <= self.scrollerView.frame.size.width) { // 如果scrollerView内容的宽度<=scrollerView的宽度，不滚动
        return;
    }
    UILabel *currentLabel = [self.scrollerView viewWithTag:index + 100];
    CGFloat pointX = currentLabel.center.x;
    CGFloat titleScrollCenterX = self.scrollerView.center.x;
    CGFloat titleScrollContentWidth = self.scrollerView.contentSize.width;
    if (pointX > titleScrollCenterX && titleScrollContentWidth-pointX > titleScrollCenterX){
        
        [self.scrollerView setContentOffset:CGPointMake(pointX - titleScrollCenterX, 0) animated:YES];
        
    } else if (pointX > titleScrollCenterX && titleScrollContentWidth-pointX < titleScrollCenterX){
        
        [self.scrollerView setContentOffset:CGPointMake(titleScrollContentWidth - self.scrollerView.frame.size.width, 0) animated:YES];
        
    } else if (pointX < titleScrollCenterX && titleScrollContentWidth - pointX > titleScrollCenterX){
        
        [self.scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - 改变选中频道的状态
- (void)transformStatusWithCurrentIndex:(NSInteger)currentIndex nextIndex:(NSInteger)nextIndex withRate:(CGFloat)rate{
    UILabel *currentLabel = [self.scrollerView viewWithTag:100 + currentIndex];
    //判断左右滑
    UILabel *nextLabel = [self.scrollerView viewWithTag:100 + nextIndex];
    if (nextLabel != nil) {
        NSInteger index_i = nextLabel.tag - currentLabel.tag;
        //通过拉伸label的x/y值来实现字体变大变小的即视效果
        currentLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity,index_i * -0.2 * rate + 1.2,index_i * -0.2 * rate + 1.2);
        nextLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, index_i * 0.2 * rate + 1.0, index_i * 0.2 * rate + 1.0);
        
        //改变字体颜色
        currentLabel.textColor = [UIColor colorWithRed:(index_i * (NormalColorRed-CurrentColorRed) * rate + CurrentColorRed) green:(index_i * (NormalColorGreen-CurrentColorGreen) * rate + CurrentColorGreen) blue:(index_i * (NormalColorBlue-CurrentColorBlue) * rate + CurrentColorBlue) alpha:1.0];
        
        nextLabel.textColor = [UIColor colorWithRed:(index_i * (CurrentColorRed-NormalColorRed) * rate + NormalColorRed) green:(index_i * (CurrentColorGreen-NormalColorGreen) * rate + NormalColorGreen) blue:(index_i * (CurrentColorBlue-NormalColorBlue) * rate + NormalColorBlue) alpha:1.0];
        
    }
}

#pragma mark - 添加频道
- (void)addChannel{
    if ([self.jkDelegate respondsToSelector:@selector(JKNewsChannelsView:didSelectedAddNewsChannelButton:)]) {
        [self.jkDelegate JKNewsChannelsView:self didSelectedAddNewsChannelButton:YES];
    }
}


- (void)selectNewsChannelsItemWithIndex:(NSInteger)index{
    UILabel *currentLabel = [self.scrollerView viewWithTag:100 + index];
    [self selectedNewsChannelsItem:currentLabel.gestureRecognizers.firstObject];
}

@end
