//
//  RecordCell.h
//  GPSCllector
//
//  Created by 图软 on 2017/9/13.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell

@property (nonatomic, strong) UILabel *vehNumLb;

@property (nonatomic, strong) UILabel *engineerLb;

@property (nonatomic, strong) UILabel *orderId;

@property (nonatomic, strong) UILabel *reasonLb;

@property (nonatomic, strong) UILabel *resultLb;

@property (nonatomic, strong) UILabel *mateCost;

@property (nonatomic, strong) UILabel *maintCost;

@property (nonatomic, strong) UILabel *timeLb;

@property (nonatomic, strong) UILabel *addressLb;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
