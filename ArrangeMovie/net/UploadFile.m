//
//  UploadFile.m
//  yunya
//
//  Created by WongSuechang on 16/3/29.
//  Copyright © 2016年 emi365. All rights reserved.
//

#import "UploadFile.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"

@interface UploadFile()

@property (nonatomic,strong) UIViewController *viewController;//当前正在上传图片的viewController
@property (nonatomic,strong) MBProgressHUD *HUD;//加载视图
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, copy) NSString *imgpath;//图片文件夹地址，形如”/upload/1243243543.jpg”
@property (nonatomic, copy) NSString *imgUrl;//图片完整路径，形如”http://......./upload/1243243543.jpg”
@end

@implementation UploadFile

- (instancetype)initWithViewController:(UIViewController *)viewController{
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}


- (NSData *)zipImage:(NSData *)imgdata{
    NSData *data;
    UIImage *img = [UIImage imageWithData:imgdata];
    
    //图片大于1M
    if (imgdata.length >= 1024*1024) {
        data = UIImageJPEGRepresentation(img, 0.5);
//        img = [UIImage imageWithData:data];
//        data = UIImagePNGRepresentation(img);
        
    }else{
        data = imgdata;
    }
    
    if (data.length <  1024*1024){
        return data;
    }else{
        return [self zipImage:data];
    }
}




#pragma mark - 私有方法
/**
 *  保存文件在沙盒中
 *
 *  @param data
 */
- (NSString *)saveImage:(NSData *)data{
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    return filePath;
}


#pragma mark - 上传文件
- (void)uploadFileWithURL:(NSURL *)url data:(NSData *)data
{
    NSData *zipdata = [self zipImage:data];
    
    
    NSString *filePath = [self saveImage:zipdata];
    NSString *inputStream = [NSInputStream inputStreamWithFileAtPath:filePath];
    
    NSNumber *contentLength = (NSNumber *)[[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL] objectForKey:NSFileSize];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBodyStream:inputStream];
    [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[contentLength description] forHTTPHeaderField:@"Content-Length"];
    NSURLConnection *task = [NSURLConnection connectionWithRequest:request delegate:self];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage sd_animatedGIFNamed:@"loading_120"]];
    self.HUD = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    self.HUD.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.2];
    self.HUD.bezelView.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.8];
    //        HUD.bezelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loading_bj"]];
    //        HUD.bezelView.tintColor = [UIColor clearColor];
    
    self.HUD.bezelView.layer.cornerRadius = 16;
    self.HUD.mode = MBProgressHUDModeCustomView;
    //        HUD.mode = MBProgressHUDModeIndeterminate;
    self.HUD.customView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.HUD.customView = imageView;
    self.HUD.margin = 5;
    NSLog(@"HUD的margin:%f",self.HUD.margin);
    //    HUD.delegate = self;
    self.HUD.square = YES;
    [self.HUD showAnimated:YES];

}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    NSLog(@"%@",[res allHeaderFields]);
    self.receiveData = [NSMutableData data];
    
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    //上传动作完成
    [self.HUD hideAnimated:YES];
    
    
    NSData  *infoData = [[NSMutableData alloc] init];
    infoData =self.receiveData;
//    NSString *receiveStr = [[NSString alloc]initWithData:infoData encoding:NSUTF8StringEncoding];
    NSError *error;
    //将请求的url数据放到NSData对象中
    //IOS自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *InfoDic = [NSJSONSerialization JSONObjectWithData:infoData options:NSJSONReadingMutableLeaves error:&error];
    if(!error){
        long success = [(NSNumber *)[InfoDic objectForKey:@"success"] longValue];
        if(success==1){
           self.imgpath = [InfoDic objectForKey:@"imgpath"];
           self.imgUrl = [InfoDic objectForKey:@"imgUrl"];
           if([self.delegate respondsToSelector:@selector(returnImagePath:)]){
               //完整地址
               [self.delegate performSelector:@selector(returnImagePath:) withObject:@[self.imgpath,self.imgUrl]];
           }
        }else{
            //提示错误信息
            NSString *msg = [InfoDic objectForKey:@"msg"];
            [self.viewController.view makeToast:msg];
        }
    }else{
        NSLog(@"%@",error);
        
    }
}
@end
