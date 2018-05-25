//
//  RecordCell.m
//  GPSCllector
//
//  Created by 图软 on 2017/9/13.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "RecordCell.h"

@implementation RecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        }];
        CGFloat width = (SCREEN_WIDTH - 20)/2.0;
        _orderId = [[UILabel alloc]init];
        _orderId.font = [UIFont systemFontOfSize:15];
        _orderId.textAlignment = NSTextAlignmentLeft;
        _orderId.textColor = UIColorFromRGB(0x2c2c2c);
        [contentView addSubview:_orderId];
        [_orderId mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(10);
            make.top.equalTo(contentView.mas_top).offset(10);
            make.width.equalTo(@(width));
            make.height.equalTo(@30);
        }];
        
        _vehNumLb = [[UILabel alloc]init];
        _vehNumLb.font = [UIFont systemFontOfSize:15];
        _vehNumLb.textAlignment = NSTextAlignmentLeft;
        _vehNumLb.textColor = UIColorFromRGB(0x2c2c2c);
        [contentView addSubview:_vehNumLb];
        [_vehNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_orderId.mas_right).offset(0);
            make.top.equalTo(_orderId.mas_top);
            make.right.equalTo(contentView.mas_right).offset(-10);;
            make.height.equalTo(@30);
        }];
        
        _reasonLb = [[UILabel alloc]init];
        _reasonLb.font = [UIFont systemFontOfSize:15];
        _reasonLb.textAlignment = NSTextAlignmentLeft;
        _reasonLb.textColor = UIColorFromRGB(0x2c2c2c);
        [contentView addSubview:_reasonLb];
        [_reasonLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(10);
            make.top.equalTo(_orderId.mas_bottom).offset(5);
            make.width.equalTo(@(width));
            make.height.equalTo(@30);
        }];
        
        _resultLb = [[UILabel alloc]init];
        _resultLb.font = [UIFont systemFontOfSize:15];
        _resultLb.textAlignment = NSTextAlignmentLeft;
        _resultLb.textColor = UIColorFromRGB(0x2c2c2c);
        [contentView addSubview:_resultLb];
        [_resultLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_reasonLb.mas_right).offset(0);
            make.top.equalTo(_reasonLb.mas_top);
            make.right.equalTo(contentView.mas_right).offset(-10);;
            make.height.equalTo(@30);
        }];
        
        _mateCost = [[UILabel alloc]init];
        _mateCost.font = [UIFont systemFontOfSize:15];
        _mateCost.textAlignment = NSTextAlignmentLeft;
        _mateCost.textColor = UIColorFromRGB(0x2c2c2c);
        [contentView addSubview:_mateCost];
        [_mateCost mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(10);
            make.top.equalTo(_reasonLb.mas_bottom).offset(5);
            make.width.equalTo(@(width));
            make.height.equalTo(@30);
        }];
        
        _maintCost = [[UILabel alloc]init];
        _maintCost.font = [UIFont systemFontOfSize:15];
        _maintCost.textAlignment = NSTextAlignmentLeft;
        _maintCost.textColor = UIColorFromRGB(0x2c2c2c);
        [contentView addSubview:_maintCost];
        [_maintCost mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_mateCost.mas_right).offset(0);
            make.top.equalTo(_mateCost.mas_top);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(@30);
        }];
        
        _engineerLb = [[UILabel alloc]init];
        _engineerLb.font = [UIFont systemFontOfSize:15];
        _engineerLb.textAlignment = NSTextAlignmentLeft;
        _engineerLb.textColor = UIColorFromRGB(0x2c2c2c);
        [contentView addSubview:_engineerLb];
        [_engineerLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(10);
            make.top.equalTo(_mateCost.mas_bottom).offset(5);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(@30);
        }];
        
        _timeLb = [[UILabel alloc]init];
        _timeLb.font = [UIFont systemFontOfSize:15];
        _timeLb.textAlignment = NSTextAlignmentLeft;
        _timeLb.textColor = UIColorFromRGB(0x2c2c2c);
        [contentView addSubview:_timeLb];
        [_timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(10);
            make.top.equalTo(_engineerLb.mas_bottom).offset(5);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(@30);
        }];
        
        _addressLb = [[UILabel alloc]init];
        _addressLb.font = [UIFont systemFontOfSize:15];
        _addressLb.textAlignment = NSTextAlignmentLeft;
        _addressLb.textColor = UIColorFromRGB(0x2c2c2c);
        _addressLb.numberOfLines = 0;
        [contentView addSubview:_addressLb];
        [_addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(10);
            make.top.equalTo(_timeLb.mas_bottom).offset(5);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(@60);
        }];
        
    }
    
    return self;
}

@end
