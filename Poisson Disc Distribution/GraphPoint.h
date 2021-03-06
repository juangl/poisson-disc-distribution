//
//  GraphPoint.h
//  Poisson Disc Distribution
//
//  Created by Juan Je García on 1/2/19.
//  Copyright © 2019 Juan Je García. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GraphPoint : NSObject
- (instancetype)initWithX:(NSUInteger)x y:(NSUInteger)y;
@property NSInteger x;
@property NSInteger y;
@end

NS_ASSUME_NONNULL_END
