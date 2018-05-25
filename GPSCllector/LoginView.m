//
//  LoginView.m
//  GPSCllector
//
//  Created by 图软 on 2017/8/31.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

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
            make.width.equalTo(@(SCREEN_WIDTH - 60));
            make.height.equalTo(@200);
        }];
        
        UILabel *titleLb = [[UILabel alloc]init];
        titleLb.text = @"OA办公系统";
        titleLb.font = MAINLINENAMEFONT(16);
        titleLb.textColor = [UIColor whiteColor];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.backgroundColor = MAINHEADERCOLOR;
        [contentView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(contentView);
            make.height.equalTo(@40);
        }];
        UILabel *name = [[UILabel alloc]init];
        name.text = @"用户名";
        name.font = [UIFont systemFontOfSize:15];
        name.textColor = UIColorFromRGB(0x555555);
        name.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(15);
            make.width.equalTo(@60);
            make.height.equalTo(@30);
            make.top.equalTo(titleLb.mas_bottom).offset(20);
        }];
        _username = [[MainTextField alloc]init];
        _username.layer.cornerRadius = 2;
        _username.layer.masksToBounds = YES;
        _username.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _username.layer.borderWidth = 1;
        _username.textColor = UIColorFromRGB(0x555555);
        [contentView addSubview:_username];
        [_username mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(name.mas_right).offset(10);
            make.height.equalTo(@30);
            make.centerY.equalTo(name);
            make.right.equalTo(contentView.mas_right).offset(-15);
        }];
        
        UILabel *pass = [[UILabel alloc]init];
        pass.text = @"密码";
        pass.font = [UIFont systemFontOfSize:15];
        pass.textColor = UIColorFromRGB(0x555555);
        pass.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:pass];
        [pass mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(15);
            make.width.equalTo(@60);
            make.height.equalTo(@30);
            make.top.equalTo(name.mas_bottom).offset(20);
        }];
        _password = [[MainTextField alloc]init];
        _password .layer.cornerRadius = 2;
        _password.secureTextEntry = YES;
        _password .layer.masksToBounds = YES;
        _password .layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _password .layer.borderWidth = 1;
        _password.textColor = UIColorFromRGB(0x555555);
        [contentView addSubview:_password ];
        [_password  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(pass.mas_right).offset(10);
            make.height.equalTo(@30);
            make.centerY.equalTo(pass);
            make.right.equalTo(contentView.mas_right).offset(-15);
        }];
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setBackgroundImage:CIWC(UIColorFromRGB(0xe3e3e3)) forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
        [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [_loginBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _loginBtn.layer.cornerRadius = 15;
        _loginBtn.layer.masksToBounds = YES;
        [contentView addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(pass.mas_bottom).offset(20);
            make.centerX.equalTo(contentView);
            make.height.equalTo(@30);
            make.left.equalTo(contentView.mas_left).offset(30);
        }];
    }
    return self;
}

@end
