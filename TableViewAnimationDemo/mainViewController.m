//
//  mainViewController.m
//  TableViewAnimationDemo
//
//  Created by pmc on 2018/2/24.
//  Copyright © 2018年 conor.Cai. All rights reserved.
//

#import "mainViewController.h"
#import "ViewController.h"
#import "messageViewController.h"
static NSString * const cellID = @"MainViewControllerCellID";

@interface mainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * listTableView;
@property(nonatomic,copy)NSArray * listDataSource;
@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_listTableView];
    
    [_listTableView setSeparatorInset:UIEdgeInsetsZero];
    [_listTableView setLayoutMargins:UIEdgeInsetsZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.listDataSource[indexPath.row];
    return cell;
}

#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[ViewController new]
                                                 animated:YES];
            break;
        }
        case 1:
        {
            [self.navigationController pushViewController:[messageViewController new]
                                                 animated:YES];
            break;
        }
        default:
            break;
    }
}
#pragma mark getting/setting
-(NSArray *)listDataSource{
    if (!_listDataSource) {
        _listDataSource = @[@"cell按序入场动画",@"iPhone信息cell弹簧效果"];
    }
    return _listDataSource;
}
@end
