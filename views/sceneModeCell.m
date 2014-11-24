//
//  sceneModeCell.m
//  bleLED
//
//  Created by Monster on 14-11-22.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "sceneModeCell.h"

@implementation sceneModeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)openButtonTouch:(UIButton *)sender {
    
    sender.selected = (!sender.selected)?(YES):(NO);
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sceneModeCellOpen:)]) {
        [self.delegate sceneModeCellOpen:sender.selected];
    }
}
@end
