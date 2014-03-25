//
//  DMStatistics.m
//  DMDrogerie
//
//  Created by Vlada on 3/23/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMStatistics.h"

@implementation DMStatistics


- (id)initWithDictionary:(NSDictionary *)dict{
	if (self = [super init]) {
//        @property (nonatomic, strong)NSString* category;
//        @property (nonatomic, strong)NSString* date;
//        @property (nonatomic, strong)NSString* objectId;
//        @property (nonatomic, strong)NSString* productCategory;
//        @property (nonatomic, strong)NSString* kor;
//        @property (nonatomic, strong)NSString* brDod;
//        @property (nonatomic, strong)NSString* brPrik;
//        @property (nonatomic, strong)NSString* brMap;
//        @property (nonatomic, strong)NSString* brTel;
        
        self.category = [dict objectForKey:@"category"];
        self.date = [dict objectForKey:@"date"];
        self.objectId = [dict objectForKey:@"objectId"];
        self.productCategory = @"0";
        self.kor = @"0";
        self.brDod = @"0";
        self.brMap = @"0";
        self.brPrik = @"0";
        self.brTel = @"0";
        
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.category forKey:@"category"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.objectId forKey:@"objectId"];
    [encoder encodeObject:self.productCategory forKey:@"productCategory"];
    [encoder encodeObject:self.kor forKey:@"kor"];
    [encoder encodeObject:self.brMap forKey:@"brMap"];
    [encoder encodeObject:self.brDod forKey:@"brDod"];
    [encoder encodeObject:self.brPrik forKey:@"brPrik"];
    [encoder encodeObject:self.brTel forKey:@"brTel"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        
        self.category = [decoder decodeObjectForKey:@"category"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.productCategory = [decoder decodeObjectForKey:@"productCategory"];
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
        self.kor = [decoder decodeObjectForKey:@"kor"];
        self.brDod = [decoder decodeObjectForKey:@"brDod"];
        self.brMap = [decoder decodeObjectForKey:@"brMap"];
        self.brTel = [decoder decodeObjectForKey:@"brTel"];
        self.brPrik = [decoder decodeObjectForKey:@"brPrik"];
        
    }
    return self;
}

@end
