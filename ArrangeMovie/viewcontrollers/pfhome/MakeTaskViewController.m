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


@interface MakeTaskViewController ()<LCActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>


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
@end

@implementation MakeTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnArrays = [[NSMutableArray alloc] initWithCapacity:0];
    self.btnTitleArray = @[@"影院级别",@"任务积分",@"任务时间",@"任务发放数"];
    self.btnSelectedStringArray = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@""]];
    [self initView];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//隐藏键盘
- (IBAction)hideKeyBoard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


- (void)initView{
    
    self.topView.frame = CGRectMake(self.topView.frame.origin.x*autoSizeScaleX, self.topView.frame.origin.y*autoSizeScaleY, self.topView.frame.size.width*autoSizeScaleX, self.topView.frame.size.height*autoSizeScaleY);
    [AppDelegate storyBoradAutoLay:self.topView];
    [AppDelegate storyBoardAutoLabelFont:self.topView];
    
    self.title = @"创建任务";
    
    //右侧navBtn
    UIBarButtonItem *rightNavBtn = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(rightNavBtnClicked:)];
    [rightNavBtn setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"DroidSans-Bold" size:20.5],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [rightNavBtn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 17;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,rightNavBtn, nil];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back" highImageName:@"back" target:self action:@selector(back)];
    
    //电影名称
    self.textField = [SDTextField initWithFrame:CGRectMake(35*autoSizeScaleX, 187.5*autoSizeScaleY, 305*autoSizeScaleX, 42*autoSizeScaleY)];
    self.textField.textfield.textColor = [UIColor colorWithHexString:@"d9dbe0"];
    self.textField.textfield.font = [UIFont fontWithName:@"DroidSans-Bold" size:17.f*autoSizeScaleY];
    self.textField.textfield.placeholder = @"请输入电影名称";
    [self.textField.textfield setValue:[UIColor colorWithHexString:@"d9dbe0"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField.textfield setValue:[UIFont fontWithName:@"DroidSans-Bold" size:17.f*autoSizeScaleY] forKeyPath:@"_placeholderLabel.font"];
    self.textField.dataArray = [NSMutableArray arrayWithArray:@[@"让子弹飞1",@"让子弹飞A",@"让子弹飞B",@"让子单飞c",@"让子弹飞admin",@"七月与安生",@"奇异博士",@"特殊生物调查科"]];
    
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

        }];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    if (buttonIndex == 3) {
        NSLog(@"%@",@"查看图片");
    }
}


//创建底部弹出框
- (void)createScrollView:(long)tag{
    if (tag == 2) {
        //时间选择器
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 10+20*autoSizeScaleY, screenWidth, 200*autoSizeScaleY-(10+20*autoSizeScaleY))];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [datePicker addTarget:self action:@selector(selectedTime:) forControlEvents:UIControlEventValueChanged];

        AMActionSheet *am = [[AMActionSheet alloc] initWithBlock:^(AMActionSheet *amactionsheet) {
            //确定按钮
            if ([amactionsheet.titleLab.text isEqualToString:@"任务开始时间"]) {
                self.startTime = [SCDateTools dateToString:datePicker.date];
                //                NSLog(@"%@",datePicker.date);
                [amactionsheet setTitle:@"任务结束时间"];
                return;
            }
            if ([amactionsheet.titleLab.text isEqualToString:@"任务结束时间"]) {
                //                NSLog(@"%@",datePicker.date);
                self.endTime = [SCDateTools dateToString:datePicker.date];
                
                [self.btnArrays[tag] setTitle:[NSString stringWithFormat:@"开始时间:%@ 结束时间:%@",self.startTime,self.endTime] forState:UIControlStateNormal];
                [self dismissViewControllerAnimated:NO completion:nil];
                return;
            }
        } frame:CGRectMake(0, screenHeight-200*autoSizeScaleY, screenWidth, 200*autoSizeScaleY) childView:datePicker];
        [am setTitle:@"任务开始时间"];
        CKAlertViewController *ckAlertVC = [[CKAlertViewController alloc] initWithAlertView:am];
        
        [self presentViewController:ckAlertVC animated:NO completion:nil];
    }else{
        //普通选择器
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 10+20*autoSizeScaleY, screenWidth, 200*autoSizeScaleY-(10+20*autoSizeScaleY))];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.tag = tag;
        AMActionSheet *am = [[AMActionSheet alloc] initWithBlock:^(AMActionSheet *amactionsheet) {
            //确定按钮
            [self.btnArrays[pickerView.tag] setTitle:[NSString stringWithFormat:@"%@:%@",self.btnTitleArray[pickerView.tag],self.btnSelectedStringArray[pickerView.tag]] forState:UIControlStateNormal];
             [self dismissViewControllerAnimated:NO completion:nil];
        } frame:CGRectMake(0, screenHeight-200*autoSizeScaleY, screenWidth, 200*autoSizeScaleY) childView:pickerView];
//        [am setSureBtnHidden:YES];
        [am setTitle:self.btnTitleArray[tag]];
        CKAlertViewController *ckAlertVC = [[CKAlertViewController alloc] initWithAlertView:am];
        
        [self presentViewController:ckAlertVC animated:NO completion:nil];
    }
}

- (void)selectedTime:(UIDatePicker *)sender{
//    NSLog(@"%@",sender.date);
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    return [NSString stringWithFormat:@"%ld份",(long)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    NSLog(@"%@",[self pickerView:pickerView titleForRow:row forComponent:component]);
    NSString *title = [self pickerView:pickerView titleForRow:row forComponent:component];
    [self.btnSelectedStringArray replaceObjectAtIndex:pickerView.tag withObject:title];
   
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
