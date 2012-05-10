//
//  Bill.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Bill.h"

@implementation Bill

@synthesize billTitle = _billTitle, billNumber = _billNumber, link = _link, summary = _summary, support = _support;

-(id)initWithTitle:(NSString *)title number:(NSString *)number link:(NSString *)link summary:(NSString *)summary support:(BOOL)support {

    self = [super init];
    if (self) {
        _billTitle = title;
        _billNumber = number;
        _link = link;
        _summary = summary;
        _support = support;
        return self;
    }
    return nil;
}

@end
