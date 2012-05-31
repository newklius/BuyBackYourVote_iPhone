//
//  CompanyGraphViewController.h
//  BuyBackYourVote3
//
//  Created by Timothy Bauman on 5/25/12.
//  Copyright (c) 2012 Undergraduate Class of 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "CompanyViewController.h"
#import "Contributions.h"

@interface CompanyGraphViewController : UITableViewController <CompanyViewController> {
    NSMutableData *responseData;
}

- (void)loadContributionsWithYear:(NSNumber *)year;

@property (nonatomic, weak) Company *company;
@property (strong, nonatomic) Contributions *contributions;
@property (strong, nonatomic) NSMutableDictionary *contributionsByYear;
@property (strong, nonatomic) NSArray *years;
@property (strong, nonatomic) NSNumber *yearFilter;
@property (strong, nonatomic) NSString *groupingFilter;
@property (strong, nonatomic) NSString *seatFilter;
@property (strong, nonatomic) NSString *stateFilter;

@end
