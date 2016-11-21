//
//  SDTextField.m
//  SDTextFieldDemo
//
//  Created by songjc on 16/10/11.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import "SDTextField.h"

@interface SDTextField ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *searchList;

@property(nonatomic ,assign)CGRect viewFrame;

@end

@implementation SDTextField

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.viewFrame =frame;
        
        _textfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textfield.keyboardType = UIKeyboardTypeDefault;
        self.heightMultiple = 3;
        
        self.cellHeight =frame.size.height;
        
        _textfield.layer.cornerRadius = 3;
        
        _textfield.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        
        self.layer.masksToBounds = YES;

        _textfield.delegate = self;
        
        _textfield.borderStyle = UITextBorderStyleNone;
        
        [self addSubview:_textfield];
        
        [self createTableView];
        
        [_textfield addTarget:self  action:@selector(textFieldDidChange)  forControlEvents:UIControlEventAllEditingEvents];
        
    }

    return self;

}

+(instancetype)initWithFrame:(CGRect)frame{

    SDTextField *textField = [[SDTextField alloc]initWithFrame:frame];


    return textField;
}

#pragma mark ----设置tableView----

-(void)createTableView{
    
    self.dataArray = [NSMutableArray arrayWithCapacity:16];

    self.searchList = [NSMutableArray arrayWithCapacity:16];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/4, self.frame.size.width, self.frame.size.height/4*3)];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1];
    
    _listBackgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0  blue:240/255.0  alpha:1];
    
    self.tableView.separatorStyle = NO;

    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SDtableViewCell"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.searchList.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SDtableViewCell"];
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;

    if (self.searchList.count !=0) {
        
        cell.textLabel.text = self.searchList[indexPath.row];
        
    }
    
    return cell;


}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    self.textfield.text = cell.textLabel.text;
    [self hiddenTableView];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return _cellHeight;

}

#pragma mark ---- view整体高度改变 和tableView的显示和隐藏 ----
-(void)showTableView{

    self.frame = CGRectMake(self.viewFrame.origin.x, self.viewFrame.origin.y, self.viewFrame.size.width, self.viewFrame.size.height*(self.heightMultiple+1));
    
    self.tableView.frame =CGRectMake(0, self.frame.size.height/(self.heightMultiple+1), self.frame.size.width, self.frame.size.height/(self.heightMultiple+1)*self.heightMultiple);

    [self addSubview:self.tableView];
    
    [self.superview bringSubviewToFront:self];

}

-(void)hiddenTableView{

    self.frame = self.viewFrame;
    
    [self.tableView removeFromSuperview];
    
}


#pragma mark--- textField的代理方法 ----


-(void)textFieldDidChange{

    if (self.textfield.text.length == 0) {
        

        [self hiddenTableView];
    }
    NSString *searchString = self.textfield.text;
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:preicate]];
    
    if (self.searchList.count !=0) {
        [self showTableView];

    }else{
        
        [self hiddenTableView];
    
    }
        //刷新表格
    [self.tableView reloadData];


}


-(void)textFieldDidEndEditing:(UITextField *)textField{

    [self hiddenTableView];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textfield resignFirstResponder];
    
    if (self.frame.size.height != self.viewFrame.size.height) {
        
        [self hiddenTableView];

    }

    return YES;

}



#pragma mark ---属性相关---

-(void)setListBackgroundColor:(UIColor *)listBackgroundColor{

    _listBackgroundColor = listBackgroundColor;
    
    self.tableView.backgroundColor = listBackgroundColor;


}

-(void)setHeightMultiple:(int)heightMultiple{

    _heightMultiple = heightMultiple;
    
    
}

-(void)setCellHeight:(CGFloat)cellHeight{

    _cellHeight = cellHeight;


}

@end
