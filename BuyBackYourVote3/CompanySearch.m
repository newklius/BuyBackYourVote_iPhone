//
//  CompanySearch.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompanySearch.h"

@implementation CompanySearch

@synthesize companyName = _companyName, companyURL = _companyURL, companyLogo = _companyLogo, companySum = _companySum;

-(id)initWithName:(NSString *)name url:(NSString *)url logo:(NSString *)logo sum:(NSNumber *)sum{
    self = [super init];
    if (self) {
        _companyName = name;
        _companyURL = url;
        _companyLogo = logo;
        _companySum = sum;
        return self;
    }
    return nil;
}

@end
