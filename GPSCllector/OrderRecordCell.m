//
//  OrderRecordCell.m
//  GPSCllector
//
//  Created by 图软 on 2017/10/13.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "OrderRecordCell.h"
#import "UILabel+Extension.h"

@implementation OrderRecordCell

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
        UIView *topView = [[UIView alloc]initWithFrame:CGRectZero];
        topView.backgroundColor = UIColorFromRGB(0xffffff);
        [contentView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(contentView);
            make.height.equalTo(@40);
        }];
        
        _orderNumLb = [UILabel labelWithFont:16 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x000000)];
        [topView addSubview:_orderNumLb];
        [_orderNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView.mas_left).offset(10);
            make.centerY.equalTo(topView);
            make.width.equalTo(@(SCREEN_WIDTH/3.0));
            make.height.equalTo(@30);
        }];
        
        _dateLb = [UILabel labelWithFont:15 Text:@"" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x888888)];
        [topView addSubview:_dateLb];
        [_dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView.mas_centerY);
            make.right.equalTo(topView.mas_right).offset(-10);
            make.width.equalTo(@(SCREEN_WIDTH/3.0));
            make.height.equalTo(@30);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [topView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(topView.mas_bottom);
            make.height.equalTo(@1);
            make.left.right.equalTo(topView);
        }];
        
        UILabel *lb1 = [UILabel labelWithFont:14 Text:@"客        户:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x888888)];
        [contentView addSubview:lb1];
        [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left);
            make.top.equalTo(topView.mas_bottom);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        _clientLb = [UILabel labelWithFont:14 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x000000)];
        [contentView addSubview:_clientLb];
        [_clientLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb1.mas_right).offset(10);
            make.centerY.equalTo(lb1);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(@30);
        }];
        
        UILabel *lb2 = [UILabel labelWithFont:14 Text:@"联  系  人:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x888888)];
        [contentView addSubview:lb2];
        [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left);
            make.top.equalTo(lb1.mas_bottom);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        _linkmanLb = [UILabel labelWithFont:14 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x000000)];
        [contentView addSubview:_linkmanLb];
        [_linkmanLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb2.mas_right).offset(10);
            make.centerY.equalTo(lb2);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(@30);
        }];
        
        UILabel *lb3 = [UILabel labelWithFont:14 Text:@"联系方式:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x888888)];
        [contentView addSubview:lb3];
        [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left);
            make.top.equalTo(lb2.mas_bottom);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        _phoneLb = [UILabel labelWithFont:14 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x000000)];
        [contentView addSubview:_phoneLb];
        [_phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb3.mas_right).offset(10);
            make.centerY.equalTo(lb3);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(@30);
        }];
        
        UILabel *lb4 = [UILabel labelWithFont:14 Text:@"维修地点:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x888888)];
        [contentView addSubview:lb4];
        [lb4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left);
            make.top.equalTo(lb3.mas_bottom);
            make.width.equalTo(@80);
            make.height.equalTo(@60);
        }];
        _addressLb = [UILabel labelWithFont:14 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x000000)];
        _addressLb.numberOfLines = 0;
        [contentView addSubview:_addressLb];
        [_addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb4.mas_right).offset(10);
            make.centerY.equalTo(lb4);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(@60);
        }];
        
    }
    
    return self;
}

@end
