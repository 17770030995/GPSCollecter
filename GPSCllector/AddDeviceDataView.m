//
//  AddDeviceDataView.m
//  GPSCllector
//
//  Created by 图软 on 2017/9/25.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "AddDeviceDataView.h"
#import "UILabel+Extension.h"

@implementation AddDeviceDataView
{
    UIScrollView *scrollView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = MAINHEADERCOLOR;
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(20);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@44);
        }];
        
        UILabel *titleLb = [UILabel labelWithFont:16 Text:@"设备序列号补录" Alignment:NSTextAlignmentCenter textColor:[UIColor whiteColor]];
        titleLb.font = [UIFont systemFontOfSize:17];
        [topView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView);
            make.centerX.equalTo(topView);
            make.height.equalTo(@30);
            make.width.equalTo(@150);
        }];
        
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateSelected];
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [topView addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLb.mas_top);
            make.height.equalTo(titleLb.mas_height);
            make.left.equalTo(topView.mas_left).offset(12);
            make.width.equalTo(@40);
        }];
        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(topView.mas_bottom);
        }];
        
        UILabel *list = [UILabel labelWithFont:15 Text:@"产品序列号:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:list];
        [list mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(scrollView.mas_top).offset(20);
        }];
        
        _listNumLb = [UILabel labelWithFont:15 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:_listNumLb];
        [_listNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(list.mas_right).offset(10);
            make.centerY.equalTo(list);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.equalTo(@30);
        }];
        
        UILabel *custname = [UILabel labelWithFont:15 Text:@"客户名:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:custname];
        [custname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(list.mas_bottom).offset(10);
        }];
        
        _customerLb = [UILabel labelWithFont:15 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:_customerLb];
        [_customerLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(custname.mas_right).offset(10);
            make.centerY.equalTo(custname);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.equalTo(@30);
        }];
    
        
        UILabel *vehicle = [UILabel labelWithFont:15 Text:@"车牌号:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:vehicle];
        [vehicle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(custname.mas_bottom).offset(10);
        }];
        
        _vehNumTf = [[MainTextField alloc]init];
        _vehNumTf.layer.cornerRadius = 2;
        _vehNumTf.layer.masksToBounds = YES;
        _vehNumTf.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _vehNumTf.layer.borderWidth = 1;
        [scrollView addSubview:_vehNumTf];
        [_vehNumTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(vehicle);
            make.left.equalTo(vehicle.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@30);
        }];
        
        UILabel *deviceName = [UILabel labelWithFont:15 Text:@"产品名:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:deviceName];
        [deviceName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(vehicle.mas_bottom).offset(10);
        }];
        _nameTf = [[MainTextField alloc]init];
        _nameTf.layer.cornerRadius = 2;
        _nameTf.layer.masksToBounds = YES;
        _nameTf.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _nameTf.layer.borderWidth = 1;
        [scrollView addSubview:_nameTf];
        [_nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(deviceName);
            make.left.equalTo(deviceName.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@30);
        }];
        
        UILabel *type = [UILabel labelWithFont:15 Text:@"产品类型:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:type];
        [type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(deviceName.mas_bottom).offset(10);
        }];
        _typeTf = [[MainTextField alloc]init];
        _typeTf.layer.cornerRadius = 2;
        _typeTf.layer.masksToBounds = YES;
        _typeTf.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _typeTf.layer.borderWidth = 1;
        [scrollView addSubview:_typeTf];
        [_typeTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(type);
            make.left.equalTo(type.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@30);
        }];
        
        UILabel *text = [UILabel labelWithFont:15 Text:@"备注(选填):" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(type.mas_bottom).offset(10);
        }];
        _textTf = [[MainTextField alloc]init];
        _textTf.layer.cornerRadius = 2;
        _textTf.layer.masksToBounds = YES;
        _textTf.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _textTf.layer.borderWidth = 1;
        [scrollView addSubview:_textTf];
        [_textTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(text);
            make.left.equalTo(text.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@30);
        }];
        
        
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setBackgroundImage:CIWC(UIColorFromRGB(0xe3e3e3)) forState:UIControlStateNormal];
        [_submitBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
        [_submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:UIColorFromRGB(0x2c2c2c) forState:UIControlStateNormal];
        [_submitBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _submitBtn.layer.cornerRadius = 17;
        _submitBtn.layer.masksToBounds = YES;
        [scrollView addSubview:_submitBtn];
        [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.centerX.equalTo(self);
            make.height.equalTo(@34);
            make.top.equalTo(text.mas_bottom).offset(40);
        }];
        
        [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_submitBtn.mas_bottom).offset(40);
        }];
        
    }
    return self;
}

@end
