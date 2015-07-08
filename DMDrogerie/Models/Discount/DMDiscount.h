//
//  DMDiscount.h
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMDiscount : NSObject


@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* item;
@property (nonatomic, strong)NSString* descr;
@property (nonatomic, strong)NSString* quantity;
@property (nonatomic, strong)NSString* name;
@property (nonatomic, strong)NSString* oldPrice;
@property (nonatomic, strong)NSString* nwPrice;
@property (nonatomic, strong)NSString* discount;
@property (nonatomic, strong)NSString* image;
@property (nonatomic, strong)NSString* saving;
@property (nonatomic, strong)NSString* activeTo;
@property (nonatomic, strong)NSString* ref;

@property (nonatomic, strong)NSNumber* dmBrand;

@property (nonatomic, strong)NSNumber* numberOfItems;
@property (nonatomic, strong)NSNumber* inCart;


- (id)initWithDictionary:(NSDictionary *)dict;

- (id)initWithCoder:(NSCoder *)decoder;

@end
