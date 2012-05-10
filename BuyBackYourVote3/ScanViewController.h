//
//  FirstViewController.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanyClarificationDataController;
@class CompanySearchDataController;

@interface ScanViewController : UIViewController <ZBarReaderDelegate>
- (IBAction)scanButtonPressed:(id)sender;
- (IBAction)simulateButtonPressed:(id)sender;

@property (nonatomic, strong) CompanyClarificationDataController *clarificationDataController;
@property (nonatomic, strong) CompanySearchDataController *searchDataController;
@property (nonatomic, copy) NSString *oneSlug;
@property (nonatomic, copy) NSString *oneName;

@end
