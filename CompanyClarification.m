//
//  CompanyClarification.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompanyClarification.h"

@implementation CompanyClarification

@synthesize companyName = _companyName;

-(id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _companyName = name;
        return self;
    }
    return nil;
}

@end
