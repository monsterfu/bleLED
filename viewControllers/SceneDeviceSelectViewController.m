//
//  SceneDeviceSelectViewController.m
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "SceneDeviceSelectViewController.h"

@implementation SceneDeviceSelectViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView* _sView = [UIView new];
    _sView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:_sView];
    
    _rightButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"list_select"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTouch)];
    
    [self.navigationItem setRightBarButtonItem:_rightButtonItem];
    
    _selectedArray = _sceneArrayDeviceObj.deviceArray;
    
    _deviceArray = [NSMutableArray array];
    
    NSMutableArray* arr = [ConnectionManager sharedInstance].addedDeviceArray;
    for (_device in arr) {
        if (_device.connected) {
            [_deviceArray addObject:_device];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)rightBarButtonTouch
{
    _sceneArrayDeviceObj.deviceArray = _selectedArray;
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_deviceArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"deviceSelectedIdentifier" forIndexPath:indexPath];
    _device = [_deviceArray objectAtIndex:indexPath.row];
    _cell.nameLabel.text = _device.name;
    
    _cell.tag = indexPath.row;
    _cell.delegate = self;
    return _cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = (deviceSelectedCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (_cell.selectedButton.selected) {
        [_cell.selectedButton setSelected:NO];
        [_selectedArray removeObject:[_deviceArray objectAtIndex:indexPath.row]];
    }else{
        [_cell.selectedButton setSelected:YES];
        [_selectedArray addObject:[_deviceArray objectAtIndex:indexPath.row]];
    }
}
#pragma mark -
#pragma mark - deviceSelectedDelegate
-(void)deviceSelectedCellSelected:(BOOL)seleted tag:(NSUInteger)tag
{
    if (seleted) {
        [_selectedArray addObject:[_deviceArray objectAtIndex:tag]];
    }else{
        [_selectedArray removeObject:[_deviceArray objectAtIndex:tag]];
    }
}
@end
