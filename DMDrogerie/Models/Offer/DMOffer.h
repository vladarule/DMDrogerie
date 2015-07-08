//
//  DMOffer.h
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMOffer : NSObject

@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* title;
@property (nonatomic, strong)NSString* descr;
@property (nonatomic, strong)NSString* detailDescription;
@property (nonatomic, strong)NSString* price;
@property (nonatomic, strong)NSString* quantity;
@property (nonatomic, strong)NSString* time;
@property (nonatomic, strong)NSString* activeTo;
@property (nonatomic, strong)NSString* imageSmall;
@property (nonatomic, strong)NSString* imageBig;

@property (nonatomic, strong)NSString* link;
@property (nonatomic, strong)NSNumber* isNew;

@property (nonatomic, strong)NSNumber* numberOfItems;
@property (nonatomic, strong)NSNumber* inCart;

- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithCoder:(NSCoder *)decoder;


@end
