//
//  FetchDetail.h
//  tools
//
//  Created by 王旭 on 2019/3/23.
//  Copyright © 2019 王旭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FetchDetail : NSObject

/**
 block回调
 
 @param array 抓取的数组
 */
typedef void(^FetchDetailBlock)(NSArray * _Nullable array);

+ (void)fetchData: (NSString *)path Block:(FetchDetailBlock)block;


@end

NS_ASSUME_NONNULL_END
