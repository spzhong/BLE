//
//  ViewController.h
//  unknown
//
//  Created by spzhong on 16/2/25.
//  Copyright © 2016年 spzhong. All rights reserved.
//



/**
 *  http://blog.sina.com.cn/s/blog_51a995b70101t7ek.html
 */


#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *myTab;

@end

