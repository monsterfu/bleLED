//
//  PanelView.h
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSV.h"
#import "colorSetObject.h"

@protocol PanelViewDelegate <NSObject>
-(void)panelViewHSV:(HSVType)currentHSV;
@end

@interface PanelView : UIView
{
    NSTimer* _commondSendTimer;
}
@property(nonatomic, assign)id<PanelViewDelegate>delegate;
@property(nonatomic, retain)colorSetObject* colorset;
@property(nonatomic, retain)UIColor* centerColor;
@property (nonatomic) HSVType currentHSV;

//开启定时器采集
-(void)startTouchChangeColor:(CGFloat)time;
//关闭定时器采集
-(void)stopTouchChangeColor;
@end
