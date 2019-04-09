//
//  MainViewController.m
//  scan
//
//  Created by 王旭 on 2019/4/8.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "MainViewController.h"
#import "LeftViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "SVProgressHUD.h"
#import "MainCollectionViewCell.h"
#import "CollectionViewLayout.h"
#import "YBImageBrowser.h"
#import "MainModel.h"
#import "MJRefresh.h"
#import "ScanViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface MainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, MainCollectionViewDelegate, YBImageBrowserDataSource>
@property (nonatomic,strong) LeftViewController *leftVC; // 强引用，可以避免每次显示抽屉都去创建
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CollectionViewLayout *layout;
@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic, strong) NSMutableArray *imagesCaches;
@end

@implementation MainViewController

static NSString * const reuseIdentifier = @"WXMainCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"悦图";
    
    [self setupLeftMenu];
    [self initView];
    [self reloadData];
}

- (NSArray *)imagesCaches {
    if (!_imagesCaches) {
        _imagesCaches = [NSMutableArray new];
    }
    return _imagesCaches;
}

- (NSArray *)productArray {
    if (!_productArray) {
        _productArray = [NSMutableArray new];
    }
    return _productArray;
}

- (LeftViewController *)leftVC {
    __weak typeof(self) weakSelf = self;
    if (_leftVC == nil) {
        _leftVC = [LeftViewController new];
        _leftVC.array = @[@{@"title":@"精美壁纸",@"value":@(0)},
                          @{@"title":@"美食诱惑",@"value":@(1)},
                          @{@"title":@"游戏原画",@"value":@(2)},
                          @{@"title":@"植物赏析",@"value":@(3)}];
        _leftVC.block = ^(NSInteger type) {
            switch (type) {
                case 0:
                    [weakSelf typeWallpaper];
                    break;
                case 1:
                    [weakSelf typeFood];
                    break;
                case 2:
                    [weakSelf typeGame];
                    break;
                case 3:
                    [weakSelf typePlant];
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _leftVC;
}

- (void)setupLeftMenu {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    [self cw_registerShowIntractiveWithEdgeGesture:YES transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (direction == CWDrawerTransitionFromLeft) { // 左侧滑出
            [weakSelf defaultAnimationFromLeft];
        } else if (direction == CWDrawerTransitionFromRight) { // 右侧滑出
            
        }
    }];
}

- (void)initView {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat kScreenWidth = size.width;
    CGFloat kScreenHeight = size.height;
    
    self.layout = [CollectionViewLayout new];
    self.layout.delegate = self;
    /**
     创建collectionView
     */
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:self.layout];
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:182 green:238 blue:238 alpha:1]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.bounces = NO;
    [self.view addSubview:self.collectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadData];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self.collectionView.mj_footer endRefreshing];
    }];
}

- (void)defaultAnimationFromLeft {
    // 强引用leftVC，不用每次创建新的,也可以每次在这里创建leftVC，抽屉收起的时候会释放掉
    [self cw_showDefaultDrawerViewController:self.leftVC];
    // 或者这样调用
    //    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:nil];
}

- (IBAction)showLeftMenu:(id)sender {
    [self defaultAnimationFromLeft];
}

- (void)typeWallpaper {
    NSLog(@"select === typeWallpaper");
}

- (void)typeFood {
    NSLog(@"select === typeFood");
}

- (void)typeGame {
    NSLog(@"select === typeGame");
}

- (void)typePlant {
    NSLog(@"select === typePlant");
}

- (void)reloadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", HOST, GAMEPATH] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        long code = [[responseObject valueForKey:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [responseObject valueForKey:@"data"];
            if ([data count] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^() {
                    [SVProgressHUD showErrorWithStatus:@"没有数据了~_~"];
                });
            } else {
                self.productArray = [NSMutableArray arrayWithArray:data];
                [self.collectionView.mj_header endRefreshing];
                dispatch_async(dispatch_get_main_queue(), ^() {
                    [self.collectionView reloadData];
                });
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"source failure **");
        dispatch_async(dispatch_get_main_queue(), ^() {
            [SVProgressHUD showErrorWithStatus:@"获取数据失败~"];
        });
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_productArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    MainModel *model = [[MainModel alloc] init];
    NSDictionary *tempDic = [self.productArray objectAtIndex:indexPath.row];
    
    NSDictionary *dic = @{@"index": @(indexPath.row), @"img": [tempDic valueForKey:@"img"], @"images": [tempDic valueForKey:@"images"], @"title": [tempDic valueForKey:@"title"]};
    
    [model setValuesForKeysWithDictionary: dic];
    
    cell.errorBlock = ^(NSInteger index) {
        [self.productArray removeObjectAtIndex:index];
        [self.collectionView reloadData];
    };
    cell.successBlock = ^(NSInteger index, UIImage *image) {
        if (index < [self.imagesCaches count]) {
            self.imagesCaches[index] = image;
        } else {
            [self.imagesCaches addObject:image];
        }
        [self.layout prepareLayout];
        [self.layout layoutAttributesForItemAtIndexPath:indexPath];
        
    };
    
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self.productArray objectAtIndex:indexPath.item];
    NSArray *images = [dic valueForKey:@"images"];
    NSString *title = [dic valueForKey:@"title"];
    ScanViewController *vc = [ScanViewController new];
    vc.images = images;
    vc.desc = title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark <CollectionViewDelegate>

- (CGFloat)waterflowLayout:(CollectionViewLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    // 获取图片的宽高，根据图片的比例计算Item的高度。
    if (index < [_imagesCaches count]) {
        UIImage *image = [_imagesCaches objectAtIndex:index];
        CGFloat fixelW = CGImageGetWidth(image.CGImage);
        CGFloat fixelH = CGImageGetHeight(image.CGImage);
        CGFloat itemHeight = fixelH * itemWidth / fixelW;
        return itemHeight + 50;
    } else {
        return 300;
    }
}

- (NSInteger)columnCountInWaterflowLayout:(CollectionViewLayout *)waterflowLayout{
    return 2;
}

- (CGFloat)columnMarginInWaterflowLayout:(CollectionViewLayout *)waterflowLayout{
    return 10;
}

- (CGFloat)rowMarginInWaterflowLayout:(CollectionViewLayout *)waterflowLayout{
    return 10;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(CollectionViewLayout *)waterflowLayout{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark 实现 <YBImageBrowserDataSource> 协议方法配置数据源
- (NSUInteger)yb_numberOfCellForImageBrowserView:(YBImageBrowserView *)imageBrowserView {
    return [_productArray count];
}
- (id<YBImageBrowserCellDataProtocol>)yb_imageBrowserView:(YBImageBrowserView *)imageBrowserView dataForCellAtIndex:(NSUInteger)index {
    YBImageBrowseCellData *data = [YBImageBrowseCellData new];
    data.url = [_productArray[index] valueForKey:@"img"];
    //    data.sourceObject = ...;
    return data;
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
