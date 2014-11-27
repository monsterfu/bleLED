//
//  sceneModeCell.h
//  bleLED
//
//  Created by Monster on 14-11-22.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol sceneModeCellDelegate <NSObject>
-(void)sceneModeCellOpen:(BOOL)open tag:(NSUInteger)tag;
@end

@interface sceneModeCell : UITableViewCell

@property(nonatomic, assign)id<sceneModeCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)openButtonTouch:(UIButton *)sender;

@end
