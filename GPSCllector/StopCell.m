//
//  StopCell.m
//  GPSCllector
//
//  Created by 图软 on 16/8/30.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import "StopCell.h"

@implementation StopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        UIImage *image1 = [UIImage imageNamed:@"未点击"];
        STOPBUTTONMAKE(_outBtn, image1);
        [self.contentView addSubview:_outBtn];
        [_outBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.height.equalTo(@30);
            make.width.equalTo(@30);
        }];
        _outLb = [[UILabel alloc]init];
        _outLb.font = MAINPLACEFONT(12);
        _outLb.textAlignment = NSTextAlignmentRight;
        _outLb.textColor = UIColorFromRGB(0x333333);
        _outLb.text = @"出站";
        [self.contentView addSubview:_outLb];
        [_outLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_outBtn.mas_top);
            make.right.equalTo(_outBtn.mas_left);
            make.height.equalTo(_outBtn.mas_height);
            make.width.equalTo(_outBtn.mas_width);
        }];
        UIImage *im = [UIImage imageNamed:@"未点击"];
        STOPBUTTONMAKE(_inBtn, im);
        [self.contentView addSubview:_inBtn];
        [_inBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_outBtn.mas_top);
            make.right.equalTo(_outLb.mas_left).offset(-10);
            make.height.equalTo(_outBtn.mas_height);
            make.width.equalTo(_outBtn.mas_width);
        }];
        _intLb = [[UILabel alloc]init];
        _intLb.font = MAINPLACEFONT(12);
        _intLb.textColor = UIColorFromRGB(0x333333);
        _intLb.text = @"进站";
        [self.contentView addSubview:_intLb];
        [_intLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_inBtn.mas_top);
            make.right.equalTo(_inBtn.mas_left);
            make.height.equalTo(_outLb.mas_height);
            make.width.equalTo(_outLb.mas_width);
        }];
        _numAndNameAndGpsTimeLb = [[UILabel alloc]init];
        _numAndNameAndGpsTimeLb.font = MAINPLACEFONT(12);
        _numAndNameAndGpsTimeLb.textColor = STOPNAMECOLOR;
        [_numAndNameAndGpsTimeLb sizeToFit];
        [self.contentView addSubview:_numAndNameAndGpsTimeLb];
        [_numAndNameAndGpsTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.height.equalTo(@30);
            make.right.equalTo(_intLb.mas_left).offset(-20);
        }];
        
        
    }
    return self;
}




@end
