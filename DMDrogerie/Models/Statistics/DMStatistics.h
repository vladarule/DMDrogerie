//
//  DMStatistics.h
//  DMDrogerie
//
//  Created by Vlada on 3/23/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMStatistics : NSObject


//{"dat":"19.03.2014.","kat":"LOK","id":30,"kor":0,"brDod":0,"brPrik":1,"katPro":"0","brMap":0,"brTel":0}?
@property (nonatomic, strong)NSString* category;
@property (nonatomic, strong)NSString* date;
@property (nonatomic, strong)NSString* objectId;
@property (nonatomic, strong)NSString* productCategory;
@property (nonatomic, strong)NSString* kor;
@property (nonatomic, strong)NSString* brDod;
@property (nonatomic, strong)NSString* brPrik;
@property (nonatomic, strong)NSString* brMap;
@property (nonatomic, strong)NSString* brTel;

- (id)initWithDictionary:(NSDictionary *)dict;

- (id)initWithCoder:(NSCoder *)decoder;

@end
