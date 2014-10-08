//
//  deviceListCell.m
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "deviceListCell.h"

@implementation deviceListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)openButtonTouch:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(deviceListCellOpen:tag:)]) {
        [self.delegate deviceListCellOpen:sender.selected tag:self.tag];
    }
}
@end
