//
//  ProductsViewController.h
//  GPSCllector
//
//  Created by 图软 on 2017/9/19.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsViewController : UIViewController

@property (nonatomic, copy) NSArray *dataArr;//需要展示的数据
@property (nonatomic) BOOL isRecord;//是否为已维修好的设备(记录)

@end
