//
//  ScanViewController.m
//  tools
//
//  Created by 王旭 on 2019/3/23.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "ScanViewController.h"
#import "FetchDetail.h"
#import "SVProgressHUD.h"
#import "ScanCollectionViewCell.h"
#import "WaterfallCollectionViewLayout.h"
#import "YBImageBrowser.h"

@interface ScanViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, WaterfallCollectionViewDelegate, YBImageBrowserDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WaterfallCollectionViewLayout *layout;
@property (nonatomic, strong) NSMutableArray *imgs;
@property (nonatomic, strong) NSMutableArray *imagesCaches;
@end

@implementation ScanViewController

static NSString * const reuseIdentifier = @"WXDetailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_desc) {
        self.title = _desc;
    }
    
    [self initData];
    [self initView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
}

- (void)initData {
    if (_path) {
        [SVProgressHUD showWithStatus:@"努力加载中.."];
        [FetchDetail fetchData:_path Block:^(NSArray *result) {
            NSLog(@"*****  result  == %@", result);
            self.imgs = [NSMutableArray arrayWithArray:result];
            dispatch_async(dispatch_get_main_queue(), ^() {
                [SVProgressHUD dismiss];
                [self.collectionView reloadData];
            });
        }];
    }
}

- (NSArray *)imgs {
    if (!_imgs) {
        _imgs = [NSMutableArray new];
    }
    return _imgs;
}

- (NSArray *)imagesCaches {
    if (!_imagesCaches) {
        _imagesCaches = [NSMutableArray new];
    }
    return _imagesCaches;
}

- (void)initView {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat kScreenWidth = size.width;
    CGFloat kScreenHeight = size.height;
    
    self.layout = [WaterfallCollectionViewLayout new];
    self.layout.delegate = self;
    /**
     创建collectionView
     */
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:self.layout];
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:182 green:238 blue:238 alpha:1]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ScanCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.bounces = NO;
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_imgs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *src = _imgs[indexPath.row];
    NSDictionary *dic = @{@"src": src, @"index": @(indexPath.row)};
    cell.errorBlock = ^(NSInteger index) {
        [self.imgs removeObjectAtIndex:index];
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
    cell.dic = dic;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSource = self;
    browser.currentIndex = indexPath.item;
    [browser show];
}

#pragma mark <WaterfallCollectionViewDelegate>

- (CGFloat)waterflowLayout:(WaterfallCollectionViewLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
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

#pragma mark 实现 <YBImageBrowserDataSource> 协议方法配置数据源
- (NSUInteger)yb_numberOfCellForImageBrowserView:(YBImageBrowserView *)imageBrowserView {
    return [_imgs count];
}
- (id<YBImageBrowserCellDataProtocol>)yb_imageBrowserView:(YBImageBrowserView *)imageBrowserView dataForCellAtIndex:(NSUInteger)index {
    YBImageBrowseCellData *data = [YBImageBrowseCellData new];
    data.url = _imgs[index];
//    data.sourceObject = ...;
    return data;
}

@end
