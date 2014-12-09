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

-(void)viewDidAppear:(BOOL)animated
{
    for (_sceneArrayDeviceObject in _sceneArry) {
        for (_device in _sceneArrayDeviceObject.deviceArray) {
            _device.isSelected = YES;
            for (oneLedDeviceObject* _addDevice in [ConnectionManager sharedInstance].existDeviceArray) {
                if ([_addDevice.identifier isEqualToString:_device.identifier]) {
                    _addDevice.isSelected = YES;
                    _device.characteristic = _addDevice.characteristic;
                    _device.peripheral = _addDevice.peripheral;
                }
            }
        }
    }
    [_tableView reloadData];
    
    [USER_DEFAULT removeObjectForKey:KEY_SCENELIST_INFO];
    NSData* aDate = [NSKeyedArchiver archivedDataWithRootObject:_sceneArry];
    [USER_DEFAULT setObject:aDate forKey:KEY_SCENELIST_INFO];
    [USER_DEFAULT synchronize];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSData* aData = [USER_DEFAULT objectForKey:KEY_SCENELIST_INFO];
    _sceneArry = [NSKeyedUnarchiver unarchiveObjectWithData:aData];
    
    
    UIStoryboard* storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _emptyModeViewController = [storyBord instantiateViewControllerWithIdentifier:@"EmptyModeViewID"];
    [self.view addSubview:_emptyModeViewController.view];
    
    if (_sceneArry == nil) {
        _sceneArry = [NSMutableArray array];
    }else{
        [_emptyModeViewController.view setHidden:YES];
    }
    
    UIView* _eView = [UIView new];
    [_eView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:_eView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillDetemin) name:NSNotificationCenter_AppWillDetemin object:nil];
}

-(void)appWillDetemin
{
    if (_sceneArry.count == 0) {
        return;
    }
    [USER_DEFAULT removeObjectForKey:KEY_SCENELIST_INFO];
    NSData* aDate = [NSKeyedArchiver archivedDataWithRootObject:_sceneArry];
    [USER_DEFAULT setObject:aDate forKey:KEY_SCENELIST_INFO];
    [USER_DEFAULT synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
        [_sceneArry removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        for (oneLedDeviceObject* _addDevice in [ConnectionManager sharedInstance].addedDeviceArray) {
            _addDevice.isSelected = NO;
        }
        for (_sceneArrayDeviceObject in _sceneArry) {
            for (_device in _sceneArrayDeviceObject.deviceArray) {
                _device.isSelected = YES;
                for (oneLedDeviceObject* _addDevice in [ConnectionManager sharedInstance].existDeviceArray) {
                    if ([_addDevice.identifier isEqualToString:_device.identifier]) {
                        _addDevice.isSelected = YES;
                        _device.characteristic = _addDevice.characteristic;
                        _device.peripheral = _addDevice.peripheral;
                    }
                }
            }
        }
        [self appWillDetemin];
    }
    if (_sceneArry.count == 0) {
        [_emptyModeViewController.view setHidden:NO];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sceneArry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"sceneModeCellIdentifier" forIndexPath:indexPath];
    _sceneArrayDeviceObject = [_sceneArry objectAtIndex:indexPath.row];
    _cell.label.text = _sceneArrayDeviceObject.name;
    _cell.tag = indexPath.row;
    _cell.delegate = self;
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController.tabBarController performSegueWithIdentifier:@"sceneDetailIdentifier" sender:[_sceneArry objectAtIndex:indexPath.row]];
}

#pragma mark -- sceneModeCellDelegate
-(void)sceneModeCellOpen:(BOOL)open tag:(NSUInteger)tag
{
    _sceneArrayDeviceObject = [_sceneArry objectAtIndex:tag];
    if (open) {
        [_sceneArrayDeviceObject setDefaultValue];
    }else{
        for (_device in _sceneArrayDeviceObject.deviceArray) {
            [_device open:open];
        }
    }
}
#pragma mark --
- (IBAction)addButtonTouched:(UIBarButtonItem *)sender {
    
    _sceneArrayDeviceObject = [SceneArrayDeviceObject createWithName:NSLocalizedString(@"scene mode",@"")];
    [_sceneArry addObject:_sceneArrayDeviceObject];
    [_emptyModeViewController.view setHidden:YES];
    [_tableView reloadData];
    [self appWillDetemin];
    [self.navigationController.tabBarController performSegueWithIdentifier:@"sceneDetailIdentifier" sender:[_sceneArry lastObject]];
}
@end
