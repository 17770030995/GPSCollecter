//
//  AddDeviceCell.m
//  GPSCllector
//
//  Created by 图软 on 2017/10/23.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "AddDeviceCell.h"

@implementation AddDeviceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        self.contentView.layer.borderColor = MAINHEADERCOLOR.CGColor;
        self.contentView.layer.borderWidth = 0.7;
        
        CGFloat width = (SCREEN_WIDTH - 16)/3.0;
        _nameLb = [[UILabel alloc]init];
        _nameLb.textColor = UIColorFromRGB(0x232323);
        _nameLb.backgroundColor = [UIColor clearColor];
        _nameLb.textAlignment = NSTextAlignmentCenter;
        _nameLb.font = [UIFont systemFontOfSize:14];
        _nameLb.numberOfLines = 0;
        [self.contentView addSubview:_nameLb];
        [_nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
            make.width.equalTo(@(width));
        }];
        
        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = MAINHEADERCOLOR;
        [self.contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLb.mas_right);
            make.top.bottom.equalTo(self.contentView);
            make.width.equalTo(@1);
        }];
        
        _vehLb = [[UILabel alloc]init];
        _vehLb.textColor = UIColorFromRGB(0x232323);
        _vehLb.backgroundColor = [UIColor clearColor];
        _vehLb.textAlignment = NSTextAlignmentCenter;
        _vehLb.font = [UIFont systemFontOfSize:14];
        _vehLb.numberOfLines = 0;
        [self.contentView addSubview:_vehLb];
        [_vehLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(@(width));
        }];
        
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = MAINHEADERCOLOR;
        [self.contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_vehLb.mas_right);
            make.top.bottom.equalTo(self.contentView);
            make.width.equalTo(@1);
        }];
        
        _troubleLb = [[UILabel alloc]init];
        _troubleLb.textColor = UIColorFromRGB(0x232323);
        _troubleLb.backgroundColor = [UIColor clearColor];
        _troubleLb.textAlignment = NSTextAlignmentCenter;
        _troubleLb.font = [UIFont systemFontOfSize:14];
        _troubleLb.numberOfLines = 0;
        [self.contentView addSubview:_troubleLb];
        [_troubleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.contentView);
            make.width.equalTo(@(width));
        }];
        
    }
    return self;
}

@end
