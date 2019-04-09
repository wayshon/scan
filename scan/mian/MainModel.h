//
//  MainModel.h
//  scan
//
//  Created by 王旭 on 2019/4/9.
//  Copyright © 2019 王旭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainModel : NSObject

@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *images;

@end

NS_ASSUME_NONNULL_END
