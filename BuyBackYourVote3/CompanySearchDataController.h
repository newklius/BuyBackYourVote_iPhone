//
//  CompanySearchDataController.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CompanySearch;

@interface CompanySearchDataController : NSObject

@property (nonatomic, copy) NSMutableArray *companyList;

- (NSUInteger)countOfCompanyList;
- (CompanySearch *)objectInCompanyListAtIndex:(NSUInteger)index;
- (void)addCompanyWithName:(NSString *)name url:(NSString *)url;
- (id)initWithCompanyName:(NSString *)name;

@end
