//
//  AddDeviceCell.h
//  GPSCllector
//
//  Created by 图软 on 2017/10/23.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLb;

@property (nonatomic, strong) UILabel *vehLb;

@property (nonatomic, strong) UILabel *troubleLb;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
