//
//  DeviceColorSetViewController.m
//  bleLED
//
//  Created by Monster on 14-11-16.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "DeviceColorSetViewController.h"
#import "GlobalHeader.h"



@interface DeviceColorSetViewController ()

@end

@implementation DeviceColorSetViewController
@synthesize delegate;
@synthesize selectedColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *container = [[UIView alloc] initWithFrame: IS_IPAD ? CGRectMake(0, 0, 320, 460) :[[UIScreen mainScreen] applicationFrame]];
    container.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    container.backgroundColor = [UIColor clearColor];
    self.view = container;
    
    KZColorPicker *picker = [[KZColorPicker alloc] initWithFrame:container.bounds];
    picker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    picker.selectedColor = self.selectedColor;
    picker.oldColor = self.selectedColor;
    [picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:picker];
}
- (void)loadView
{
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) pickerChanged:(KZColorPicker *)cp
{
    self.selectedColor = cp.selectedColor;
    [delegate defaultColorController:self didChangeColor:cp.selectedColor];
}
@end
