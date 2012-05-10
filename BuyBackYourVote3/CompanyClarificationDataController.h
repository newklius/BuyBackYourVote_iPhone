//
//  CompanyClarificationDataController.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CompanyClarification;

@interface CompanyClarificationDataController : NSObject

@property (nonatomic, copy) NSMutableArray *companyList;

- (NSUInteger)countOfCompanyList;
- (CompanyClarification *)objectInCompanyListAtIndex:(NSUInteger)index;
- (void)addCompanyWithName:(NSString *)name;

@end
