//
//  CommonTabbarViewController.m
//  Mio
//
//  Created by 符鑫 on 14-8-27.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "CommonTabbarViewController.h"

@interface CommonTabbarViewController ()

@end

#define  TABBAR_HEIGHT   (62)

@implementation CommonTabbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillLayoutSubviews
{
//    CGRect oldframe = self.tabBar.frame;
//    oldframe.origin.y = DEVICE_HEIGHT - TABBAR_HEIGHT*2;
//    oldframe.size.height = TABBAR_HEIGHT*2;
//    
//    [self.tabBar setFrame:oldframe];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.tabBar setBackgroundColor:[UIColor getColor:@"AFE25B"]];
    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"sceneDetailIdentifier"]) {
        _sceneSettingViewController = (SceneSettingViewController*)[segue destinationViewController];
        _sceneSettingViewController.sceneArrayDeviceObj = (SceneArrayDeviceObject*)sender;
    }
}


@end
