//
//  ProductCell.h
//  GPSCllector
//
//  Created by 图软 on 2017/9/19.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLb;

@property (nonatomic, strong) UILabel *vehcodeLb;

@property (nonatomic, strong) UILabel *reasonLb;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
