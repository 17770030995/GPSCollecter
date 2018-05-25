//
//  MainView.m
//  GPSCllector
//
//  Created by 图软 on 16/8/27.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import "MainView.h"

@implementation MainView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = MAINHEADERCOLOR;
        [self addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@70);
        }];
        _lineNameLb = [[UILabel alloc]init];
        _lineNameLb.text = @"线路名";
        _lineNameLb.font = [UIFont systemFontOfSize:24];
        _lineNameLb.textColor = [UIColor whiteColor];
        [_headerView addSubview:_lineNameLb];
        [_lineNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_top).offset(30);
            make.left.equalTo(_headerView.mas_left).offset(20);
            make.height.equalTo(@40);
            make.width.equalTo(@150);
        }];
        _addLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView addSubview:_addLineBtn];
        [_addLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_top).offset(30);
            make.height.with.equalTo(@40);
            make.right.equalTo(_headerView.mas_right).offset(-20);
        }];
        
        UIImageView *addLineImg = [[UIImageView alloc]init];
        addLineImg.image = [UIImage imageNamed:@"编辑"];
        [_addLineBtn addSubview:addLineImg];
        [addLineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addLineBtn.mas_top);
            make.centerX.equalTo(_addLineBtn);
            make.width.height.equalTo(@20);
        }];
        
        UILabel *addLineLb = [[UILabel alloc]init];
        addLineLb.textColor = UIColorFromRGB(0xffffff);
        addLineLb.font = [UIFont systemFontOfSize:12];
        addLineLb.textAlignment = NSTextAlignmentCenter;
        addLineLb.text = @"编辑";
        [_addLineBtn addSubview:addLineLb];
        [addLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addLineBtn.mas_top).offset(20);
            make.left.right.bottom.equalTo(_addLineBtn);
        }];
        
        
        _lineListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView addSubview:_lineListBtn];
        [_lineListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_top).offset(30);
            make.height.with.equalTo(@40);
            make.right.equalTo(_addLineBtn.mas_left).offset(-20);
        }];
        
        UIImageView *lineListImg = [[UIImageView alloc]init];
        lineListImg.image = [UIImage imageNamed:@"线路"];
        [_lineListBtn addSubview:lineListImg];
        [lineListImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lineListBtn.mas_top);
            make.centerX.equalTo(_lineListBtn);
            make.width.height.equalTo(@20);
        }];
        
        UILabel *lineListLb = [[UILabel alloc]init];
        lineListLb.textColor = UIColorFromRGB(0xffffff);
        lineListLb.font = [UIFont systemFontOfSize:12];
        lineListLb.textAlignment = NSTextAlignmentCenter;
        lineListLb.text = @"线路";
        [_lineListBtn addSubview:lineListLb];
        [lineListLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lineListBtn.mas_top).offset(20);
            make.left.right.bottom.equalTo(_lineListBtn);
        }];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerView addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_top).offset(30);
            make.height.with.equalTo(@40);
            make.right.equalTo(_lineListBtn.mas_left).offset(-20);
        }];
        
        UIImageView *sendImg = [[UIImageView alloc]init];
        sendImg.image = [UIImage imageNamed:@"邮箱"];
        [_sendBtn addSubview:sendImg];
        [sendImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sendBtn.mas_top);
            make.centerX.equalTo(_sendBtn);
            make.width.height.equalTo(@20);
        }];
        
        UILabel *sendLb = [[UILabel alloc]init];
        sendLb.textColor = UIColorFromRGB(0xffffff);
        sendLb.font = [UIFont systemFontOfSize:12];
        sendLb.textAlignment = NSTextAlignmentCenter;
        sendLb.text = @"邮箱";
        [_sendBtn addSubview:sendLb];
        [sendLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sendBtn.mas_top).offset(20);
            make.left.right.bottom.equalTo(_sendBtn);
        }];
        
