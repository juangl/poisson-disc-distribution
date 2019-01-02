//
//  DiskSampler.h
//  Poisson Disc Distribution
//
//  Created by Juan Je García on 1/2/19.
//  Copyright © 2019 Juan Je García. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiskSampler : NSObject
-(id)initWithDimensions:(NSInteger)width height:(NSInteger)height radius:(NSInteger)radius;
-(GraphPoint *)getDisc;
-(void)reset;
@end

NS_ASSUME_NONNULL_END
