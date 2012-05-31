//
//  BillsTableViewController.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "CompanyViewController.h"

@class BillsDataController;

@interface BillsTableViewController : UITableViewController <CompanyViewController> {
    NSMutableData *responseData;
}

@property (strong, nonatomic) NSArray *bills;
@property (nonatomic, weak) Company *company;

- (void)loadFromCompany:(Company *)comp;
@end
