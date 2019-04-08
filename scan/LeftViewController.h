//
//  LeftViewController.h
//  scan
//
//  Created by 王旭 on 2019/4/9.
//  Copyright © 2019 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LeftMenuBlock)(NSInteger type);

@interface LeftViewController : UIViewController

@property (nonatomic,copy) LeftMenuBlock block;

@property (nonatomic, strong) NSArray *array;

@end

NS_ASSUME_NONNULL_END
