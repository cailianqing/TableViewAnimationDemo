//
//  ViewController.m
//  TableViewAnimationDemo
//
//  Created by pmc on 2018/2/23.
//  Copyright © 2018年 conor.Cai. All rights reserved.
//

#import "ViewController.h"
static NSString * const cellID = @"ViewControllerCellID";
static float const delayTimeInterval = 0.1;
static float const animationTimeInterval = 1.f;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * listTableView;
@end

@implementation ViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _listTableView.dataSource = self;
    [_listTableView reloadData];
    [self animateWithCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"cell按序入场动画";
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _listTableView.delegate = self;
    [self.view addSubview:_listTableView];
    [_listTableView setSeparatorInset:UIEdgeInsetsZero];
    [_listTableView setLayoutMargins:UIEdgeInsetsZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark private Methods
-(void)animateWithCell{
    NSArray * cells =  _listTableView.visibleCells;
    CGFloat tableHeight = _listTableView.bounds.size.height;
    for (UITableViewCell * cell in cells) {
        NSUInteger index = [cells indexOfObject:cell];
        cell.transform = CGAffineTransformMakeTranslation(0, tableHeight);
        [UIView animateWithDuration:animationTimeInterval
                              delay:delayTimeInterval*(double)index
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                            }
                         completion:nil];
    }
}

#pragma mark tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellID];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
@end
