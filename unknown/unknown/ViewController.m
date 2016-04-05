//
//  ViewController.m
//  unknown
//
//  Created by spzhong on 16/2/25.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "ViewController.h"

#import "IBeaconViewController.h"
#import "PeripheralViewController.h"
#import "CentralViewController.h"



@interface ViewController ()

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"SERVER";
    
    //self.navigationBar.prompt = @"未知哦";
    // Do any additional setup after loading the view, typically from a nib.
    //伪代码
    //[[Beacon share] beaconRegisteredwithApp:@"FDA50693-A4E2-4FB1-AFCF-C6EB07647825" withIdentifier:@"so" withmajor:20 withminor:20];
    //[[Peripheral share] makePeripheralManager];
    //[[Central share] makeCentralManager];
    //伪代码
    
    
    self.myTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT)];
    [self.view addSubview:self.myTab];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    [self.myTab setBackgroundColor:[UIColor clearColor]];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma 表格协议委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建cell
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    //匹配执行的行
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"IBeacon Servce";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"Peripheral Servce";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"Central Servce";
        }
            break;
        default:
            break;
            
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            IBeaconViewController *bea = [[IBeaconViewController alloc] init];
            bea.title = @"IBeacon";
            [self.navigationController pushViewController:bea animated:YES];
        }
            break;
        case 1:
        {
            PeripheralViewController *peripheral = [[PeripheralViewController alloc] init];
            peripheral.title = @"Peripheral";
            [self.navigationController pushViewController:peripheral animated:YES];
        }
            break;
        case 2:
        {
            CentralViewController *central = [[CentralViewController alloc] init];
            central.title = @"Central";
            [self.navigationController pushViewController:central animated:YES];
        }
            break;
        default:
            break;
            
    }
}



@end
