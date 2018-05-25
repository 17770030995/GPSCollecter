//
//  MaintainOrderViewController.h
//  GPSCllector
//
//  Created by 图软 on 2017/8/31.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderView.h"
#import "LoginView.h"
#import "CodeDataView.h"
#import "AddDeviceDataView.h"

@interface MaintainOrderViewController : UIViewController
{
    OrderView *orderView;
    LoginView *loginView;
    CodeDataView *dataView;
    AddDeviceDataView *addView;
}

@end
