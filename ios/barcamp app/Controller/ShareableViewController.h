//
//  ShareableViewController.h
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 09/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTShare.h"
#import "MBProgressHUD.h"

@class AppDelegate;

@interface ShareableViewController : UIViewController <FTShareTwitterDelegate, FTShareFacebookDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSString* contentToShare;

@end
