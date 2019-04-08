//
//  WaterfallCollectionViewController.m
//  UICollectionVIewDemo
//
//  Created by DaLei on 2017/6/8.
//  Copyright © 2017年 DaLei. All rights reserved.
//

#import "WaterfallCollectionViewController.h"
#import "WaterfallCollectionViewCell.h"
#import "WaterfallCollectionViewLayout.h"
#import "Fetch.h"
#import "WaterfallCollectionViewCell.h"
#import "ScanViewController.h"
#import "WaterfallModel.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"

@interface WaterfallCollectionViewController ()<WaterfallCollectionViewDelegate>

@property (nonatomic, strong) NSArray *productArray;

@end

@implementation WaterfallCollectionViewController

static NSString * const reuseIdentifier = @"WXCell";

-(instancetype)init{
    WaterfallCollectionViewLayout *layout = [WaterfallCollectionViewLayout new];
    layout.delegate = self;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"萌图";
    
    [self initView];
    [self initData];
}

- (NSArray *)productArray {
    if (_productArray == nil) {
        if (![Fetch sharedFetch].list || [[Fetch sharedFetch].list count] == 0) {
            [[Fetch sharedFetch] refresh:^(NSArray *result) {
                [self refreshCallback:result];
                [self.collectionView.mj_header endRefreshing];
            }];
        } else {
            _productArray = [NSArray arrayWithArray:[Fetch sharedFetch].list];
        }
    }
    return _productArray;
}

- (void)initData {
    [Fetch sharedFetch].block = ^(NSArray *array){
        NSArray *tempArray = [self.productArray arrayByAddingObjectsFromArray:array];
        self.productArray = [NSArray arrayWithArray:tempArray];
        dispatch_async(dispatch_get_main_queue(), ^() {
            [self.collectionView reloadData];
        });
    };
}

- (void)initView {
    [self.collectionView registerClass:[WaterfallCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = RGBColor(235, 235, 235);
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[Fetch sharedFetch] refresh:^(NSArray *result) {
            [self refreshCallback:result];
            [self.collectionView.mj_header endRefreshing];
        }];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [[Fetch sharedFetch] loadMore:^(NSArray *result) {
            [self refreshCallback:result];
            [self.collectionView.mj_footer endRefreshing];
        }];
    }];
}

- (void)refreshCallback: (NSArray *)result {
    if ([result count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有数据了~_~"];
    } else {
        self.productArray = [NSArray arrayWithArray:result];
        dispatch_async(dispatch_get_main_queue(), ^() {
            [self.collectionView reloadData];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.productArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterfallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    WaterfallModel *model = [[WaterfallModel alloc] init];
    NSDictionary *dic = [self.productArray objectAtIndex:indexPath.row];
    [model setValuesForKeysWithDictionary: dic];
    
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *obj = [self.productArray objectAtIndex:indexPath.item];
    NSString *url = [obj valueForKey:@"href"];
    NSString *title = [obj valueForKey:@"title"];
    if (url && ![url isEqualToString:@""]) {
        ScanViewController *vc = [ScanViewController new];
        vc.path = url;
        vc.desc = title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark <WaterfallCollectionViewDelegate>

- (CGFloat)waterflowLayout:(WaterfallCollectionViewLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    // 获取图片的宽高，根据图片的比例计算Item的高度。
//    UIImage *image = [UIImage imageNamed:[self.productArray objectAtIndex:index]];
//    CGFloat fixelW = CGImageGetWidth(image.CGImage);
//    CGFloat fixelH = CGImageGetHeight(image.CGImage);
//    CGFloat itemHeight = fixelH * itemWidth / fixelW;
//    return itemHeight + 50;
    return 300;
}

- (NSInteger)columnCountInWaterflowLayout:(WaterfallCollectionViewLayout *)waterflowLayout{
    return 2;
}

- (CGFloat)columnMarginInWaterflowLayout:(WaterfallCollectionViewLayout *)waterflowLayout{
    return 10;
}

- (CGFloat)rowMarginInWaterflowLayout:(WaterfallCollectionViewLayout *)waterflowLayout{
    return 10;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterfallCollectionViewLayout *)waterflowLayout{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}



@end
