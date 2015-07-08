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
		self.descr = [dict objectForKey:@"opis"];
        self.detailDescription = [dict objectForKey:@"det_opis"];
        self.time = [dict objectForKey:@"vreme"];
        self.activeTo = [dict objectForKey:@"aktivan_do"];
        self.imageSmall = [dict objectForKey:@"slika_mala"];
        self.imageBig = [dict objectForKey:@"slika_velika"];
        self.objectId = [dict objectForKey:@"id"];
        self.link = [dict objectForKey:@"link"];
	}
	return self;
}

@end
