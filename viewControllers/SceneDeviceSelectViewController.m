//
//  SceneDeviceSelectViewController.m
//  bleLED
//
//  Created by Monster on 14-10-3.
//  Copyright (c) 2014年 Monster. All rights reserved.
//

#import "SceneDeviceSelectViewController.h"

@implementation SceneDeviceSelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView* _sView = [UIView new];
    _sView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:_sView];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"deviceSelectedIdentifier" forIndexPath:indexPath];
    _cell.nameLabel.text = [NSString stringWithFormat:@"device %ld",(long)indexPath.row];
    _cell.tag = indexPath.row;
    _cell.delegate = self;
    return _cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:@"deviceSelectedIdentifier" forIndexPath:indexPath];
    if (_cell.selectedButton.selected) {
        [_cell.selectedButton setSelected:NO];
    }else{
        [_cell.selectedButton setSelected:YES];
    }
}
#pragma mark -
#pragma mark - deviceSelectedDelegate
-(void)deviceSelectedCellSelected:(BOOL)seleted
{
    
}
@end
