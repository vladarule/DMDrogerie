//
//  DMHairColorManufacturer.m
//  DMDrogerie
//
//  Created by Vlada on 4/25/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMHairColorManufacturer.h"

@implementation DMHairColorManufacturer

- (id)initWithDictionary:(NSDictionary *)dict{
    
    if (self = [super init]) {
        self.name = [dict objectForKey:@"imePro"];
        self.imgUrl = [dict objectForKey:@"logoPro"];
        
        self.blondColors = [NSMutableArray array];
        self.redColors = [NSMutableArray array];
        self.darkColors = [NSMutableArray array];
        self.brownColors = [NSMutableArray array];
        
        for (id d in [dict objectForKey:@"crne"]) {
            if ([d isKindOfClass:[NSDictionary class]]) {
                DMHairColor* color = [[DMHairColor alloc] initWithDictionary:d];
                [self.darkColors addObject:color];
            }
            
        }
        
        for (id d in [dict objectForKey:@"crvene"]) {
            
            if ([d isKindOfClass:[NSDictionary class]]) {
                DMHairColor* color = [[DMHairColor alloc] initWithDictionary:d];
                [self.redColors addObject:color];
            }
            
        }
        
        for (id d in [dict objectForKey:@"plave"]) {
            if ([d isKindOfClass:[NSDictionary class]]) {
                DMHairColor* color = [[DMHairColor alloc] initWithDictionary:d];
                [self.blondColors addObject:color];
            }
            
            
        }
        
        for (id d in [dict objectForKey:@"smedje"]) {
            
            if ([d isKindOfClass:[NSDictionary class]]) {
                DMHairColor* color = [[DMHairColor alloc] initWithDictionary:d];
                [self.brownColors addObject:color];
            }
            
        }
        
    }
    return self;
}

@end
