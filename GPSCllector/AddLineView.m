//
//  AddLineView.m
//  GPSCllector
//
//  Created by 图软 on 16/8/27.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import "AddLineView.h"

@implementation AddLineView

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
            make.height.equalTo(@64);
        }];
        _titleLb = [[UILabel alloc]init];
        _titleLb.font = [UIFont systemFontOfSize:17];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = UIColorFromRGB(0xffffff);
        [_headerView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_top).offset(27);
            make.centerX.equalTo(_headerView.mas_centerX);
            make.width.equalTo(@150);
            make.height.equalTo(@30);
        }];
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateSelected];
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [_headerView addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLb.mas_top);
            make.height.equalTo(_titleLb.mas_height);
            make.left.equalTo(_headerView.mas_left).offset(12);
            make.width.equalTo(@40);
        }];
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.titleLabel.textColor = [UIColor whiteColor];
        [_saveBtn setTitle:@"插入" forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_saveBtn setBackgroundColor:MAINHEADERCOLOR];
        [_saveBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self addSubview:_saveBtn];
        [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_bottom).offset(25);
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.equalTo(@55);
            make.height.equalTo(@40);
        }];
        UIView *bgView = [[UIView alloc]init];
        bgView.layer.borderWidth = 1;
        bgView.layer.borderColor = MAINHEADERCOLOR.CGColor;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_bottom).offset(25);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(_saveBtn.mas_left);
            make.height.equalTo(@40);
        }];
        _inputTF = [[MainTextField alloc]init];
        _inputTF.placeholder = @"输入站点名";
        [bgView addSubview:_inputTF];
        [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top);
            make.right.equalTo(bgView.mas_right);
            make.left.equalTo(bgView.mas_left);
            make.bottom.equalTo(bgView.mas_bottom);
        }];
        _explainLb = [[UILabel alloc]init];
        _explainLb.font = MAINPLACEFONT(14);
        _explainLb.textColor = UIColorFromRGB(0x666666);
        [self addSubview:_explainLb];
        [_explainLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_bottom).offset(20);
            make.left.equalTo(bgView.mas_left);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.equalTo(@25);
        }];
        _greyBgView = [[UIView alloc]init];
        _greyBgView.backgroundColor = MAINGREYBACKCOLOR;
        [self addSubview:_greyBgView];
        [_greyBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_explainLb.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@40);
        }];
        _kindAndNumLb = [[UILabel alloc]init];
        _kindAndNumLb.font = MAINLINENAMEFONT(13);
        _kindAndNumLb.textColor = UIColorFromRGB(0x666666);
        [_greyBgView addSubview:_kindAndNumLb];
        [_kindAndNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_greyBgView.mas_top).offset(5);
            make.left.equalTo(_greyBgView.mas_left).offset(16);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.backgroundColor = [UIColor clearColor];
        [_changeBtn setImage:[UIImage imageNamed:@"切换"] forState:UIControlStateNormal];
        [_greyBgView addSubview:_changeBtn];
        [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_greyBgView.mas_top).offset(5);
            make.right.equalTo(_greyBgView.mas_right).offset(-15);
            make.width.equalTo(@40);
            make.height.equalTo(@30);
        }];
        _stopsTableView = [[UITableView alloc]init];
        _stopsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:_stopsTableView];
        [_stopsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_greyBgView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

@end
