//
//  GraphPoint.m
//  Poisson Disc Distribution
//
//  Created by Juan Je García on 1/2/19.
//  Copyright © 2019 Juan Je García. All rights reserved.
//

#import "GraphPoint.h"

@implementation GraphPoint
- (instancetype)initWithX:(NSUInteger)x y:(NSUInteger)y {
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
    }
    return self;
}

@end
