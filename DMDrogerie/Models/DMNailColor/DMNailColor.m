//
//  DMNailColor.m
//  DMDrogerie
//
//  Created by Vlada on 3/17/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMNailColor.h"

@implementation DMNailColor

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.manufacturerName = [dict objectForKey:@"imePro"];
        self.manufacturerLogo = [dict objectForKey:@"logoPro"];
        
        self.colors = [NSMutableArray arrayWithArray:[dict objectForKey:@"boje"]];
    }
    return self;
}

@end
