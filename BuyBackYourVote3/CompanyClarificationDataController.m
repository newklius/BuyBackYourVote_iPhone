//
//  CompanyClarificationDataController.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompanyClarificationDataController.h"
#import "CompanyClarification.h"

@interface CompanyClarificationDataController ()
- (void)initializeDefaultDataList;
@end

@implementation CompanyClarificationDataController

@synthesize companyList = _companyList;

- (void)initializeDefaultDataList {
    NSMutableArray *clarificationList = [[NSMutableArray alloc] init];
    self.companyList = clarificationList;
    //[self addCompanyWithName:@"Google"];
}

- (void)setCompanyList:(NSMutableArray *)newList {
    if (_companyList != newList) {
        _companyList = [newList mutableCopy];
    }
}

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfCompanyList {
    return [self.companyList count];
}

- (CompanyClarification *)objectInCompanyListAtIndex:(NSUInteger)index {
    return [self.companyList objectAtIndex:index];
}

- (void)addCompanyWithName:(NSString *)name {
    CompanyClarification *company = [[CompanyClarification alloc] initWithName:name];
    [self.companyList addObject:company];
}

@end
