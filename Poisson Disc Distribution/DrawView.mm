//
//  DrawView.m
//  Poisson Disc Distribution
//
//  Created by Juan Je García on 1/2/19.
//  Copyright © 2019 Juan Je García. All rights reserved.
//

#include <random>
#include <memory>
#import "DrawView.h"
#import "DiskSampler.h"

#define CANVAS_WIDTH = 300;
#define CANVAS_HEIGHT = 300;

@interface DrawView() {
    std::default_random_engine generator;
    std::unique_ptr<std::uniform_int_distribution<int>> distribution;
}
@property DiskSampler *sampler;
@property NSMutableArray *disk;
@end

@implementation DrawView
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    distribution.reset(new std::uniform_int_distribution<int>(0, 240));
    self.sampler = [[DiskSampler alloc] initWithDimensions:300 height:300 radius:20];
    self.disk = [[NSMutableArray alloc] init];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    [self drawPoints:myContext rect:rect];
}

- (void)drawPoints:(CGContextRef)context rect:(CGRect)rect {
    
    CGContextSetLineWidth(context, 1);
    
    CGFloat redColor[4] = {1.0, 0.0, 0.0, 1.0};
    CGContextSetStrokeColor(context, redColor);
    CGContextSetFillColor(context, redColor);
    
    CGContextBeginPath(context);
    //CGFloat randomNumber = (*distribution)(generator);
    
    GraphPoint *test = [[self sampler] getDisc];
    while(test) {
        CGContextAddArc(context, (CGFloat)test.x, (CGFloat)test.y, 2, 0, M_PI * 2, true);
        //CGContextStrokePath(context);
        CGContextFillPath(context);
        test = [[self sampler] getDisc];
    }
}

- (void)newDraw {
    [[self sampler] reset];
    [self setNeedsDisplay];
}

@end
