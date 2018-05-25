//
//  StopCell.h
//  GPSCllector
//
//  Created by 图软 on 16/8/30.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface StopCell : UITableViewCell

@property(nonatomic,strong)UILabel *numAndNameAndGpsTimeLb;
@property(nonatomic,strong)UILabel *intLb;
@property(nonatomic,strong)UILabel *outLb;
@property(nonatomic,strong)UIButton *inBtn;
@property(nonatomic,strong)UIButton *outBtn;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
