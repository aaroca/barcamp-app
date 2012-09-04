//
//  TracksViewController.h
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TracksViewController : UIViewController

@property(nonatomic, retain) NSArray* tracks;
@property (retain, nonatomic) IBOutlet UIView *loadingTracksView;

@end
