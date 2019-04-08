//
//  WaterfallCollectionViewCell.h
//  tools
//
//  Created by jike1 on 2019/3/22.
//  Copyright © 2019 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterfallModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterfallCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) WaterfallModel *model;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
