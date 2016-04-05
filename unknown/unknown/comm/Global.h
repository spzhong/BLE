//
//  Global.h
//  unknown
//
//  Created by spzhong on 16/2/25.
//  Copyright © 2016年 spzhong. All rights reserved.
//



#define kServiceUUID  @"312700E2-E798-4D5C-8DCF-49908332DF9F"
#define kCharacteristicUUID  @"FFA28CDE-6525-4489-801C-1C060CAC9767"


#ifndef Global_h
#define Global_h


#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height

#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define Size(w, h)                          CGSizeMake(w, h)
#define Point(x, y)                         CGPointMake(x, y)

#define TabBarHeight                        49.0f
#define NaviBarHeight                       44.0f
#define SCREENWIDTH                         [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT                        [[UIScreen mainScreen] bounds].size.height
#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define AUTO_WIDTH							((SCREENWIDTH)*1.0/375)
#define AUTO_HEIGHT							((SCREENHEIGHT)*1.0/667)
#define CGRectMakeLayout(A, B, C, D) CGRectMake(AUTO_WIDTH*(A), AUTO_HEIGHT*(B), AUTO_WIDTH*(C), AUTO_HEIGHT*(D))
/////////////////////////////////////////////////////////////////////////////////////

#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/////////////////////////////////////////////////////////////////////////////////////

#define iOS6                                (IOSVersion >= 6.0 && IOSVersion < 7.0)
#define iOS7                                (IOSVersion >= 7.0 && IOSVersion < 8.0)
#define iOS8                                (IOSVersion >= 8.0)
#define iOS6Later                           (!(IOSVersion < 6.0f))
#define iOS7Later                           (!(IOSVersion < 7.0f))
#define iOS8Later                           (!(IOSVersion < 8.0f))
#define iOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]

#define Iphone4Screen                       ([UIScreen mainScreen].bounds.size.height == 480.0f)
#define Iphone5Screen                       ([UIScreen mainScreen].bounds.size.height == 568.0f)
#define Iphone6Screen                       ([UIScreen mainScreen].bounds.size.height == 667.0f)
#define Iphone6PScreen                      ([UIScreen mainScreen].bounds.size.height == 736.0f)


/////////////////////////////////////////////////////////////////////////////////////

#define StringNotEmpty(str)                 (str && (str.length > 0))
#define ArrayNotEmpty(arr)                  (arr && (arr.count > 0))

#define Dictionary(obj)                     (obj && [obj isKindOfClass:[NSDictionary class]])
#define Array(obj)                          (obj && [obj isKindOfClass:[NSArray class]])

#define ClassNameStr(ClassName)             (((void)(NO && ((void)ClassName.class, NO)), @#ClassName))

/////////////////////////////////////////////////////////////////////////////////////

#define AppBuildVersion                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppVersion                              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define VCInStoryboard(storyboard, VCID)       [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:VCID]


#define backItem(aBarButtonItem) UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];backItem.title = @"返回";aBarButtonItem = backItem;

#define __IOS_Edition_FANGBENG__ if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0){CGRect rect = self.contentView.superview.frame;rect.size.width = SCREENWIDTH;rect.size.height = rect.size.height == 0?1:rect.size.height;self.contentView.superview.frame = rect;}

#define Font(A) [UIFont systemFontOfSize:A]



 




#endif /* Global_h */
