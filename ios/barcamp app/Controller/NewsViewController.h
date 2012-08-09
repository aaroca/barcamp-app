//
//  NewsViewController.h
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 07/08/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#define FEED_URL @"http://feeds.feedburner.com/BarcampSpain"

#import <UIKit/UIKit.h>

#import "EGORefreshTableHeaderView.h"
#import "CFeedFetcher.h"

@class CFeedStore;
@class CFeedEntry;
@class CFeed;
@class NewDetailViewController;

@interface NewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,CFeedFetcherDelegate> {
    @private
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

@property (nonatomic, retain) NSMutableArray* rssNews;

@end
