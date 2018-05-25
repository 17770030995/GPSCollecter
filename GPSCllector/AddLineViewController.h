//
//  AddLineViewController.h
//  GPSCllector
//
//  Created by 图软 on 16/8/27.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddLineView.h"
@interface AddLineViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    AddLineView *addLineView;
}

@property(nonatomic,copy)NSString *lineName;

@end
