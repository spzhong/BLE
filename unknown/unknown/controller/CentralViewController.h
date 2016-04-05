//
//  CentralViewController.h
//  unknown
//
//  Created by spzhong on 16/2/27.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Central.h"

@interface CentralViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,CentralDelagete>
{
    CGFloat allY;
    UITextField *seachField;
    NSMutableArray *dataLogArray;
}

@property(nonatomic,retain)UITableView *myTab;
@end
