//
//  DMHairColorManufacturer.h
//  DMDrogerie
//
//  Created by Vlada on 4/25/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DMHairColor.h"

@interface DMHairColorManufacturer : NSObject

@property (nonatomic, strong)NSString* name;
@property (nonatomic, strong)NSString* imgUrl;

@property (nonatomic, strong)NSMutableArray* blondColors;
@property (nonatomic, strong)NSMutableArray* redColors;
@property (nonatomic, strong)NSMutableArray* darkColors;
@property (nonatomic, strong)NSMutableArray* brownColors;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
