//
//  DMAktuelnost.m
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMAktuelnost.h"

@implementation DMAktuelnost

- (id)initWithDictionary:(NSDictionary *)dict{
	if (self = [super init]) {
		self.title = [dict objectForKey:@"naslov"];
		self.description = [dict objectForKey:@"opis"];
        self.detailDescription = [dict objectForKey:@"det_op"];
        self.time = [dict objectForKey:@"vreme"];
        self.activeTo = [dict objectForKey:@"akt"];
        self.imageSmall = [dict objectForKey:@"sl_l"];
        self.imageBig = [dict objectForKey:@"sl_d"];
        self.objectId = [dict objectForKey:@"idAkt"];
        self.link = [dict objectForKey:@"linkA"];
	}
	return self;
}

@end
