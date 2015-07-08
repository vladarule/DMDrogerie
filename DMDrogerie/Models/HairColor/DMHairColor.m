//
//  DMHairColor.m
//  DMDrogerie
//
//  Created by Vlada on 4/25/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMHairColor.h"

@implementation DMHairColor

- (id)initWithDictionary:(NSDictionary *)dict{
    
    if (self = [super init]) {
        self.name = [dict objectForKey:@"naziv"];
        self.category = [[dict objectForKey:@"prep"] integerValue];
        
        self.color = [self getColorFromArray:[dict objectForKey:@"kod"]];
    }
    return self;
}

- (UIColor *)getColorFromArray:(NSArray *)array{
    float red = [[array objectAtIndex:0] floatValue];
    float green = [[array objectAtIndex:1] floatValue];
    float blue = [[array objectAtIndex:2] floatValue];
    float alpha = [[array objectAtIndex:3] floatValue];
//    if ([array objectAtIndex:0] == [NSNull null]) {
//        <#statements#>
//    }
//    float red = [[array objectAtIndex:0] floatValue];
//    float green = [[array objectAtIndex:1] floatValue];
//    float blue = [[array objectAtIndex:2] floatValue];
//    float alpha = [[array objectAtIndex:3] floatValue];
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
    
}

@end
