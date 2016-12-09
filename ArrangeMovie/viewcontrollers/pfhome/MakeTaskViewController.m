//
//  MakeTaskViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/18.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "MakeTaskViewController.h"
#import "AMAlertView.h"
#import "CKAlertViewController.h"
#import "TouchLabel.h"
#import "UIBarButtonItem+Extension.h"
#import "EMICamera.h"
#import "LCActionSheet.h"
#import "TZImagePickerController.h"
#import "SDTextField.h"
#import "AMActionSheet.h"
#import "SCDateTools.h"
#import "PYPhotoBrowseView.h"
#import "FilmListWebInterface.h"
#import "SCHttpOperation.h"
#import "GradeListWebInterface.h"
#import "Film.h"
#import "Grade.h"
#import "UploadFile.h"
#import "ReleaseTaskWebInterface.h"


@interface MakeTaskViewController ()<LCActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UploadFileDelegate>


@property (weak, nonatomic) IBOutlet UIView *topView;//顶部
//拍照
@property (strong,nonatomic) EMICamera *camera;
//联想输入框
@property (nonatomic,strong) SDTextField *textField;

@property (nonatomic,strong) NSMutableArray <UIButton *>* btnArrays;
@property (nonatomic,strong) NSArray *btnTitleArray;
@property (nonatomic,strong) NSMutableArray *btnSelectedStringArray;
@property (nonatomic,strong) NSString *startTime;//开始时间
@property (nonatomic,strong) NSString *endTime;//结束时间

@property (nonatomic,strong) NSMutableArray *filmDataArray;//电影列表

@property (nonatomic,strong) NSMutableArray *movieRangeArray;//院线等级列表

//任务积分列表
@property (nonatomic,strong) NSMutableArray *taskPointArray;
//任务时间
@property (nonatomic,strong) NSMutableArray *taskTimeArray;//一周范围内，两周范围内
//任务发放数
@property (nonatomic,strong) NSMutableArray *taskReleaseArray;

//上传图片的工具
@property (nonatomic,strong) UploadFile *uploadUtil;

//选中的院线等级id
@property (nonatomic,assign) int selectedGradeid;
@end

@implementation MakeTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnArrays = [[NSMutableArray alloc] initWithCapacity:0];
    self.filmDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.movieRangeArray = [[NSMutableArray alloc] initWithCapacity:0];//ABC三级
    self.taskPointArray = [[NSMutableArray alloc] initWithArray:@[@"100",@"200",@"500"]];
    self.taskTimeArray = [[NSMutableArray alloc] initWithArray:@[@"一周范围内",@"两周范围内"]];
    
    //任务开始时间，今天
    self.startTime = [SCDateTools dateToString:[NSDate date]];
    
    self.taskReleaseArray = [[NSMutableArray alloc] initWithCapacity:0];//10-100
    for (int i = 10; i < 101; i++) {
        [self.taskReleaseArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    self.btnTitleArray = @[@"影院级别",@"任务积分",@"任务时间",@"任务发放数"];
    self.btnSelectedStringArray = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@""]];
    
    [self fetchFilmList];
    [self fetchMovieRange];
    
    [self initView];
    [self createswipToLastViewGesture];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除NSUserDefault中存的电影封面图片data
    [OperateNSUserDefault removeUserDefaultWithKey:@"filmCover"];
}

