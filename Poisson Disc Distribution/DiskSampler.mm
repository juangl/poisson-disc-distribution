//
//  DiskSampler.m
//  Poisson Disc Distribution
//
//  Created by Juan Je García on 1/2/19.
//  Copyright © 2019 Juan Je García. All rights reserved.
//

#import <random>
#import <cmath>
#import "DiskSampler.h"
#import "GraphPoint.h"

NSUInteger K = 30;

@interface DiskSampler() {
    std::default_random_engine generator;
    std::unique_ptr<std::uniform_real_distribution<>> distribution;
}
@property NSUInteger width;
@property NSUInteger height;
@property NSUInteger radius;
@property NSUInteger radius2;
@property NSUInteger R;
@property double cellSize;
@property NSUInteger gridWidth;
@property NSUInteger gridHeight;
@property NSMutableArray *grid;
@property NSMutableArray *queue;
@property NSUInteger queueSize;
@property NSUInteger sampleSize;
@end

@implementation DiskSampler
-(id)initWithDimensions:(NSInteger)width height:(NSInteger)height radius:(NSInteger)radius {
    self = [super init];
    if (self) {
        self.width = width;
        self.height = height;
        self.radius = radius;
        self.radius2 = radius * radius;
        self.R = self.radius2 * 3;
        self.cellSize = radius * sqrt(1.0/2.0);
        self.gridWidth = ceil(width / self.cellSize);
        self.gridHeight = ceil(height / self.cellSize);
        distribution.reset(new std::uniform_real_distribution<>(0.0, 1.0));
        [self reset];
    }
    return self;
}

-(void)reset {
    const NSUInteger capacity = self.gridWidth * self.gridHeight;
    self.grid = [[NSMutableArray alloc] initWithCapacity:(capacity)];
    
    for (int i = 0; i < capacity; i++) {
        [[self grid] addObject:[NSNull null]];
    }
    
    self.queue = [NSMutableArray new];
    self.queueSize = 0;
    self.sampleSize = 0;
}

-(GraphPoint*)getDisc {
    if (self.sampleSize == 0) {
        return [self sample:(*distribution)(generator) * self.width y:(*distribution)(generator) * self.height];
    }
    
    while (self.queueSize > 0) {
        NSUInteger i = (*distribution)(generator) * self.queueSize;
        GraphPoint *s = self.queue[i];
        
        // Make a new candidate between [radius, 2 * radius] from the existing sample.
        for (NSUInteger j = 0; j < K; ++j) {
            float a = 2 * M_PI * (*distribution)(generator);
            float r = sqrt((*distribution)(generator) * self.R + self.radius2);
            NSUInteger x = s.x + r * cos(a);
            NSUInteger y = s.y + r * sin(a);
            
            // Reject candidates that are outside the allowed extent,
            // or closer than 2 * radius to any existing sample.
            if (0 <= x && x < self.width && 0 <= y && y < self.height && [self far:x y:y]) return [self sample:x y:y];
        }
        
        self.queue[i] = self.queue[--self.queueSize];
        //self.queue.length = queueSize;
        const NSUInteger removeCount = [self.queue count] - self.queueSize;
        NSRange range = NSMakeRange(self.queueSize, removeCount);
        [self.queue removeObjectsInRange:range];
    }
    return nil;
}

-(Boolean)far:(NSUInteger)x y:(NSUInteger)y {
    NSUInteger i = x / self.cellSize;
    NSUInteger j = y / self.cellSize;
    NSUInteger i0 = fmax(i - 2, 0);
    NSUInteger j0 = fmax(j - 2, 0);
    NSUInteger i1 = fmin(i + 3, self.gridWidth);
    NSUInteger j1 = fmin(j + 3, self.gridHeight);
    
    for (j = j0; j < j1; ++j) {
        NSUInteger o = j * self.gridWidth;
        for (i = i0; i < i1; ++i) {
            GraphPoint *s = self.grid[o + i];
            if (![s isEqual:[NSNull null]]) {
                NSUInteger dx = s.x - x;
                NSUInteger dy = s.y - y;
                if (dx * dx + dy * dy < self.radius2) return false;
            }
        }
    }
    
    return true;
}
-(GraphPoint *)sample:(NSUInteger)x y:(NSUInteger)y {
    GraphPoint *s = [[GraphPoint alloc] initWithX:x y:y];
    [[self queue] addObject:s];
    self.grid[self.gridWidth * (int)(y / self.cellSize) + (int)(x / self.cellSize)] = s;
    ++self.sampleSize;
    ++self.queueSize;
    return s;
}
@end
