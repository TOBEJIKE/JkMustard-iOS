//
//  JKChannelHeaderView.m
//  Chanel
//
//  Created by chinabyte on 2017/8/14.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKChannelHeaderView.h"
#import "JKNewsChannelEdit.h"
#import "UIView+JKExtension.h"

#define CBFont(f) [UIFont systemFontOfSize:(f)]
const CGFloat editBtnW = 50; // 编辑按钮的宽度
const CGFloat editBtnH = 30; // 编辑按钮的宽度
const CGFloat kDefaultSpace = 10; // 默认间距为10

@interface JKChannelHeaderView ()
@property (nonatomic, weak) UILabel *channalView;
@property (nonatomic, weak) UILabel *promptView; // 提示view
@property (nonatomic, weak) UIButton *editBtn;
@end

@implementation JKChannelHeaderView

- (UIButton *)editBtn{
    if (!_editBtn) {
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitle:@"完成" forState:UIControlStateSelected];
        [editBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        editBtn.titleLabel.font = CBFont(15);
        editBtn.layer.borderColor = [UIColor redColor].CGColor;
        editBtn.layer.cornerRadius = 15;
        editBtn.layer.borderWidth = 0.5;
        [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:editBtn];
        _editBtn = editBtn;
        
    }
    return _editBtn;
}

- (UILabel *)channalView{
    if (!_channalView) {
        UILabel *channalView = [UILabel new];
        channalView.textColor = [UIColor blackColor];
        channalView.font = CBFont(17);
        [channalView sizeToFit];
        [self addSubview:channalView];
        _channalView = channalView;
    }
    return _channalView;
}


- (UILabel *)promptView{
    if (!_promptView) {
        UILabel *promptView = [UILabel new];
        promptView.textColor = [UIColor grayColor];
        promptView.font = CBFont(12);
        [promptView sizeToFit];
        [self addSubview:promptView];
        _promptView = promptView;
    }
    return _promptView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    self.channalView.jk_x = kDefaultSpace;
    self.channalView.jk_y = 0;
    self.channalView.jk_height = height;
    
    self.promptView.jk_x = CGRectGetMaxX(self.channalView.frame) + kDefaultSpace;
    self.promptView.jk_y = 0;
    self.promptView.jk_height = self.frame.size.height;
    
    
    self.editBtn.jk_x = width - kDefaultSpace - editBtnW;
    self.editBtn.jk_height = editBtnH;
    self.editBtn.jk_width = editBtnW;
    self.editBtn.jk_centerY = height/2.0;
    
}

- (void)editBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.channelEdit.isEditing = sender.selected; // 更新编辑状态
    self.promptView.text = self.channelEdit.isEditing?self.channelEdit.promptEditTitle:self.channelEdit.promptTitle; // 更新提示标题
    if ([self.jkDelegate respondsToSelector:@selector(JKChannelHeaderView:didClickEditButton:)]) {
        [self.jkDelegate JKChannelHeaderView:self didClickEditButton:self.channelEdit.isEditing];
    }
}

#pragma mark 重写属性赋值
- (void)setChannelEdit:(JKNewsChannelEdit *)channelEdit{
    _channelEdit = channelEdit;
    self.channalView.text = channelEdit.channalTitle;
    [self.channalView sizeToFit];
    self.editBtn.hidden = channelEdit.hideEditView;
    self.promptView.text = channelEdit.isEditing?channelEdit.promptEditTitle:channelEdit.promptTitle;
    [self.promptView sizeToFit];
    self.editBtn.selected = channelEdit.isEditing;
}


@end
