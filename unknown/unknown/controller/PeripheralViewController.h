//
//  PeripheralViewController.h
//  unknown
//
//  Created by spzhong on 16/2/27.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Peripheral.h"

@interface PeripheralViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,PeripheralDelagete>
{
    CGFloat allY;
    UITextField *seachField;
    NSMutableArray *dataLogArray;
}

@property(nonatomic,retain)UITableView *myTab;

@end
