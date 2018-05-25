//
//  AddDeviceView.m
//  GPSCllector
//
//  Created by 图软 on 2017/10/23.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "AddDeviceView.h"

@implementation AddDeviceView

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
        contentView.layer.cornerRadius = 5;
        contentView.layer.masksToBounds = YES;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_centerY).offset(-20);
            make.width.equalTo(@(SCREEN_WIDTH - 40));
            make.height.equalTo(@205);
        }];
        
        UILabel *titleLb = [[UILabel alloc]init];
        titleLb.text = @"设备信息填写";
        titleLb.font = MAINLINENAMEFONT(16);
        titleLb.textColor = [UIColor whiteColor];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.backgroundColor = MAINHEADERCOLOR;
        [contentView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(contentView);
            make.height.equalTo(@35);
        }];
        UILabel *name = [[UILabel alloc]init];
        name.text = @"产品名/型号";
        name.font = [UIFont systemFontOfSize:15];
        name.textColor = UIColorFromRGB(0x555555);
        name.textAlignment = NSTextAlignmentLeft;
        [contentView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(5);
            make.width.equalTo(@90);
            make.height.equalTo(@30);
            make.top.equalTo(titleLb.mas_bottom).offset(10);
        }];
        _nameTypeTf = [[MainTextField alloc]init];
        _nameTypeTf.layer.cornerRadius = 2;
        _nameTypeTf.layer.masksToBounds = YES;
        _nameTypeTf.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _nameTypeTf.layer.borderWidth = 1;
        _nameTypeTf.textColor = UIColorFromRGB(0x555555);
        [contentView addSubview:_nameTypeTf];
        [_nameTypeTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(name.mas_right);
            make.height.equalTo(@30);
            make.centerY.equalTo(name);
            make.right.equalTo(contentView.mas_right).offset(-10);
        }];
        
        UILabel *veh = [[UILabel alloc]init];
        veh.text = @"车牌/自编号";
        veh.font = [UIFont systemFontOfSize:15];
        veh.textColor = UIColorFromRGB(0x555555);
        veh.textAlignment = NSTextAlignmentLeft;
        [contentView addSubview:veh];
        [veh mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(5);
            make.width.equalTo(@90);
            make.height.equalTo(@30);
            make.top.equalTo(name.mas_bottom).offset(10);
        }];
        _vehicleTf = [[MainTextField alloc]init];
        _vehicleTf .layer.cornerRadius = 2;
        _vehicleTf .layer.masksToBounds = YES;
        _vehicleTf .layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _vehicleTf .layer.borderWidth = 1;
        _vehicleTf.textColor = UIColorFromRGB(0x555555);
        [contentView addSubview:_vehicleTf];
        [_vehicleTf  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(veh.mas_right);
            make.height.equalTo(@30);
            make.centerY.equalTo(veh);
            make.right.equalTo(contentView.mas_right).offset(-10);
        }];
        
        UILabel *trouble = [[UILabel alloc]init];
        trouble.text = @"故障描述";
        trouble.font = [UIFont systemFontOfSize:15];
        trouble.textColor = UIColorFromRGB(0x555555);
        trouble.textAlignment = NSTextAlignmentLeft;
        [contentView addSubview:trouble];
        [trouble mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(5);
            make.width.equalTo(@90);
            make.height.equalTo(@30);
            make.top.equalTo(veh.mas_bottom).offset(10);
        }];
        
        _troubleTf = [[MainTextField alloc]init];
        _troubleTf .layer.cornerRadius = 2;
        _troubleTf .layer.masksToBounds = YES;
        _troubleTf .layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _troubleTf .layer.borderWidth = 1;
        _troubleTf.textColor = UIColorFromRGB(0x555555);
        [contentView addSubview:_troubleTf];
        [_troubleTf  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(trouble.mas_right);
            make.height.equalTo(@30);
            make.centerY.equalTo(trouble);
            make.right.equalTo(contentView.mas_right).offset(-10);
        }];
        
        _cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancalBtn setBackgroundImage:CIWC(UIColorFromRGB(0xe3e3e3)) forState:UIControlStateNormal];
        [_cancalBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
        [_cancalBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancalBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_cancalBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
        _cancalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [contentView addSubview:_cancalBtn];
        [_cancalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(trouble.mas_bottom).offset(10);
            make.left.equalTo(contentView.mas_left);
            make.height.equalTo(@40);
            make.right.equalTo(contentView.mas_centerX);
            
        }];
        
        
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setBackgroundImage:CIWC(UIColorFromRGB(0xe3e3e3)) forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
        [_sureBtn setTitle:@"确 认" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [contentView addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(trouble.mas_bottom).offset(10);
            make.right.equalTo(contentView.mas_right);
            make.height.equalTo(@40);
            make.left.equalTo(contentView.mas_centerX);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = MAINHEADERCOLOR;
        [contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cancalBtn.mas_right);
            make.centerY.equalTo(_cancalBtn);
            make.width.equalTo(@1);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

@end
