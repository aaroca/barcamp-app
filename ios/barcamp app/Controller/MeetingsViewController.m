//
//  MeetingsViewController.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 04/09/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "MeetingsViewController.h"
#import "Meeting.h"

@interface MeetingsViewController ()

@end

@implementation MeetingsViewController

@synthesize meetings = _meetings;
@synthesize meetingsTableView = _meetingsTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inTrack:(NSInteger)trackNumber withMeetings:(NSArray*)meetings
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.meetings = meetings;
        trackNumberTitle = [NSString stringWithFormat:@"Track %d", trackNumber];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMeetingsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_meetingsTableView release];
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    if (self.meetings) {
        rows = self.meetings.count;
    }

    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"] autorelease];
    }
    
    Meeting* meeting = (Meeting*) [self.meetings objectAtIndex:indexPath.row];
    cell.textLabel.text = meeting.titulo;
    cell.detailTextLabel.text = meeting.hora;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return trackNumberTitle;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end