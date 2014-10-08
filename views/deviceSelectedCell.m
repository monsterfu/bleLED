//
//  deviceSelectedCell.m
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "deviceSelectedCell.h"

@implementation deviceSelectedCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)seletedButtonTouch:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(deviceSelectedCellSelected:tag:)]) {
        [self.delegate deviceSelectedCellSelected:sender.selected tag:self.tag];
    }
    
}
@end
