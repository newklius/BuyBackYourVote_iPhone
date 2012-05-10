//
//  CompanyResultsViewController.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Company;

@interface CompanyResultsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *CompanyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *SummaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *Party1Label;
@property (weak, nonatomic) IBOutlet UILabel *Amount1Label;
@property (weak, nonatomic) IBOutlet UILabel *Party2Label;
@property (weak, nonatomic) IBOutlet UILabel *Amount2Label;

@property (nonatomic, strong) Company *company;

@end
