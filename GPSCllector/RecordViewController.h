//
//  RecordViewController.h
//  GPSCllector
//
//  Created by 图软 on 2017/9/13.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordView.h"

@interface RecordViewController : UIViewController
{
    RecordView *recordView;
}

@property (nonatomic, copy) NSString *deviceNum;//设备序列号

@end
