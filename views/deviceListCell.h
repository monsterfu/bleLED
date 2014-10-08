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
@end

@interface deviceListCell : UITableViewCell
{
    BOOL _open;
}

@property (weak, nonatomic)id<deviceListCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
- (IBAction)openButtonTouch:(UIButton *)sender;

@end
