//
//  OrderRecordCell.h
//  GPSCllector
//
//  Created by 图软 on 2017/10/13.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderRecordCell : UITableViewCell

@property (nonatomic, strong) UILabel *orderNumLb;
@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) UILabel *clientLb;
@property (nonatomic, strong) UILabel *linkmanLb;
@property (nonatomic, strong) UILabel *phoneLb;
@property (nonatomic, strong) UILabel *addressLb;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
