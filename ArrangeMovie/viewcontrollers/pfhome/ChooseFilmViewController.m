//
//  ChooseFilmViewController.m
//  ArrangeMovie
//
//  Created by 陈凯 on 16/10/19.
//  Copyright © 2016年 EMI. All rights reserved.
//

#import "ChooseFilmViewController.h"
#import "FilmInfo.h"
#import "ChooseFilmCell.h"

@interface ChooseFilmViewController ()<UISearchBarDelegate,UISearchResultsUpdating>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UISearchController *searchController;
@property (strong,nonatomic) NSMutableArray<FilmInfo *>  *dataList;
@property (strong,nonatomic) NSMutableArray<FilmInfo *>  *searchList;
@end

@implementation ChooseFilmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
   
    //因为UISearchController在searchBar获得焦点事件后，相当于弹出来了，需要先让它消失
    
    if ([self.presentedViewController isKindOfClass:[UISearchController class]] ) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    [super viewWillDisappear:animated];
}

- (void)initView{
    self.title = @"选择电影名称";
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 17, 0, 17);
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(0, 0, screenWidth, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.dataList=[NSMutableArray arrayWithCapacity:100];
    
    
    
    for (NSInteger i=0; i<100; i++) {
        FilmInfo *film = [[FilmInfo alloc] init];
        film.imagename = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2317499888,864114656&fm=116&gp=0.jpg";
        film.title = [NSString stringWithFormat:@"%ld",(long)i];
        film.daoyan = @"导演：陈凯";
        film.yanyuan = @"演员：陈凯";
        [self.dataList addObject:film];
        
    }
}

//设置区域的行数

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    if (self.searchController.active) {
        
        return [self.searchList count];
        
    }else{
        
        return [self.dataList count];
        
    }
    
    
    
}

//返回单元格内容

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ChooseFilmCell *cell = [ChooseFilmCell cellWithTableView:tableView];
    if (self.searchController.active) {
        
        FilmInfo *film = (FilmInfo *)self.searchList[indexPath.row];
        [cell setValues:film.imagename titleStr:film.title centerStr:film.daoyan bottomStr:film.yanyuan];
        
    }
    
    else{
        
        FilmInfo *film = (FilmInfo *)self.dataList[indexPath.row];
        [cell setValues:film.imagename titleStr:film.title centerStr:film.daoyan bottomStr:film.yanyuan];
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    
    
    NSString *searchString = [self.searchController.searchBar text];
    
    
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@", searchString];
    
    
    
    if (self.searchList!= nil) {
        
        [self.searchList removeAllObjects];
        
    }
    
    //过滤数据
    
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    
    //刷新表格
    
    
    
    [self.tableView reloadData];
    
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
