//
//  CategoryTopScoreController.m
//  groupbuy
//
//  Created by  on 11-9-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CategoryTopScoreController.h"
#import "ProductPriceDataLoader.h"
#import "PPSegmentControl.h"
#import "UIImageUtil.h"

enum TOP_SCORE_TYPE {
    TOP_0_10,
    TOP_10,
    TOP_NEW,
    TOP_DISTANCE
};

#define TOP_Y       25

@implementation CategoryTopScoreController

@synthesize categoryName;
@synthesize categoryId;
@synthesize belowTenController;
@synthesize aboveTenController;
@synthesize topNewController;
@synthesize distanceController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.belowTenController = nil;
    self.aboveTenController = nil;
    self.topNewController = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    switch (self.titlePPSegControl.selectedSegmentIndex) {
        case TOP_0_10:
        {
            self.aboveTenController = nil;
            self.distanceController = nil;
            self.topNewController = nil;
        }
            break;
        case TOP_10:
        {
            self.belowTenController = nil;
            self.distanceController = nil;
            self.topNewController = nil;            
        }
            break;
        case TOP_NEW:
        {
            self.belowTenController = nil;
            self.aboveTenController = nil;
            self.distanceController = nil;
        }
            break;
        case TOP_DISTANCE:
        {
            self.belowTenController = nil;
            self.aboveTenController = nil;
            self.topNewController = nil;            
        }
            break;
            
        default:
            break;
    } 

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self setBackgroundImageName:@"background.png"];

    [super viewDidLoad];
    
//    self.navigationItem.title = self.categoryName;
    [self setGroupBuyNavigationTitle:self.categoryName];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"0－10元", @"10元以上", @"发布日期", @"周边附近", nil];
    
    UIImage *bgImage = [UIImage strectchableImageName:@"tu_46.png"];
    UIImage *selectImage = [UIImage strectchableImageName:@"tu_39-15.png"];
    
    self.titlePPSegControl = [[PPSegmentControl alloc]initWithItems:titleArray defaultSelectIndex:1 frame:CGRectMake(7, 3, 306, 33)];
    
    [self.titlePPSegControl setBackgroundImage:bgImage];
    [self.titlePPSegControl setSelectedSegmentImage:selectImage];
    [self.titlePPSegControl setTextFont:[UIFont boldSystemFontOfSize:12]];
    [self.titlePPSegControl setSelectedSegmentTextFont:[UIFont boldSystemFontOfSize:12]];
    
    [self.titlePPSegControl setTextColor:
     [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1]];
    [self.titlePPSegControl setSelectedSegmentTextColor:
     [UIColor colorWithRed:134/255.0 green:148/255.0 blue:67/255.0 alpha:1.0]];
    
    [self.titlePPSegControl setDelegate:self];
    [self.view addSubview:self.titlePPSegControl];
    [self clickSegControl:titlePPSegControl];
    
    


    
   
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.belowTenController = nil;
    self.aboveTenController = nil;
    self.topNewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)onlyShowView:(UIView *)view
{
    [self.belowTenController.view setHidden:YES];
    [self.aboveTenController.view setHidden:YES];
    [self.topNewController.view setHidden:YES];
    [self.distanceController.view setHidden:YES];
    [view setHidden:NO];
    [self.view bringSubviewToFront:view];
}

- (void)showTopZeroTen
{
    if (self.belowTenController == nil){
        self.belowTenController = [[[CommonProductListController alloc] init] autorelease];        
        self.belowTenController.superController = self;
        ProductTopScoreBelowTenDataLoader *dataLoader = [[[ProductTopScoreBelowTenDataLoader alloc] init] autorelease];
        dataLoader.categoryId = self.categoryId;
        self.belowTenController.dataLoader = dataLoader;
        self.distanceController.type = [titlePPSegControl titleForSegmentAtIndex:
                                        [titlePPSegControl selectedSegmentIndex]];
        CGRect bounds = self.view.bounds;
        self.belowTenController.view.frame = CGRectMake(0, TOP_Y, bounds.size.width, bounds.size.height - TOP_Y);        
        [self.view addSubview:self.belowTenController.view];                
    }
    
    [self onlyShowView:self.belowTenController.view];
    [self.belowTenController viewDidAppear:NO];
}

- (void)showTopTen
{
    if (self.aboveTenController == nil){
        self.aboveTenController = [[[CommonProductListController alloc] init] autorelease];        
        self.aboveTenController.superController = self;
        ProductTopScoreAboveTenDataLoader *dataLoader = [[[ProductTopScoreAboveTenDataLoader alloc] init] autorelease];
        dataLoader.categoryId = self.categoryId;
        self.aboveTenController.dataLoader = dataLoader;
        self.distanceController.type = [titlePPSegControl titleForSegmentAtIndex:
                                        [titlePPSegControl selectedSegmentIndex]];
        CGRect bounds = self.view.bounds;
        self.aboveTenController.view.frame = CGRectMake(0, TOP_Y, bounds.size.width, bounds.size.height - TOP_Y);         
        [self.view addSubview:self.aboveTenController.view];                
    }
    
    [self onlyShowView:self.aboveTenController.view];
    [self.aboveTenController viewDidAppear:NO];
}

- (void)showTopNew
{
    if (self.topNewController == nil){
        self.topNewController = [[[CommonProductListController alloc] init] autorelease];    
        self.topNewController.superController = self;
        ProductStartDateDataLoader *dataLoader = [[[ProductStartDateDataLoader alloc] init] autorelease];
        dataLoader.categoryId = self.categoryId;
        self.topNewController.dataLoader = dataLoader;
        self.distanceController.type = [titlePPSegControl titleForSegmentAtIndex:
                                        [titlePPSegControl selectedSegmentIndex]];
        CGRect bounds = self.view.bounds;
        self.topNewController.view.frame = CGRectMake(0, TOP_Y, bounds.size.width, bounds.size.height - TOP_Y);        
        [self.view addSubview:self.topNewController.view];                
    }
    
    [self onlyShowView:self.topNewController.view];
    [self.topNewController viewDidAppear:NO];
}

- (void)showProductByDistance
{
    if (self.distanceController == nil){
        self.distanceController = [[[CommonProductListController alloc] init] autorelease];        
        self.distanceController.superController = self;
        ProductDistanceDataLoader *dataLoader = [[[ProductDistanceDataLoader alloc] init] autorelease];
        dataLoader.categoryId = self.categoryId;
        self.distanceController.dataLoader = dataLoader;
        self.distanceController.type = [titlePPSegControl titleForSegmentAtIndex:
                                        [titlePPSegControl selectedSegmentIndex]];        
        CGRect bounds = self.view.bounds;
        self.distanceController.view.frame = CGRectMake(0, TOP_Y, bounds.size.width, bounds.size.height - TOP_Y);         
        [self.view addSubview:distanceController.view];                
    }
    
    [self onlyShowView:self.distanceController.view];
    [distanceController viewDidAppear:NO];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self clickSegControl:self.titlePPSegControl];
    [super viewDidAppear:animated];
}

- (void)clickSegControl:(id)sender
{
    
    PPSegmentControl* segControl = sender;
    
    switch ([segControl selectedSegmentIndex]) {
            
        case TOP_0_10:
            [self showTopZeroTen];
            break;
        case TOP_10:
            [self showTopTen];
            break;
        case TOP_NEW:
            [self showTopNew];
            break;
        case TOP_DISTANCE:
            [self showProductByDistance];
            break;
        default:
            break;
    }
}

@end

