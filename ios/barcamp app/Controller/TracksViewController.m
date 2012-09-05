//
//  TracksViewController.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "TracksViewController.h"
#import "XMLtoTrackService.h"
#import "GCPagedScrollView.h"
#import "Track.h"
#import "MeetingsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TracksViewController ()

@property (nonatomic, readonly) GCPagedScrollView* scrollView;

- (NSArray*) getTracks;
- (void) updateTracks;
- (void) loadTracks;
- (void) reloadTracks;
- (void) renderPages;
- (void) reloadingTracksState;
- (void) reloadedTracksState;

@end

@implementation TracksViewController

@synthesize tracks = _tracks;
@synthesize loadingTracksView = _loadingTracksView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    // Setup update tracks button.
    [self reloadedTracksState];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSelectorInBackground:@selector(loadTracks) withObject:nil];
}

- (void)viewDidUnload
{
    [self setLoadingTracksView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_loadingTracksView release];
    [super dealloc];
}

#pragma mark - Rendering pages

- (void) renderPages {
    [(GCPagedScrollView*)self.view removeAllContentSubviews];
    
    NSInteger page = 1;
    for (Track* track in self.tracks) {
        MeetingsViewController* meetingsViewController = [[MeetingsViewController alloc] initWithNibName:@"MeetingsView" bundle:nil inTrack:page withMeetings:track.meetings];
        [(GCPagedScrollView*)self.view addContentSubview:meetingsViewController.view];
        page++;
    }
}

#pragma mark - Tracks operations

- (NSArray*) getTracks {
    NSArray* localTracks = nil;
    
    // Get local xml with tracks data.
    NSString* documentDirectoryURL = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tracks.xml"];
    
    NSFileManager* manager = [[NSFileManager alloc] init];
    
    if ([manager fileExistsAtPath:documentDirectoryURL]) {
        NSData* xmlData = [manager contentsAtPath:documentDirectoryURL];
        
        localTracks = [XMLtoTrackService getTracksFromXML:xmlData];
    }
    
    return localTracks;
}

- (void) updateTracks {
    // Download online xml with tracks data.
    NSData* xmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropbox.com/u/3837140/barcamp%20app/tracks.xml"]];
    
    // Save xml on local.
    NSString* documentDirectoryURL = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tracks.xml"];
    
    NSFileManager* manager = [[NSFileManager alloc] init];
    [manager createFileAtPath:documentDirectoryURL contents:xmlData attributes:nil];
}

- (void) loadTracks {
    // Get Tracks from local
    self.tracks = [self getTracks];
    
    // If no local tracks, we get from online file
    if (!self.tracks || self.tracks.count == 0) {
        [self updateTracks];
        self.tracks = [self getTracks];
    }
    
    // Layout scrollview
    GCPagedScrollView* scrollView = [[GCPagedScrollView alloc] initWithFrame:self.view.frame];
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    scrollView.backgroundColor = [UIColor colorWithRed:0.847 green:0.847 blue:0.847 alpha:1] /*#d8d8d8*/;
    self.view = scrollView;
    [scrollView release];
        
    // Render Tracks pages
    [self renderPages];
}

- (void) reloadTracks {
    // Change reload button with reloading activity indicator
    [self performSelectorInBackground:@selector(reloadingTracksState) withObject:nil];

    // Reload online xml data and replace local with that
    [self updateTracks];
    self.tracks = [self getTracks];
    
    // Render Tracks pages
    [self performSelectorInBackground:@selector(renderPages) withObject:nil];
    
    // Restore reload button
    [self performSelectorInBackground:@selector(reloadedTracksState) withObject:nil];
}

#pragma mark - Update tracks UIBarButtonItem state

- (void) reloadingTracksState {
    // Change reload button with reloading activity indicator
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityIndicator startAnimating];
    UIBarButtonItem* loadingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:nil action:nil];
    loadingButton.customView = activityIndicator;
    loadingButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = loadingButton;
    [activityIndicator release];
    [loadingButton release];
}

- (void) reloadedTracksState {
    // Restore reload button
    UIBarButtonItem* updateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTracks)];
    self.navigationItem.rightBarButtonItem = updateButton;
    [updateButton release];
}

@end
