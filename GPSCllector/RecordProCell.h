//
//  RecordProCell.h
//  GPSCllector
//
//  Created by 图软 on 2017/10/19.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordProCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLb;//设备名

@property (nonatomic, strong) UILabel *codeLb;//所属订单号

@property (nonatomic, strong) UILabel *vehcodeLb;//所在车想

@property (nonatomic, strong) UILabel *reasonLb;//上次维修原因

@property (nonatomic, strong) UILabel *resultLb;//上次维修结果

@property (nonatomic, strong) UILabel *mateCostLb;//材料费

@property (nonatomic, strong) UILabel *maintCostLb;//人工费


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
