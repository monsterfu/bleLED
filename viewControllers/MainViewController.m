//
//  MainViewController.m
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (IBAction)searchButtonTouch:(UIBarButtonItem *)sender {
    NSLog(@"ss");
    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_hud];
    _hud.delegate = self;
    _hud.labelText = @"Ble设备搜索中..";
    _hud.square = YES;
    [_hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

-(void)viewDidLoad
{
    UIStoryboard* storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _emptyViewController = [storyBord instantiateViewControllerWithIdentifier:@"EmptyOneViewID"];
    [self.view addSubview:_emptyViewController.view];
    
    UIView* _eView = [UIView new];
    [_eView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:_eView];
}


- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    [[ConnectionManager sharedInstance]startScanForDevice];
    [[ConnectionManager sharedInstance] setDelegate:self];
    sleep(4);
    _deviceArray = [ConnectionManager sharedInstance].existDeviceArray;
    [_tableView reloadData];
    if (_deviceArray.count) {
        [_emptyViewController.view setHidden:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"deviceSettingIdentifier"]) {
        _deviceSettingViewController = (DeviceSettingViewController*)segue.destinationViewController;
        _deviceSettingViewController.device = (oneLedDeviceObject*)sender;
    }
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [_hud removeFromSuperview];
    _hud = nil;
}
#pragma mark -
#pragma mark UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [[ConnectionManager sharedInstance]removeDevice:[addedDeviceArray objectAtIndex:indexPath.row]];
//        [addedDeviceArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        [USER_DEFAULT removeObjectForKey:KEY_DEVICELIST_INFO];
//        NSData* aDate = [NSKeyedArchiver archivedDataWithRootObject:addedDeviceArray];
//        [USER_DEFAULT setObject:aDate forKey:KEY_DEVICELIST_INFO];
//        [USER_DEFAULT synchronize];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_deviceArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"deviceListIdentifier" forIndexPath:indexPath];
    _device = [_deviceArray objectAtIndex:indexPath.row];
    _cell.nameLabel.text = _device.name;
    _cell.tag = indexPath.row;
    _cell.delegate = self;
    return _cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"deviceSettingIdentifier" sender:[_deviceArray objectAtIndex:indexPath.row]];
}
#pragma mark - 
#pragma mark deviceListCellDelegate
-(void)deviceListCellOpen:(BOOL)open tag:(NSUInteger)tag
{
    _device = [_deviceArray objectAtIndex:tag];
    [_device open:open];
}

#pragma mark -
#pragma mark ConnectionManagerDelegate
- (void) didDiscoverDevice:(oneLedDeviceObject*)device
{
    _deviceArray = [ConnectionManager sharedInstance].existDeviceArray;
    [_tableView reloadData];
}
- (void) didDisconnectWithDevice:(oneLedDeviceObject*)device
{
    
}
- (void) didConnectWithDevice:(oneLedDeviceObject*)device
{
    
}
@end
