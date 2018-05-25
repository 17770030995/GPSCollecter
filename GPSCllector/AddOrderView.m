//
//  AddOrderView.m
//  GPSCllector
//
//  Created by 图软 on 2017/10/23.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "AddOrderView.h"

@implementation AddOrderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xffffff);
        UIView * headerView = [[UIView alloc]init];
        headerView.backgroundColor = MAINHEADERCOLOR;
        [self addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@64);
        }];
        UILabel *titleLb = [[UILabel alloc]init];
        titleLb.font = [UIFont systemFontOfSize:17];
        titleLb.text = @"临时维修单";
        titleLb.textColor = UIColorFromRGB(0xffffff);
        titleLb.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
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
            make.top.equalTo(titleLb.mas_top);
            make.height.equalTo(titleLb.mas_height);
            make.left.equalTo(headerView.mas_left).offset(12);
            make.width.equalTo(@40);
        }];
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"提交" forState:UIControlStateNormal];
        _finishBtn.backgroundColor = [UIColor clearColor];
        _finishBtn.titleLabel.textColor = [UIColor whiteColor];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:_finishBtn];
        [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLb);
            make.height.equalTo(@40);
            make.right.equalTo(headerView.mas_right).offset(-12);
            make.width.equalTo(@40);
        }];
        
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_searchBtn setBackgroundImage:CIWC(UIColorFromRGB(0xeeeeee)) forState:UIControlStateNormal];
        [_searchBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
        [_searchBtn setTitle:@"搜 索" forState:UIControlStateNormal];
        [_searchBtn setTitle:@"搜 索" forState:UIControlStateHighlighted];
        [_searchBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_searchBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
        [self addSubview:_searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-8);
            make.top.equalTo(headerView.mas_bottom).offset(8);
            make.height.equalTo(@36);
            make.width.equalTo(@70);
        }];
        
        _customerTF = [[MainTextField alloc]init];
        _customerTF.placeholder = @"请输入客户名字关键字";
        _customerTF.layer.borderColor = MAINHEADERCOLOR.CGColor;
        _customerTF.layer.borderWidth = 0.7;
        [self addSubview:_customerTF];
        [_customerTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_bottom).offset(8);
            make.left.equalTo(self.mas_left).offset(8);
            make.right.equalTo(_searchBtn.mas_left).offset(0);
            make.height.equalTo(_searchBtn.mas_height);
        }];
        
        UILabel *connect = [[UILabel alloc]init];
        connect.textColor = UIColorFromRGB(0x777777);
        connect.text = @"联系人:";
        connect.textAlignment = NSTextAlignmentLeft;
        connect.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:connect];
        [connect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_customerTF.mas_left);
            make.top.equalTo(_customerTF.mas_bottom).offset(8);
            make.width.equalTo(@70);
            make.height.equalTo(@45);
        }];
        
        _connectLb = [[UILabel alloc]init];
        _connectLb.textColor = UIColorFromRGB(0x232323);
        _connectLb.textAlignment = NSTextAlignmentLeft;
        _connectLb.font = [UIFont systemFontOfSize:15];
        _connectLb.numberOfLines = 0;
        [self addSubview:_connectLb];
        [_connectLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(connect.mas_right);
            make.top.equalTo(_customerTF.mas_bottom).offset(8);
            make.right.equalTo(self.mas_right).offset(-8);
            make.height.equalTo(@45);
        }];
        
        _addDeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addDeviceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addDeviceBtn setBackgroundImage:CIWC(UIColorFromRGB(0xeeeeee)) forState:UIControlStateNormal];
        [_addDeviceBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
        [_addDeviceBtn setTitle:@"添加设备" forState:UIControlStateNormal];
        [_addDeviceBtn setTitle:@"添加设备" forState:UIControlStateHighlighted];
        [_addDeviceBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_addDeviceBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
        [self addSubview:_addDeviceBtn];
        [_addDeviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.top.equalTo(connect.mas_bottom).offset(20);
            make.width.equalTo(@80);
            make.height.equalTo(@35);
        }];
        
        UIView *tbHeadView = [[UIView alloc]init];
        tbHeadView.backgroundColor = MAINHEADERCOLOR;
        [self addSubview:tbHeadView];
        [tbHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.right.equalTo(self.mas_right).offset(-8);
            make.top.equalTo(_addDeviceBtn.mas_bottom).offset(10);
            make.height.equalTo(@40);
        }];
        CGFloat width = (SCREEN_WIDTH - 16)/3.0;
        UILabel *nameLb = [[UILabel alloc]init];
        nameLb.text = @"产品名称/型号";
        nameLb.textColor = UIColorFromRGB(0xffffff);
        nameLb.textAlignment = NSTextAlignmentCenter;
        nameLb.font = [UIFont systemFontOfSize:15];
        [tbHeadView addSubview:nameLb];
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(tbHeadView);
            make.width.equalTo(@(width));
        }];
        UILabel *vehLb = [[UILabel alloc]init];
        vehLb.text = @"车牌号/自编号";
        vehLb.textColor = UIColorFromRGB(0xffffff);
        vehLb.textAlignment = NSTextAlignmentCenter;
        vehLb.font = [UIFont systemFontOfSize:15];
        [tbHeadView addSubview:vehLb];
        [vehLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(tbHeadView);
            make.centerX.equalTo(tbHeadView.mas_centerX);
            make.width.equalTo(@(width));
        }];
        UILabel *troubleLb = [[UILabel alloc]init];
        troubleLb.text = @"故障描述";
        troubleLb.textColor = UIColorFromRGB(0xffffff);
        troubleLb.font = [UIFont systemFontOfSize:15];
        troubleLb.textAlignment = NSTextAlignmentCenter;
        [tbHeadView addSubview:troubleLb];
        [troubleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(tbHeadView);
            make.width.equalTo(@(width));
        }];
        
        _deviceTb = [[UITableView alloc]init];
        _deviceTb.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _deviceTb.separatorStyle = UITableViewCellSeparatorStyleNone;
        _deviceTb.showsVerticalScrollIndicator = NO;
        _deviceTb.bounces = NO;
        [self addSubview:_deviceTb];
        [_deviceTb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.top.equalTo(tbHeadView.mas_bottom);
            make.right.equalTo(self.mas_right).offset(-8);
            make.bottom.equalTo(self.mas_bottom).offset(-8);
        }];

        
        _customerTb = [[UITableView alloc]init];
        _customerTb.backgroundColor = UIColorFromRGB(0xffffff);
        _customerTb.separatorStyle = UITableViewCellSeparatorStyleNone;
        _customerTb.showsVerticalScrollIndicator = NO;
        _customerTb.bounces = NO;
        [self addSubview:_customerTb];
        [_customerTb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_customerTF.mas_left);
            make.right.equalTo(_searchBtn.mas_right);
            make.top.equalTo(_customerTF.mas_bottom);
            make.height.equalTo(@200);
        }];
        _customerTb.hidden = YES;
        
        
        
    }
    return self;
}

@end
