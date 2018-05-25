//
//  ProductCell.m
//  GPSCllector
//
//  Created by 图软 on 2017/9/19.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "ProductCell.h"
#import "UILabel+Extension.h"

@implementation ProductCell

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
        
        _nameLb = [UILabel labelWithFont:16 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x000000)];
        [topView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView.mas_left).offset(10);
            make.centerY.equalTo(topView);
            make.right.equalTo(topView.mas_right).offset(-10);
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
        
        UILabel *lb1 = [UILabel labelWithFont:14 Text:@"所在车辆:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x888888)];
        [contentView addSubview:lb1];
        [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left);
            make.top.equalTo(topView.mas_bottom);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        _vehcodeLb = [UILabel labelWithFont:14 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x000000)];
        [contentView addSubview:_vehcodeLb];
        [_vehcodeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb1.mas_right).offset(10);
            make.centerY.equalTo(lb1);
            make.right.equalTo(contentView.mas_right).offset(-80);
            make.height.equalTo(@30);
        }];
        
        UILabel *lb2 = [UILabel labelWithFont:14 Text:@"设备故障:" Alignment:NSTextAlignmentRight textColor:UIColorFromRGB(0x888888)];
        [contentView addSubview:lb2];
        [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left);
            make.top.equalTo(lb1.mas_bottom);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
        _reasonLb = [UILabel labelWithFont:14 Text:@"" Alignment:NSTextAlignmentLeft textColor:UIColorFromRGB(0x000000)];
        _reasonLb.numberOfLines = 0;
        [contentView addSubview:_reasonLb];
        [_reasonLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb2.mas_right).offset(10);
            make.top.equalTo(lb2);
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.height.equalTo(@30);
        }];
        
    }
    return self;
}
@end
