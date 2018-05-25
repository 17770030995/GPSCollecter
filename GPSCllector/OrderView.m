//
//  OrderView.m
//  GPSCllector
//
//  Created by 图软 on 2017/8/31.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "OrderView.h"

@implementation OrderView

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
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn setTitle:@"维修订单" forState:UIControlStateNormal];
        //[_chooseBtn setTitle:@"维修记录" forState:UIControlStateSelected];
        _chooseBtn.backgroundColor = [UIColor clearColor];
        [headerView addSubview:_chooseBtn];
        [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_top).offset(27);
            make.centerX.equalTo(headerView.mas_centerX).offset(-8);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        _arrowImg = [[UIImageView alloc]init];
        _arrowImg.image = [UIImage imageNamed:@"上下箭头"];
        [headerView addSubview:_arrowImg];
        [_arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_chooseBtn.mas_right);
            make.centerY.equalTo(_chooseBtn);
            make.height.width.equalTo(@16);
        }];
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateSelected];
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [headerView addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_chooseBtn.mas_top);
            make.height.equalTo(_chooseBtn.mas_height);
            make.left.equalTo(headerView.mas_left).offset(12);
            make.width.equalTo(@40);
        }];
        
        _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userBtn setImage:[UIImage imageNamed:@"用户"] forState:UIControlStateNormal];
        _userBtn.backgroundColor = [UIColor clearColor];
        _userBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [headerView addSubview:_userBtn];
        [_userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_chooseBtn.mas_top);
            make.height.equalTo(_chooseBtn.mas_height);
            make.right.equalTo(headerView.mas_right).offset(-12);
            make.width.equalTo(@40);
        }];
        
        _chooseView = [[UIView alloc]init];
        _chooseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_chooseView];
        [_chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@80);
        }];
        _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderBtn setBackgroundImage:CIWC(UIColorFromRGB(0xffffff)) forState:UIControlStateNormal];
        [_orderBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
        [_orderBtn setTitle:@"维修订单" forState:UIControlStateNormal];
        [_orderBtn setTitle:@"维修订单" forState:UIControlStateHighlighted];
        [_orderBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
        [_orderBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
        _orderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_chooseView addSubview:_orderBtn];
        [_orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_chooseView);
            make.height.equalTo(@40);
        }];
        
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setBackgroundImage:CIWC(UIColorFromRGB(0xffffff)) forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
        [_recordBtn setTitle:@"维修记录" forState:UIControlStateNormal];
        [_recordBtn setTitle:@"维修记录" forState:UIControlStateHighlighted];
        [_recordBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
        [_recordBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
        _recordBtn.layer.cornerRadius = 3;
        _recordBtn.layer.masksToBounds = YES;
        _recordBtn.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        _recordBtn.layer.borderWidth = 0.7;
        _recordBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_chooseView addSubview:_recordBtn];
        [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_chooseView);
            make.top.equalTo(_orderBtn.mas_bottom);
            make.height.equalTo(_orderBtn);
        }];
        _dateView = [[UIView alloc]init];
        _dateView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(headerView.mas_bottom);
            make.height.equalTo(@80);
        }];
        _startLb = [[UILabel alloc]init];
        _startLb.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        _startLb.layer.borderWidth = 0.7;
        _startLb.text = @"开始时间";
        _startLb.font = [UIFont systemFontOfSize:15];
        _startLb.textColor = UIColorFromRGB(0x777777);
        _startLb.textAlignment = NSTextAlignmentCenter;
        [_dateView addSubview:_startLb];
        [_startLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateView.mas_left).offset(20);
            make.right.equalTo(_dateView.mas_centerX).offset(-20);
            make.height.equalTo(@30);
            make.top.equalTo(_dateView.mas_top).offset(5);
        }];
        UIImageView *img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:@"时间箭头"];
        [_dateView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_startLb);
            make.centerX.equalTo(_dateView);
            make.width.height.equalTo(@20);
        }];
        
        _endLb = [[UILabel alloc]init];
        _endLb.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        _endLb.layer.borderWidth = 0.7;
        _endLb.text = @"结束时间";
        _endLb.font = [UIFont systemFontOfSize:15];
        _endLb.textColor = UIColorFromRGB(0x777777);
        _endLb.textAlignment = NSTextAlignmentCenter;
        [_dateView addSubview:_endLb];
        [_endLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateView.mas_centerX).offset(20);
            make.right.equalTo(_dateView.mas_right).offset(-20);
            make.height.equalTo(@30);
            make.top.equalTo(_dateView.mas_top).offset(5);
        }];
        
        _dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateBtn setBackgroundImage:CIWC(UIColorFromRGB(0xffffff)) forState:UIControlStateNormal];
        [_dateBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
        [_dateBtn setTitle:@"选择时间" forState:UIControlStateNormal];
        [_dateBtn setTitle:@"选择时间" forState:UIControlStateHighlighted];
        [_dateBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
        [_dateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
        _dateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _dateBtn.layer.cornerRadius = 3;
        _dateBtn.layer.masksToBounds = YES;
        _dateBtn.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        _dateBtn.layer.borderWidth = 0.7;
        [_dateView addSubview:_dateBtn];
        [_dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateView.mas_left).offset(20);
            make.top.equalTo(_dateView.mas_top).offset(45);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        
        _countLb = [[UILabel alloc]init];
        _countLb.text = @"";
        _countLb.font = [UIFont systemFontOfSize:14];
        _countLb.textColor = UIColorFromRGB(0xff643a);
        _countLb.textAlignment = NSTextAlignmentCenter;
        [_dateView addSubview:_countLb];
        [_countLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_dateView);
            make.centerY.equalTo(_dateBtn);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setBackgroundImage:CIWC(UIColorFromRGB(0xffffff)) forState:UIControlStateNormal];
        [_searchBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateHighlighted];
        [_searchBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
        [_searchBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
        _searchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _searchBtn.layer.cornerRadius = 3;
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
        _searchBtn.layer.borderWidth = 0.7;
        [_dateView addSubview:_searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_dateView.mas_right).offset(-20);
            make.top.equalTo(_dateView.mas_top).offset(45);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        _dateView.hidden = YES;
        
        _tableView = [[UITableView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _tableView.bounces = NO;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(64);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
    }
    return self;
}

@end
