//
//  DMAktuelnost.h
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMAktuelnost : NSObject

@property (nonatomic, strong)NSString* title;
@property (nonatomic, strong)NSString* descr;
@property (nonatomic, strong)NSString* detailDescription;
@property (nonatomic, strong)NSString* time;
@property (nonatomic, strong)NSString* activeTo;
@property (nonatomic, strong)NSString* imageSmall;
@property (nonatomic, strong)NSString* imageBig;
@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* link;


- (id)initWithDictionary:(NSDictionary *)dict;

@end