//请求全部电影列表
- (void)fetchFilmList{
    __unsafe_unretained typeof (self) weakself = self;
    FilmListWebInterface *filmlistInterface = [[FilmListWebInterface alloc] init];
    NSDictionary *param  = [filmlistInterface inboxObject:@[@(self.user.userid),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:filmlistInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [filmlistInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            NSMutableArray *tempfilmlistArray = [[NSMutableArray alloc] initWithArray:result[1]];//临时电影列表数组
            for (id item in tempfilmlistArray) {
                Film *tempfilm = [Film mj_objectWithKeyValues:item];
                [self.filmDataArray addObject:tempfilm];
            }
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
    } WithFailureBlock:^{
        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
    }];
}

//获取院线级别
- (void)fetchMovieRange{
    __unsafe_unretained typeof (self) weakself = self;
    GradeListWebInterface *gradelistInterface = [[GradeListWebInterface alloc] init];
    NSDictionary *param  = [gradelistInterface inboxObject:@[@(self.user.userid),@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:gradelistInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [gradelistInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            weakself.movieRangeArray = [[NSMutableArray alloc] initWithArray:result[1]];
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
    } WithFailureBlock:^{
        [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
    }];
}

//隐藏键盘
- (IBAction)hideKeyBoard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass(object_getClass(touch.view)) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

//自定义滑动返回
- (void)createswipToLastViewGesture{
    // 加入左侧边界手势
    UIScreenEdgePanGestureRecognizer * edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer  *)edgePan{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)initView{
    
    //上传图片的工具类
    if (self.uploadUtil == nil) {
        self.uploadUtil = [[UploadFile alloc] initWithViewController:self];
        self.uploadUtil.delegate = self;
    }
    
    self.topView.frame = CGRectMake(self.topView.frame.origin.x*autoSizeScaleX, self.topView.frame.origin.y*autoSizeScaleY, self.topView.frame.size.width*autoSizeScaleX, self.topView.frame.size.height*autoSizeScaleY);
    [AppDelegate storyBoradAutoLay:self.topView];
    [AppDelegate storyBoardAutoLabelFont:self.topView];
    
    self.title = @"创建任务";     
    //右侧navBtn
    UIBarButtonItem *rightNavBtn = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(rightNavBtnClicked:)];
    [rightNavBtn setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"DroidSans-Bold" size:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [rightNavBtn setTintColor:[UIColor whiteColor]];
    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = 14.2*autoSizeScaleX;
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,rightNavBtn, nil];
    self.navigationItem.rightBarButtonItem = rightNavBtn;
    //返回按钮
    UIBarButtonItem *leftNavBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [leftNavBtn setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"DroidSans-Bold" size:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [leftNavBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftNavBtn;
    //电影名称
    self.textField = [SDTextField initWithFrame:CGRectMake(35*autoSizeScaleX, 187.5*autoSizeScaleY, 305*autoSizeScaleX, 42*autoSizeScaleY)];
    self.textField.textfield.textColor = [UIColor colorWithHexString:@"d9dbe0"];
    self.textField.textfield.font = [UIFont fontWithName:@"DroidSans-Bold" size:17.f*autoSizeScaleY];
    self.textField.textfield.textAlignment = NSTextAlignmentCenter;
    
    
    
    [self.textField.textfield setValue:[UIColor colorWithHexString:@"d9dbe0"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField.textfield setValue:[UIFont fontWithName:@"DroidSans-Bold" size:17.f*autoSizeScaleY] forKeyPath:@"_placeholderLabel.font"];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    self.textField.textfield.attributedPlaceholder = [NSAttributedString.alloc initWithString:@"请输入电影名称"
                                            
                                                                         attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    
    
    
    self.textField.dataArray = self.filmDataArray;
    
    [self.view addSubview:self.textField];
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15*autoSizeScaleX, 230*autoSizeScaleY, 345*autoSizeScaleX, 0.5*autoSizeScaleY)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"162271"];
    [self.view addSubview:lineView];
    
    
    //
    [self createButtons];
}


//创建按钮
- (void)createButtons{
    CGFloat y = 281.f*autoSizeScaleY;
    CGFloat btWidth = 311.f*autoSizeScaleX;
    CGFloat x = 32.f*autoSizeScaleX;
    CGFloat btHeight = 60.f*autoSizeScaleY;
    CGFloat space = 32.f*autoSizeScaleY;
    CGFloat cornerRadius = 13.f*autoSizeScaleY;
    
    
    for (int i = 0; i < self.btnTitleArray.count; i++) {
        y = 281.f*autoSizeScaleY +(space+btHeight)*i;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, y, btWidth, btHeight);
        btn.tag = i;
        btn.backgroundColor = [UIColor colorWithHexString:@"d9dbe0"];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = cornerRadius;
        [btn setTitle:self.btnTitleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        btn.titleLabel.font = [UIFont fontWithName:@"DroidSans-Bold" size:15.f*autoSizeScaleY];
        
        [self.btnArrays addObject:btn];
        [self.view addSubview:btn];
    }
}

- (void)btnClicked:(UIButton *)sender{
    [self createScrollView:sender.tag];
}

//发布
- (void)rightNavBtnClicked:(UIBarButtonItem *)sender{
    NSData *filmCover = (NSData *)[OperateNSUserDefault readUserDefaultWithKey:@"filmCover"];
    if (filmCover == nil) {
        [self.view makeToast:@"请上传电影封面" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if ([self.textField.textfield.text isEqualToString:@""]||self.textField.textfield.text == nil) {
        
        [self.view makeToast:@"请输入电影名称" duration:2.0 position:CSToastPositionCenter];
        return;
    }
//    if ([self.startTime isEqualToString:@""] || self.startTime == nil) {
//        [self.view makeToast:@"请选择任务开始时间" duration:2.0 position:CSToastPositionCenter];
//        return;
//    }
    if ([self.endTime isEqualToString:@""] || self.endTime == nil) {
        [self.view makeToast:@"请选择任务时间" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if ([self.btnSelectedStringArray[0] isEqualToString:@""]) {
        [self.view makeToast:@"请选择影院级别" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if ([self.btnSelectedStringArray[1] isEqualToString:@""]) {
        [self.view makeToast:@"请选择任务积分" duration:2.0 position:CSToastPositionCenter];
        return;
    }

    if ([self.btnSelectedStringArray[3] isEqualToString:@""]) {
        [self.view makeToast:@"请选择任务发放数" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    if ([self.btnSelectedStringArray[1] intValue]*[self.btnSelectedStringArray[3] intValue] > self.user.userpoints) {
        [self.view makeToast:@"积分余额不足" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    //都没问题了，开始上传图片
    [self uploadHead:filmCover];
}


//上传图片
- (void)uploadHead:(NSData *)imgdata{
    
    
        
    [self.uploadUtil uploadFileWithURL:[NSURL URLWithString:imgUploadServerIP] data:imgdata];
    
    
    
    
}

- (void)returnImagePath:(NSArray *)resultimg{
    //图片上传成功，去上传任务
    
    __unsafe_unretained typeof(self) weakself = self;
    ReleaseTaskWebInterface *releasetaskInterface = [[ReleaseTaskWebInterface alloc] init];
    NSDictionary *param = [releasetaskInterface inboxObject:@[@(self.user.userid),@(self.textField.filmid),self.btnSelectedStringArray[3],self.btnSelectedStringArray[1],self.startTime,self.endTime,@(self.selectedGradeid),resultimg[0],@(self.user.usertype)]];
    [SCHttpOperation requestWithMethod:RequestMethodTypePost withURL:releasetaskInterface.url withparameter:param WithReturnValeuBlock:^(id returnValue) {
        NSArray *result = [releasetaskInterface unboxObject:returnValue];
        if ([result[0] intValue] == 1) {
            
//            //任务发布成功，积分要扣掉
//            //更改保存的个人积分
//            NSString *newPoints = [NSString stringWithFormat:@"%.0f",weakself.user.userpoints-([weakself.btnSelectedStringArray[1] doubleValue]*[self.btnSelectedStringArray[3] intValue])];
//            weakself.user.userpoints = [newPoints doubleValue];
//            [OperateNSUserDefault saveUser:weakself.user];
            
            [weakself.view makeToast:@"发布成功" duration:2.0 position:CSToastPositionCenter];
            
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }else{
            [weakself.view makeToast:result[1] duration:2.0 position:CSToastPositionCenter];
        }
    } WithErrorCodeBlock:^(id errorCode) {
        [weakself.view makeToast:@"请求错误" duration:2.0 position:CSToastPositionCenter];
    } WithFailureBlock:^{
         [weakself.view makeToast:@"网络异常" duration:2.0 position:CSToastPositionCenter];
    }];
}

//返回
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//添加电影封面
- (IBAction)addFilm:(UITapGestureRecognizer *)sender {
    
    LCActionSheet *actionAlert = [LCActionSheet sheetWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍一张",@"从手机相册中选择",@"查看图片", nil];
    [actionAlert show];
}

//弹出框点击事件代理
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    __unsafe_unretained typeof(self) weakSelf = self;
    if (buttonIndex == 1) {
        //拍照
        self.camera = [[EMICamera alloc] init];
        [self.camera takePhoto:self];
        //获的照片的回调
        
        [self.camera setBlock:^(UIImagePickerController *picker, NSDictionary<NSString *,id> *info) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            //获取图片
            UIImage *currentimage = [info objectForKey:UIImagePickerControllerOriginalImage];
            //相机需要把图片存进相蒲
            
            if (currentimage != nil) {
                //存进相蒲
                //                UIImageWriteToSavedPhotosAlbum(currentimage, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                [OperateNSUserDefault addUserDefaultWithKeyAndValue:@"filmCover" value:UIImagePNGRepresentation(currentimage)];
            }
            
        }];
    }
    if (buttonIndex == 2) {
        //从相册选
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        [imagePicker.navigationBar setBarTintColor:[UIColor colorWithHexString:@"162271"]];
        //隐藏内部拍照按钮
        imagePicker.allowTakePicture = NO;
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
            [OperateNSUserDefault addUserDefaultWithKeyAndValue:@"filmCover" value:UIImagePNGRepresentation(photos[0])];
        }];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    if (buttonIndex == 3) {
        NSLog(@"%@",@"查看图片");
        NSData *filmCover = (NSData *)[OperateNSUserDefault readUserDefaultWithKey:@"filmCover"];
        if (filmCover == nil) {
            [self.view makeToast:@"尚未上传图片！"];
        }else{
            //    跳转到排片详情的图片浏览器
            // 1. 创建photoBroseView对象
            PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
            
            // 2.1 设置图片源(UIImageView)数组
            //    photoBroseView.sourceImgageViews = imageViews;
            photoBroseView.images = @[[UIImage imageWithData:filmCover]];
            // 2.2 设置初始化图片下标（即当前点击第几张图片）
            photoBroseView.currentIndex = 0;
            
            // 3.显示(浏览)
            [photoBroseView show];
        }
    }
}


//创建底部弹出框
- (void)createScrollView:(long)tag{
//    if (tag == 2) {
//        //时间选择器
//        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 10+20*autoSizeScaleY, screenWidth, 200*autoSizeScaleY-(10+20*autoSizeScaleY))];
//        datePicker.datePickerMode = UIDatePickerModeDate;
//        [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
//        [datePicker addTarget:self action:@selector(selectedTime:) forControlEvents:UIControlEventValueChanged];
//
//        AMActionSheet *am = [[AMActionSheet alloc] initWithBlock:^(AMActionSheet *amactionsheet) {
//            //确定按钮
//            if ([amactionsheet.titleLab.text isEqualToString:@"任务开始时间"]) {
//                self.startTime = [SCDateTools dateToString:datePicker.date];
//                //                NSLog(@"%@",datePicker.date);
//                [amactionsheet setTitle:@"任务结束时间"];
//                return;
//            }
//            if ([amactionsheet.titleLab.text isEqualToString:@"任务结束时间"]) {
//                //                NSLog(@"%@",datePicker.date);
//                self.endTime = [SCDateTools dateToString:datePicker.date];
//                
//                [self.btnArrays[tag] setTitle:[NSString stringWithFormat:@"开始时间:%@ 结束时间:%@",self.startTime,self.endTime] forState:UIControlStateNormal];
//                [self dismissViewControllerAnimated:NO completion:nil];
//                return;
//            }
//        } frame:CGRectMake(0, screenHeight-200*autoSizeScaleY, screenWidth, 200*autoSizeScaleY) childView:datePicker];
//        [am setTitle:@"任务开始时间"];
//        CKAlertViewController *ckAlertVC = [[CKAlertViewController alloc] initWithAlertView:am];
//        
//        [self presentViewController:ckAlertVC animated:NO completion:nil];
//    }else{
        //普通选择器
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 10+20*autoSizeScaleY, screenWidth, 200*autoSizeScaleY-(10+20*autoSizeScaleY))];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.tag = tag;
        AMActionSheet *am = [[AMActionSheet alloc] initWithBlock:^(AMActionSheet *amactionsheet) {
            //确定按钮
            if (pickerView.tag !=  2) {
                //非时间项
                [self.btnArrays[pickerView.tag] setTitle:[NSString stringWithFormat:@"%@:%@",self.btnTitleArray[pickerView.tag],self.btnSelectedStringArray[pickerView.tag]] forState:UIControlStateNormal];
            }else{
                //时间项
                [self.btnArrays[tag] setTitle:[NSString stringWithFormat:@"开始时间:%@ 结束时间:%@",self.startTime,self.endTime] forState:UIControlStateNormal];
            }
            
             [self dismissViewControllerAnimated:NO completion:nil];
        } frame:CGRectMake(0, screenHeight-200*autoSizeScaleY, screenWidth, 200*autoSizeScaleY) childView:pickerView];
//        [am setSureBtnHidden:YES];
        [am setTitle:self.btnTitleArray[tag]];
        CKAlertViewController *ckAlertVC = [[CKAlertViewController alloc] initWithAlertView:am];
        
        [self presentViewController:ckAlertVC animated:NO completion:nil];
//    }
}

- (void)selectedTime:(UIDatePicker *)sender{
//    NSLog(@"%@",sender.date);
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        //影院级别
        return self.movieRangeArray.count;
    }
    
    if (pickerView.tag == 1) {
        //任务积分
        return self.taskPointArray.count;
    }
    if (pickerView.tag == 2) {
        //任务时间
        return self.taskTimeArray.count;
    }
    if (pickerView.tag == 3) {
        //任务发放数
        return self.taskReleaseArray.count;
    }
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    
    if (pickerView.tag == 0) {
        Grade *grade = [Grade mj_objectWithKeyValues:self.movieRangeArray[row]];
        //影院级别
        return grade.gradename;
    }
    if (pickerView.tag == 1) {
        //任务积分
        return self.taskPointArray[row];
    }
    if (pickerView.tag == 2) {
        //任务时间
        return self.taskTimeArray[row];
    }
    if (pickerView.tag == 3) {
        //任务发放数
        return self.taskReleaseArray[row];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    NSLog(@"%@",[self pickerView:pickerView titleForRow:row forComponent:component]);
    NSString *title = [self pickerView:pickerView titleForRow:row forComponent:component];
    [self.btnSelectedStringArray replaceObjectAtIndex:pickerView.tag withObject:title];
    if (pickerView.tag == 0) {
        Grade *grade = [Grade mj_objectWithKeyValues:self.movieRangeArray[row]];
        self.selectedGradeid = grade.gradeid;
    }
    if (pickerView.tag == 2) {
        if ([title isEqualToString:@"一周范围内"]) {
            //+7天
            self.endTime = [SCDateTools dateToString:[SCDateTools dateAfterPointDate:[NSDate date] afterday:7]];
        }
        if ([title isEqualToString:@"两周范围内"]) {
            //+14天
             self.endTime = [SCDateTools dateToString:[SCDateTools dateAfterPointDate:[NSDate date] afterday:14]];
        }
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
