//
//  DMCustomItem.h
//  DMDrogerie
//
//  Created by Vlada on 2/27/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMCustomItem : NSObject

@property (nonatomic, strong)NSString* name;
@property (nonatomic, strong)NSString* price;
@property (nonatomic, strong)NSNumber* numberOfItems;
@property (nonatomic, strong)NSNumber* inCart;

- (id)initWithDictionary:(NSDictionary *)dict;

- (id)initWithCoder:(NSCoder *)decoder;

@end
