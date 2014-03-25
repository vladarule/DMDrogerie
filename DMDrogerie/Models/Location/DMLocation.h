//
//  DMLocation.h
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMLocation : NSObject


@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* street;
@property (nonatomic, strong)NSString* city;
@property (nonatomic, strong)NSString* phoneNo;
@property (nonatomic, strong)NSString* workingHours;
@property (nonatomic, strong)NSString* latitude;
@property (nonatomic, strong)NSString* longitude;
@property (nonatomic, strong)NSString* saturdayHours;;
@property (nonatomic, strong)NSString* sundayHours;
@property (nonatomic, strong)NSString* chief;
@property (nonatomic, strong)NSString* prod;

@property (nonatomic, strong)NSString* distance;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
