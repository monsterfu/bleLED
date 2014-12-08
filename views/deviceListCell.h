//
//  deviceListCell.h
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deviceListCellDelegate <NSObject>
-(void)deviceListCellOpen:(BOOL)open tag:(NSUInteger)tag;
-(void)deviceListSetDeviceName:(NSString*)name tag:(NSUInteger)tag;
@end

@interface deviceListCell : UITableViewCell <UITextFieldDelegate>
{
    BOOL _open;
    UILongPressGestureRecognizer* _longPressGestureRecognizer;
}

@property (weak, nonatomic)id<deviceListCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
- (IBAction)openButtonTouch:(UIButton *)sender;

@end
