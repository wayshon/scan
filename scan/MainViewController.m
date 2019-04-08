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

@interface MainViewController ()
@property (nonatomic,strong) LeftViewController *leftVC; // 强引用，可以避免每次显示抽屉都去创建

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftMenu];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
