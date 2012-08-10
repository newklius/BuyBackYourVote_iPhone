//
//  CompanySearch.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanySearch : NSObject

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyURL;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSNumber *companySum;
-(id)initWithName:(NSString *)name url:(NSString *)url logo:(NSString *)logo sum:(NSNumber *)sum;

@end
