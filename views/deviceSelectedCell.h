//
//  deviceSelectedCell.h
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deviceSelectedCellDelegate <NSObject>
-(void)deviceSelectedCellSelected:(BOOL)seleted tag:(NSUInteger)tag;
@end

@interface deviceSelectedCell : UITableViewCell

@property(weak, nonatomic)id<deviceSelectedCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
- (IBAction)seletedButtonTouch:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@end
