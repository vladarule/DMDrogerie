//
//  DMNailColor.h
//  DMDrogerie
//
//  Created by Vlada on 3/17/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMNailColor : NSObject

- (id)initWithDictionary:(NSDictionary *)dict;

@property(nonatomic, strong)NSString* manufacturerName;
@property(nonatomic, strong)NSString* manufacturerLogo;

@property(nonatomic, strong)NSMutableArray* colors;

@end
