//
//  CodeDataView.m
//  GPSCllector
//
//  Created by 图软 on 2017/9/1.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "CodeDataView.h"
#import "UILabel+Extension.h"

@implementation CodeDataView
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
        
        UILabel *titleLb = [UILabel labelWithFont:16 Text:@"具体维修情况" Alignment:NSTextAlignmentCenter textColor:[UIColor whiteColor]];
        titleLb.font = [UIFont systemFontOfSize:17];
        [topView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView);
            make.left.equalTo(topView.mas_left).offset(60);
            make.height.equalTo(@30);
            make.width.equalTo(@150);
        }];
        
        MAKEBUTTON(_recordBtn, @"维修记录");
        [_recordBtn setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
        [topView addSubview:_recordBtn];
        [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLb);
            make.right.equalTo(topView.mas_right).offset(-15);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
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
        
        UILabel *name = [UILabel labelWithFont:15 Text:@"产品名:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(scrollView.mas_top).offset(20);
        }];
        
        _deviceNameLb = [UILabel labelWithFont:15 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:_deviceNameLb];
        [_deviceNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(name.mas_right).offset(10);
            make.centerY.equalTo(name);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.equalTo(@30);
        }];
        
        UILabel *list = [UILabel labelWithFont:15 Text:@"产品序列号:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:list];
        [list mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(name.mas_bottom).offset(10);
        }];
        
        _listNumLb = [UILabel labelWithFont:15 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:_listNumLb];
        [_listNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(list.mas_right).offset(10);
            make.centerY.equalTo(list);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.equalTo(@30);
        }];
        
        UILabel *date = [UILabel labelWithFont:15 Text:@"生产日期:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:date];
        [date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(list.mas_bottom).offset(10);
        }];
        
        _dateLb = [UILabel labelWithFont:15 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:_dateLb];
        [_dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(date.mas_right).offset(10);
            make.centerY.equalTo(date);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.equalTo(@30);
        }];
        
        UILabel *vehicle = [UILabel labelWithFont:15 Text:@"车牌号:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:vehicle];
        [vehicle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(date.mas_bottom).offset(10);
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
        
        UILabel *reason = [UILabel labelWithFont:15 Text:@"故障原因:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:reason];
        [reason mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(vehicle.mas_bottom).offset(10);
        }];
        _reasonTf = [[MainTextField alloc]init];
        _reasonTf.layer.cornerRadius = 2;
        _reasonTf.layer.masksToBounds = YES;
        _reasonTf.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _reasonTf.layer.borderWidth = 1;
        [scrollView addSubview:_reasonTf];
        [_reasonTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(reason);
            make.left.equalTo(reason.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@30);
        }];
        
        UILabel *result = [UILabel labelWithFont:15 Text:@"维修结果:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:result];
        [result mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(reason.mas_bottom).offset(10);
        }];
        _resultTf = [[MainTextField alloc]init];
        _resultTf.layer.cornerRadius = 2;
        _resultTf.layer.masksToBounds = YES;
        _resultTf.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _resultTf.layer.borderWidth = 1;
        [scrollView addSubview:_resultTf];
        [_resultTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(result);
            make.left.equalTo(result.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@30);
        }];
        
        UILabel *material = [UILabel labelWithFont:15 Text:@"材料费:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:material];
        [material mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(result.mas_bottom).offset(10);
        }];
        _mateCostTf = [[MainTextField alloc]init];
        _mateCostTf.layer.cornerRadius = 2;
        _mateCostTf.layer.masksToBounds = YES;
        _mateCostTf.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _mateCostTf.layer.borderWidth = 1;
        [scrollView addSubview:_mateCostTf];
        [_mateCostTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(material);
            make.left.equalTo(material.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@30);
        }];
        
        UILabel *maint = [UILabel labelWithFont:15 Text:@"维修费:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x2c2c2c)];
        [scrollView addSubview:maint];
        [maint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(0);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
            make.top.equalTo(material.mas_bottom).offset(10);
        }];
        
        _maintCostTf = [[MainTextField alloc]init];
        _maintCostTf.layer.cornerRadius = 2;
        _maintCostTf.layer.masksToBounds = YES;
        _maintCostTf.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
        _maintCostTf.layer.borderWidth = 1;
        [scrollView addSubview:_maintCostTf];
        [_maintCostTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(maint);
            make.left.equalTo(maint.mas_right).offset(10);
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
            make.top.equalTo(maint.mas_bottom).offset(40);
        }];
        
        [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_submitBtn.mas_bottom).offset(40);
        }];
        
    }
    return self;
}

@end
