//
//  MeetingsViewController.h
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 04/09/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TracksViewController;

@interface MeetingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) NSString* trackNumbertitle;
@property(nonatomic, retain) NSArray* meetings;
@property(nonatomic, assign) UIViewController* tracksViewController;
@property (retain, nonatomic) IBOutlet UITableView *meetingsTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inTrack:(NSInteger)trackNumber withMeetings:(NSArray*)meetings;

@end
