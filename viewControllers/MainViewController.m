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
    _hud.labelText = @"Ble设备搜索中";
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
    sleep(3);
    [_emptyViewController.view setHidden:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"deviceSettingIdentifier"]) {
        NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
        _deviceSettingViewController = (DeviceSettingViewController*)segue.destinationViewController;
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
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        if ([tableView numberOfRowsInSection:0] <= 1) {
//            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告",nil) message:NSLocalizedString(@"人员信息不可为空",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"好的",nil) otherButtonTitles:nil, nil];
//            [alertView show];
//            [tableView setEditing:NO animated:YES];
//            return;
//        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"deviceListIdentifier" forIndexPath:indexPath];
    _cell.nameLabel.text = [NSString stringWithFormat:@"device %ld",(long)indexPath.row];
    _cell.tag = indexPath.row;
    _cell.delegate = self;
    return _cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"deviceSettingIdentifier" sender:nil];
}
#pragma mark - 
#pragma mark deviceListCellDelegate
-(void)deviceListCellOpen:(BOOL)open tag:(NSUInteger)tag
{
    
}
@end
