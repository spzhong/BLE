//
//  CentralViewController.m
//  unknown
//
//  Created by spzhong on 16/2/27.
//  Copyright © 2016年 spzhong. All rights reserved.
//

#import "CentralViewController.h"

@implementation CentralViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [[Central share:self] makeCentralManager];
    
    
#pragma 标签说明
    
    allY = 100;
#pragma 发送文本
    
    seachField = [[UITextField alloc] initWithFrame:Rect(10, allY, (SCREENWIDTH-80-20), 40)];
    seachField.delegate = self;
    [self.view addSubview:seachField];
    seachField.layer.borderWidth = 1;
    seachField.layer.borderColor =[RGB(220, 224, 225) CGColor];
    seachField.returnKeyType = UIReturnKeySearch;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    seachField.leftView = view;
    seachField.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = Rect(SCREENWIDTH-80, allY, 80, 40);
    [sendButton setTitle:@"send text" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendTextActionEvent) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitleColor:RGB(0,122,255) forState:UIControlStateNormal];
    [self.view addSubview:sendButton];
    [sendButton setBackgroundColor:[UIColor clearColor]];
    
    
    
    
    allY += 70;
#pragma 发送文件
    UIButton *sendButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton2.frame = Rect(10, allY, SCREENWIDTH-20, 40);
    [sendButton2 setTitle:@"send file" forState:UIControlStateNormal];
    [sendButton2 addTarget:self action:@selector(sendFileActionEvent) forControlEvents:UIControlEventTouchUpInside];
    [sendButton2 setTitleColor:RGB(0,122,255) forState:UIControlStateNormal];
    [self.view addSubview:sendButton2];
    [sendButton2 setBackgroundColor:[UIColor clearColor]];
    
    
    
    allY += 70;
#pragma log 表
    
    dataLogArray = [[NSMutableArray alloc] init];
    self.myTab = [[UITableView alloc] initWithFrame:CGRectMake(0, allY, SCREENWIDTH,SCREENHEIGHT-allY) style:UITableViewStyleGrouped];
    [self.view addSubview:self.myTab];
    self.myTab.delegate = self;
    self.myTab.dataSource = self;
    [self.myTab setBackgroundColor:[UIColor clearColor]];
    
}




/**
 * 发送文本信息
 */
-(void)sendTextActionEvent{
    
    [self.view endEditing:NO];
    NSString *string = seachField.text;
    if (string.length==0) {
        return;
    }
    
    
    seachField.text = @"";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:string forKey:@"data"];
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:@"1" forKey:@"dir"];
    //添加到数据数组中
    [dataLogArray addObject:dic];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:dataLogArray.count-1 inSection:0];
    [self.myTab insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationRight];
    

    
    
    //发送文本
    Byte ACkValue[1] = {0};
    ACkValue[0] = 0xe0;
    NSMutableData *data = [NSMutableData dataWithBytes:ACkValue length:1];
    [data appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[Central share:self] sendToSubscribers:data];
    
}

/**
 *  发送文件
 */
-(void)sendFileActionEvent{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
    if (buttonIndex==0) {
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.allowsEditing = YES;
        imagepicker.delegate = self;
        [self presentViewController:imagepicker animated:YES completion:NULL];
    }else if (buttonIndex==1) {
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagepicker.allowsEditing = YES;
        imagepicker.delegate = self;
        [self presentViewController:imagepicker animated:YES completion:NULL];
    }else{
        
    }
}



//完成选择了图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *img = info[@"UIImagePickerControllerEditedImage"];
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    
    Byte ACkValue[1] = {0};
    ACkValue[0] = 0xe1;
    NSMutableData *data = [NSMutableData dataWithBytes:ACkValue length:1];
    [data appendData:imgData];
     
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}







#pragma 表格协议委托
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Call Back Data";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 30;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataLogArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建cell
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSMutableDictionary *dic = dataLogArray[indexPath.row];
    
    if ([dic[@"type"] integerValue]==1) {
        cell.textLabel.text = dic[@"data"];
    }else if ([dic[@"type"] integerValue]==2) {
        cell.imageView.image = dic[@"data"];
    }
    
    if ([dic[@"dir"] isEqualToString:@"0"]) {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}








/**
 *  PeripheralDelagete
 *  发送的结果
 *
 *  @param isok 发送的结果
 *  @param tag  标示
 */
-(void)sendMsgResult:(BOOL)isok{
    
    NSString *msg = @"";
    if (isok) {
        msg = @"success";
    }else{
        msg = @"fail";
    }
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [al show];
}
/**
 *  PeripheralDelagete
 *  返回数据的结果
 *
 *  @param msg
 */
-(void)callBackMsg:(NSData *)msg{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    Byte *headByte = (Byte *)[msg bytes];
    
    NSData *newData = [msg subdataWithRange:NSMakeRange(0, msg.length)];
    NSString *aString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
    [dic setObject:aString forKey:@"data"];
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:@"0" forKey:@"dir"]; //对方
     
    
    //添加到数据数组中
    [dataLogArray addObject:dic];
    NSIndexPath *index = [NSIndexPath indexPathForRow:dataLogArray.count-1 inSection:0];
    [self.myTab insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationLeft];
}




@end
