//
//  AddOrderViewController.h
//  GPSCllector
//
//  Created by 图软 on 2017/10/23.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddOrderView.h"
#import "AddDeviceView.h"
#import "ConnectDataView.h"

@interface AddOrderViewController : UIViewController
{
    AddOrderView *addOrderView;
    AddDeviceView *addDeviceView;
    ConnectDataView *connectView;
}

@end
