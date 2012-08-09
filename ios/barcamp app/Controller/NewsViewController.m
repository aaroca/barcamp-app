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
    
    // Add pull to refresh view.
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
		view.delegate = self;
        view.backgroundColor = self.view.backgroundColor;
		[self.view addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
    
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    
    // Load local feed data
    CFeed* feed = [[CFeedStore instance] feedForURL:[NSURL URLWithString:FEED_URL] fetch:YES];
    [self loadRSSfromFeed:feed];
    
    // Register RSS subscription for add news
    CFeedFetcher *feedFetcher = [[CFeedFetcher alloc] initWithFeedStore:[CFeedStore instance]];
    [feedFetcher setDelegate:self];
    NSError *error = nil;
    [feedFetcher subscribeToURL:[NSURL URLWithString:FEED_URL] error:&error];
}

- (void)viewDidUnload
{
    _refreshHeaderView = nil;
    self.rssNews = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_refreshHeaderView release];
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

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - Pull to refresh protocol implementation

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    _reloading = YES;
    [self performSelector:@selector(refreshRSS)];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    return [NSDate date];
}

#pragma mark - RSS fetcher protocol

- (void)feedFetcher:(CFeedFetcher *)inFeedFetcher didFetchFeed:(CFeed *)inFeed {
    [self loadRSSfromFeed:inFeed];

    [(UITableView*)self.view reloadData];
}

#pragma mark - RSS operations implementation

- (void) refreshRSS {
    CFeed* feed = [[CFeedStore instance] feedForURL:[NSURL URLWithString:FEED_URL] fetch:YES];
    [self loadRSSfromFeed:feed];
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:(UITableView*)self.view];
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
}

@end
