//
//  DMHairColor.h
//  DMDrogerie
//
//  Created by Vlada on 4/25/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMHairColor : NSObject

@property (nonatomic, strong)NSString* name;
@property (nonatomic, assign)NSInteger category;

@property (nonatomic, strong)UIColor* color;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