//        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_headerView addSubview:_loginBtn];
//        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_headerView.mas_top).offset(30);
//            make.height.with.equalTo(@40);
//            make.right.equalTo(_sendBtn.mas_left).offset(-20);
//        }];
//
//        UIImageView *loginImg = [[UIImageView alloc]init];
//        loginImg.image = [UIImage imageNamed:@"用户"];
//        [_loginBtn addSubview:loginImg];
//        [loginImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_loginBtn.mas_top);
//            make.centerX.equalTo(_loginBtn);
//            make.width.height.equalTo(@20);
//        }];
//
//        UILabel *loginLb = [[UILabel alloc]init];
//        loginLb.textColor = UIColorFromRGB(0xffffff);
//        loginLb.font = [UIFont systemFontOfSize:12];
//        loginLb.textAlignment = NSTextAlignmentCenter;
//        loginLb.text = @"用户";
//        [_loginBtn addSubview:loginLb];
//        [loginLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_loginBtn.mas_top).offset(20);
//            make.left.right.bottom.equalTo(_loginBtn);
//        }];
        
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = MAINHEADERCOLOR;
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@144);
        }];
        _whiteBgView = [[UIView alloc]init];
        _whiteBgView.layer.cornerRadius = 4;
        _whiteBgView.layer.masksToBounds = YES;
        _whiteBgView.backgroundColor = MAINLBBACKCOLOR;
        [backView addSubview:_whiteBgView];
        [_whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_top).offset(20);
            make.left.equalTo(backView.mas_left).offset(15);
            make.height.equalTo(@104);
            make.right.equalTo(backView.mas_right).offset(-15);
        }];
        _angleLb = [[UILabel alloc]init];
        _angleLb.text = @"方位角(速度大于10码时有效)";
        _angleLb.font = MAINPLACEFONT(14);
        _angleLb.textColor = UIColorFromRGB(0x666666);
        [_whiteBgView addSubview:_angleLb];
        [_angleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_whiteBgView.mas_top).offset(5);
            make.left.equalTo(_whiteBgView.mas_left).offset(5);
            make.height.equalTo(@30);
            make.right.equalTo(_whiteBgView.mas_right).offset(-5);
        }];
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = UIColorFromRGB(0xeeeeee);
        [_whiteBgView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_angleLb.mas_bottom);
            make.left.equalTo(_angleLb.mas_left);
            make.height.equalTo(@1);
            make.right.equalTo(_angleLb.mas_right);
        }];
        _latlngLb = [[UILabel alloc]init];
        _latlngLb.font = MAINPLACEFONT(14);
        _latlngLb.textColor = UIColorFromRGB(0x666666);
        [_whiteBgView addSubview:_latlngLb];
        [_latlngLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1.mas_bottom);
            make.left.equalTo(_angleLb.mas_left);
            make.right.equalTo(_angleLb.mas_right);
            make.height.equalTo(_angleLb.mas_height);
        }];
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = UIColorFromRGB(0xeeeeee);
        [_whiteBgView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_latlngLb.mas_bottom);
            make.left.equalTo(_latlngLb.mas_left);
            make.height.equalTo(@1);
            make.right.equalTo(_latlngLb.mas_right);
        }];
        _wayAndTimeLb = [[UILabel alloc]init];
        _wayAndTimeLb.font = MAINPLACEFONT(14);
        _wayAndTimeLb.textColor = UIColorFromRGB(0x666666);
        [_whiteBgView addSubview:_wayAndTimeLb];
        [_wayAndTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line2.mas_bottom);
            make.left.equalTo(_latlngLb.mas_left);
            make.right.equalTo(_latlngLb.mas_right);
            make.bottom.equalTo(_whiteBgView.mas_bottom);
        }];
        _greyBgVIew = [[UIView alloc]init];
        _greyBgVIew.backgroundColor = MAINGREYBACKCOLOR;
        [self addSubview:_greyBgVIew];
        [_greyBgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_bottom).offset(0);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@40);
        }];
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.backgroundColor = [UIColor clearColor];
        [_changeBtn setImage:[UIImage imageNamed:@"切换"] forState:UIControlStateNormal];
        [_greyBgVIew addSubview:_changeBtn];
        [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_greyBgVIew.mas_top).offset(5);
            make.right.equalTo(_greyBgVIew.mas_right).offset(-10);
            make.height.equalTo(@30);
            make.width.equalTo(@40);
        }];
        _kindAndNumLb = [[UILabel alloc]init];
        _kindAndNumLb.font = MAINPLACEFONT(13);
        _kindAndNumLb.textColor = UIColorFromRGB(0x777777);
        [_greyBgVIew addSubview:_kindAndNumLb];
        [_kindAndNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_greyBgVIew.mas_top).offset(5);
            make.left.equalTo(_greyBgVIew.mas_left).offset(10);
            make.height.equalTo(@30);
            make.right.equalTo(_changeBtn.mas_left).offset(-10);
        }];
        _stopsTableView = [[UITableView alloc]init];
        _stopsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:_stopsTableView];
        [_stopsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_greyBgVIew.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

@end
