//
//  ConnectDataView.m
//  GPSCllector
//
//  Created by 图软 on 2017/10/23.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "ConnectDataView.h"

@implementation ConnectDataView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 6;
        contentView.layer.masksToBounds = YES;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_centerY).offset(-20);
            make.width.equalTo(@(SCREEN_WIDTH - 50));
            make.height.equalTo(@195);
        }];
        
        UILabel *titleLb = [[UILabel alloc]init];
        titleLb.text = @"选择联系人";
        titleLb.font = MAINLINENAMEFONT(16);
        titleLb.textColor = [UIColor whiteColor];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.backgroundColor = MAINHEADERCOLOR;
        [contentView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(contentView);
            make.height.equalTo(@35);
        }];
        
        _connectTb = [[UITableView alloc]init];
        _connectTb.backgroundColor = UIColorFromRGB(0xffffff);
        _connectTb.separatorStyle = UITableViewCellSeparatorStyleNone;
        _connectTb.showsVerticalScrollIndicator = NO;
        _connectTb.bounces = NO;
        [contentView addSubview:_connectTb];
        [_connectTb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contentView);
            make.height.equalTo(@120);
            make.top.equalTo(titleLb.mas_bottom);
        }];
        
        _noConnectLb = [[UILabel alloc]init];
        _noConnectLb.text = @"暂无联系人及联系方式";
        _noConnectLb.textColor = UIColorFromRGB(0x232323);
        _noConnectLb.textAlignment = NSTextAlignmentCenter;
        _noConnectLb.font = [UIFont systemFontOfSize:15];
        [contentView addSubview:_noConnectLb];
        [_noConnectLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(contentView);
            make.left.equalTo(contentView.mas_left).offset(10);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(@40);
        }];
        _noConnectLb.hidden = YES;
        
        
        _hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hideBtn setBackgroundImage:CIWC(UIColorFromRGB(0xe3e3e3)) forState:UIControlStateNormal];
        [_hideBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
        [_hideBtn setTitle:@"取  消" forState:UIControlStateNormal];
        [_hideBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_hideBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
        _hideBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [contentView addSubview:_hideBtn];
        [_hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_connectTb.mas_bottom);
            make.left.right.equalTo(contentView);
            make.height.equalTo(@40);
        }];
        
    }
    return self;
}

@end
