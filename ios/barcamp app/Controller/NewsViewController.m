//
//  NewsViewController.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "NewsViewController.h"
#import "CFeedStore.h"
#import "CFeedEntry.h"
#import "CFeed.h"
#import "NewDetailViewController.h"

@interface NewsViewController ()

/*
 * Refresh news from barcamp spain RSS.
 */
- (void) refreshRSS;

/*
 * Load RSS to an array.
 */
- (void) loadRSSfromFeed:(CFeed*)feed;

@end

@implementation NewsViewController

#pragma mark - Common methods implementation
@synthesize rssNews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Load local RSS
    CFeed* feed = [[CFeedStore instance] feedForURL:[NSURL URLWithString:FEED_URL] fetch:YES];
    [self loadRSSfromFeed:feed];
    
    // Get New RSS
    [self refreshRSS];
    
    // Add pull to refresh action to tableview
    [(UITableView*)self.view addPullToRefreshWithActionHandler:^{
        [self refreshRSS];
    }];
}

- (void)viewDidUnload
{
    self.rssNews = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [self.rssNews release];
    [super dealloc];
}

#pragma mark - Table datasource protocol implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.rssNews.count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* rssCell = [tableView dequeueReusableCellWithIdentifier:@"rssCell"];
    
    if (!rssCell) {
        rssCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"rssCell"] autorelease];
        rssCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    CFeedEntry* entry = (CFeedEntry*) [self.rssNews objectAtIndex:indexPath.row];
    rssCell.textLabel.text = entry.title;
    rssCell.detailTextLabel.text = entry.subtitle;
    
    return rssCell;
}

#pragma mark - Table delegate protocol implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CFeedEntry* entry = (CFeedEntry*)[self.rssNews objectAtIndex:indexPath.row];
    
    NewDetailViewController* detailViewController = [[NewDetailViewController alloc] initWithNibName:@"NewDetailView" bundle:nil content:entry];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - RSS fetcher protocol

- (void)feedFetcher:(CFeedFetcher *)inFeedFetcher didFetchFeed:(CFeed *)inFeed {
    if (_reloading) {
        _reloading = NO;
        ((UITableView*)self.view).pullToRefreshView.lastUpdatedDate = [NSDate date];
        [((UITableView*)self.view).pullToRefreshView stopAnimating];
    }

    [self loadRSSfromFeed:inFeed];
}

#pragma mark - RSS operations implementation

- (void) refreshRSS {
    _reloading = YES;
    
    CFeedFetcher *feedFetcher = [[CFeedFetcher alloc] initWithFeedStore:[CFeedStore instance]];
    [feedFetcher setDelegate:self];
    [feedFetcher setFetchInterval:0];
    NSError *error = nil;
    [feedFetcher subscribeToURL:[NSURL URLWithString:FEED_URL] error:&error];
}

- (void) loadRSSfromFeed:(CFeed*)feed {
    if (!rssNews) {
        self.rssNews = [NSMutableArray array];
    } else {
        [self.rssNews removeAllObjects];
    }
    
    NSArray *entries = [[feed entries] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"fetchOrder" ascending:YES]]];
    for (CFeedEntry* entry in entries) {
        [self.rssNews addObject:entry];
    }
    
    if (self.rssNews.count > 0) {
        [(UITableView*)self.view setTableFooterView:nil];
    }
    
    [(UITableView*)self.view reloadData];
}

@end
