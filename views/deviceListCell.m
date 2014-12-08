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
    
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressAction)];
    [self addGestureRecognizer:_longPressGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)longpressAction
{
    _nameLabel.enabled = YES;
    [_nameLabel becomeFirstResponder];
    _nameLabel.delegate = self;
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

#pragma mark --
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSData* nameData = [textField.text dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger len = nameData.length;
    
    if (len >= 12) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _nameLabel.enabled = NO;
    if (self.delegate&& [self.delegate respondsToSelector:@selector(deviceListSetDeviceName:tag:)]) {
        [self.delegate deviceListSetDeviceName:textField.text tag:self.tag];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
