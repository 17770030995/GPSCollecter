//
//  RecordView.m
//  GPSCllector
//
//  Created by 图软 on 2017/9/13.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "RecordView.h"

@implementation RecordView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
        UIView * headerView = [[UIView alloc]init];
        headerView.backgroundColor = MAINHEADERCOLOR;
        [self addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@64);
        }];
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:17];
        _titleLb.text = @"维修记录";
        _titleLb.textColor = UIColorFromRGB(0xffffff);
        _titleLb.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_top).offset(27);
            make.centerX.equalTo(headerView.mas_centerX);
            make.width.equalTo(@150);
            make.height.equalTo(@30);
        }];
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateSelected];
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [headerView addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLb.mas_top);
            make.height.equalTo(_titleLb.mas_height);
            make.left.equalTo(headerView.mas_left).offset(12);
            make.width.equalTo(@40);
        }];
        
        _tableView = [[UITableView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _tableView.bounces = NO;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_bottom);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        
    }
    return self;
}

@end
