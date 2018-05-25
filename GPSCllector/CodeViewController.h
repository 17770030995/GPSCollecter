//
//  CodeViewController.h
//  GPSCllector
//
//  Created by 图软 on 2017/8/31.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyBlockEmail2)(NSString *);
@interface CodeViewController : UIViewController

@property (nonatomic,copy)MyBlockEmail2 blockEmail2;

@end
