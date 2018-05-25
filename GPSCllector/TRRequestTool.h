//
//  TRRequestTool.h
//  GPSCllector
//
//  Created by 图软 on 2017/9/25.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRRequestTool : NSObject

+(TRRequestTool *)shareManager;

-(void)DataUrl:(NSString *)url withParameters:(NSDictionary *)parameters result:(void(^)(id data,NSError *error))cb;

@end
