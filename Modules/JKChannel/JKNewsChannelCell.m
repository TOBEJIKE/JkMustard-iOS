//
//  JKNewsChannelCell.m
//  Chanel
//
//  Created by chinabyte on 2017/8/14.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "JKNewsChannelCell.h"
#import "JKNewsChannel.h"

const CGFloat DeleteViewWidth = 20;

@interface JKNewsChannelCell ()
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *textBtn;
@end

@implementation JKNewsChannelCell
- (UIButton *)textBtn{
    if (_textBtn == nil) {
        UIButton *textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        textBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [textBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        textBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        textBtn.backgroundColor = [UIColor whiteColor];
        textBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        textBtn.layer.borderWidth = 0.5;
        textBtn.layer.borderColor = [UIColor grayColor].CGColor;
        textBtn.clipsToBounds = NO;
        textBtn.enabled = NO;
        textBtn.layer.cornerRadius = 5;
        _textBtn = textBtn;
    }
    return _textBtn;
}

- (UIButton *)deleteBtn{
    if (_deleteBtn == nil) {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.backgroundColor = [UIColor grayColor];
        [deleteBtn setImage:[UIImage imageNamed:@"JKdelete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.hidden = YES;
        deleteBtn.layer.borderColor = [UIColor grayColor].CGColor;
        deleteBtn.layer.borderWidth = 0.5;
        deleteBtn.layer.masksToBounds = YES;
        deleteBtn.layer.cornerRadius = 10;
        [deleteBtn sizeToFit];
        _deleteBtn = deleteBtn;
    }
    return _deleteBtn;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat space = 5;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    self.textBtn.frame = CGRectMake(space, space, width-2*space, height-2*space);
    self.deleteBtn.frame = CGRectMake(width - DeleteViewWidth, 0, DeleteViewWidth, DeleteViewWidth);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.textBtn];
        [self.contentView addSubview:self.deleteBtn];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDeteleState:) name:@"NSNotification_NewsChannelEditing" object:nil];
    }
    return self;
}

- (void)setChannel:(JKNewsChannel *)channel{
    _channel = channel;
    [self.textBtn setTitle:channel.text forState:UIControlStateNormal];
    if ([channel.text isEqualToString:@"推荐"]) {
        [self.textBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.deleteBtn.hidden = YES;
    } else {
        [self.textBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        if (channel.canShowDeleteView && channel.showDeleteView) {
            self.deleteBtn.hidden = NO;
        } else {
            self.deleteBtn.hidden = YES;
        }
    }
}

- (void)deleteBtnClick{
    if ([self.jkDelegate respondsToSelector:@selector(JKNewsChannelCell:didClickDeleteBtn:)]) {
        [self.jkDelegate JKNewsChannelCell:self didClickDeleteBtn:YES];
    }
}

- (void)changeDeteleState:(NSNotification *)notification{
    BOOL editing = [notification.object boolValue];
    // 更新所有的删除按钮状态，上面的判断会有不明显的bug
    self.channel.showDeleteView = editing;
    if ([self.channel.text isEqualToString:@"推荐"]) {
        self.deleteBtn.hidden = YES;
    } else {
        if (self.channel.canShowDeleteView && self.channel.showDeleteView) {
            self.deleteBtn.hidden = NO;
        } else {
            self.deleteBtn.hidden = YES;
        }
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
