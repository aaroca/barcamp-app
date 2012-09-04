//
//  Meeting.h
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 03/09/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject

@property(nonatomic, retain) NSString* titulo;
@property(nonatomic, retain) NSString* ponente;
@property(nonatomic, retain) NSString* twitter;
@property(nonatomic, retain) NSString* web;
@property(nonatomic, retain) NSString* sala;
@property(nonatomic, retain) NSString* hora;
@property(nonatomic, retain) NSString* descripcion;

@end
