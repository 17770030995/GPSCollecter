//
//  ViewController.h
//  GPSCllector
//
//  Created by 图软 on 16/8/27.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"
#import "MainTextField.h"
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    MainView *mainView;
}


@end

