//
//  messageViewController.m
//  TableViewAnimationDemo
//
//  Created by pmc on 2018/2/24.
//  Copyright © 2018年 conor.Cai. All rights reserved.
//

#import "messageViewController.h"
#import "CustomCollectionViewFlowLayout.h"
static NSString * const cellID = @"MessageViewControllerCellID";

@interface messageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,readwrite,strong)UICollectionView * iMessageCollectionView;
@property (nonatomic, strong) UIDynamicAnimator * animator;
@end

@implementation messageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iPhone信息cell弹簧效果";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CustomCollectionViewFlowLayout * flowLayout = [[CustomCollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection                  = UICollectionViewScrollDirectionVertical;
    _iMessageCollectionView                     = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                                    collectionViewLayout:flowLayout];
    _iMessageCollectionView.backgroundColor     = [UIColor clearColor];
    _iMessageCollectionView.delegate            = self;
    _iMessageCollectionView.dataSource          = self;
    [self.view addSubview:_iMessageCollectionView];
    //注册cell
    [_iMessageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID
                                                                            forIndexPath:indexPath];
    cell.backgroundColor        = [UIColor colorWithRed:((arc4random() % 255)/255.0)
                                                  green:((arc4random() % 255)/255.0)
                                                   blue:((arc4random() % 255)/255.0)
                                                  alpha:0.5];
    return cell;
}
#pragma mark tableView Delegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width - 40), 50);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
@end
