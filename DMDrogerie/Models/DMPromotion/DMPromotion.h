//
//  DMPromotion.h
//  DMDrogerie
//
//  Created by Vlada on 3/8/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMPromotion : NSObject

- (id)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, strong)NSString* desr;
@property (nonatomic, strong)NSString* product;
@property (nonatomic, strong)NSString* img;

@property (nonatomic, strong)NSArray* stores;

@end
