//
//  DMPromotion.m
//  DMDrogerie
//
//  Created by Vlada on 3/8/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMPromotion.h"

@implementation DMPromotion

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        
        self.desr = [dict objectForKey:@"opis"];
        self.product = [dict objectForKey:@"proizvod"];
        self.img = [dict objectForKey:@"slika"];
        
        self.stores = [NSArray arrayWithArray:[dict objectForKey:@"prod"]];
        
    }
    return self;
}

@end
