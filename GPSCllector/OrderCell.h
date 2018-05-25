//
//  OrderCell.h
//  GPSCllector
//
//  Created by 图软 on 2017/8/31.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell

@property (nonatomic, strong) UILabel *orderNumLb;
@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) UILabel *clientLb;
@property (nonatomic, strong) UILabel *linkmanLb;
@property (nonatomic, strong) UILabel *phoneLb;
@property (nonatomic, strong) UILabel *addressLb;
@property (nonatomic, strong) UIButton *codeBtn;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
