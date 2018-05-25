//
//  AddLineView.h
//  GPSCllector
//
//  Created by 图软 on 16/8/27.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTextField.h"
@interface AddLineView : UIView

@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)MainTextField *inputTF;
@property(nonatomic,strong)UIButton *saveBtn;
@property(nonatomic,strong)UILabel *explainLb;
@property(nonatomic,strong)UIView *greyBgView;
@property(nonatomic,strong)UILabel *kindAndNumLb;
@property(nonatomic,strong)UIButton *changeBtn;
@property(nonatomic,strong)UITableView *stopsTableView;


@end
