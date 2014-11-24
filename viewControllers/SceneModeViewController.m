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
    
    
    NSData* aData = [USER_DEFAULT objectForKey:KEY_SCENELIST_INFO];
    _sceneArry = [NSKeyedUnarchiver unarchiveObjectWithData:aData];
    if (_sceneArry == nil) {
        _sceneArry = [NSMutableArray array];
        
        UIStoryboard* storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _emptyModeViewController = [storyBord instantiateViewControllerWithIdentifier:@"EmptyModeViewID"];
        [self.view addSubview:_emptyModeViewController.view];
    }
    
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
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
-(void)sceneModeCellOpen:(BOOL)open
{
    
}
#pragma mark --
- (IBAction)addButtonTouched:(UIBarButtonItem *)sender {
    _sceneArrayDeviceObject = [SceneArrayDeviceObject createWithName:@"情景模式一"];
    [_sceneArry addObject:_sceneArrayDeviceObject];
    [self.navigationController.tabBarController performSegueWithIdentifier:@"sceneDetailIdentifier" sender:[_sceneArry lastObject]];
}
@end
