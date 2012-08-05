//
//  CompanyTabViewController.m
//  BuyBackYourVote3
//
//  Created by Timothy Bauman on 5/24/12.
//  Copyright (c) 2012 Undergraduate Class of 2013. All rights reserved.
//

#import "CompanyTabViewController.h"
#import "Company.h"
#import "CompanyViewController.h"

@interface CompanyTabViewController ()

@end

@implementation CompanyTabViewController
@synthesize companyURL, companyName, company, filterButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.navigationController.navigationBar.hidden = NO;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.companyName;
    
    self.company = [[Company alloc] initWithName:self.companyName URL:self.companyURL];
    
    for (id<CompanyViewController> v in self.viewControllers) {
        // do something with object
        [v loadFromCompany:self.company];
    }
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:[self.viewControllers objectAtIndex:0] action:@selector(filterButton)];
    
    self.navigationItem.rightBarButtonItem = barBtnItem;
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([self.tabBar.items indexOfObject:item] == 0) {
        // Contributions selected; show filter button
        UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:[self.viewControllers objectAtIndex:0] action:@selector(filterButton)];
        
        self.navigationItem.rightBarButtonItem = barBtnItem;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
