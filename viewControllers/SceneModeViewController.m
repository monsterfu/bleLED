//
//  SceneModeViewController.m
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "SceneModeViewController.h"

@interface SceneModeViewController ()

@end

@implementation SceneModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard* storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _emptyModeViewController = [storyBord instantiateViewControllerWithIdentifier:@"EmptyModeViewID"];
    [self.view addSubview:_emptyModeViewController.view];
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

@end
