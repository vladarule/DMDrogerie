//
//  DMCustomItem.m
//  DMDrogerie
//
//  Created by Vlada on 2/27/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMCustomItem.h"

@implementation DMCustomItem

- (id)initWithDictionary:(NSDictionary *)dict{
	if (self = [super init]) {
		self.name = [dict objectForKey:@"name"];
        self.price = [dict objectForKey:@"price"];
        self.numberOfItems = [dict objectForKey:@"numberOfItems"];
        self.inCart = [NSNumber numberWithBool:NO];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.numberOfItems forKey:@"numberOfItems"];
    [encoder encodeObject:self.inCart forKey:@"inCart"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {

        self.name = [decoder decodeObjectForKey:@"name"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.numberOfItems = [decoder decodeObjectForKey:@"numberOfItems"];
        self.inCart = [decoder decodeObjectForKey:@"inCart"];
        
    }
    return self;
}


@end
