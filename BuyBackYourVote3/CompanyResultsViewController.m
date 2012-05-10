//
//  CompanyResultsViewController.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompanyResultsViewController.h"
#import "Company.h"

@interface CompanyResultsViewController ()

@end

@implementation CompanyResultsViewController
@synthesize CompanyNameLabel;
@synthesize SummaryLabel;
@synthesize Party1Label;
@synthesize Amount1Label;
@synthesize Party2Label;
@synthesize Amount2Label;

@synthesize company;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"adding company name %@", company.companyName);
    CompanyNameLabel.text = company.companyName;
    Party1Label.text = @"Democrats:";
    NSLog(@"%@", [company democrats]);
    Amount1Label.text = [[company democrats] stringValue];
    Party2Label.text = @"Republicans:";
    Amount2Label.text = [[company republicans] stringValue];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setCompanyNameLabel:nil];
    [self setSummaryLabel:nil];
    [self setParty1Label:nil];
    [self setAmount1Label:nil];
    [self setParty2Label:nil];
    [self setAmount2Label:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
