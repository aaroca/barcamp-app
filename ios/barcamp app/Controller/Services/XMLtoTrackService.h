//
//  XMLtoTrackService.h
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 03/09/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLtoTrackService : NSObject

+ (NSArray*) getTracksFromXML:(NSData*)data;

@end
