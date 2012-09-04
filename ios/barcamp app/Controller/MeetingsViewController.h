//
//  MeetingsViewController.h
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 04/09/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) NSArray* meetings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMeetings:(NSArray*)meetings;

@end
