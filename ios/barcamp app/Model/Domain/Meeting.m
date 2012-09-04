//
//  Meeting.m
//  barcamp app
//
//  Created by Álvaro Aroca Munoz on 03/09/12.
//  Copyright (c) 2012 Álvaro Aroca Munoz. All rights reserved.
//

#import "Meeting.h"

@implementation Meeting

@synthesize titulo = _titulo;
@synthesize ponente = _ponente;
@synthesize twitter = _twitter;
@synthesize web = _web;
@synthesize sala = _sala;
@synthesize hora = _hora;
@synthesize descripcion = _descripcion;

- (NSString*) description {
    return [NSString stringWithFormat:@"Meeting:\r\n-Titulo: %@\r\n-Ponente: %@\r\n-Twitter: %@\r\n-Web: %@\r\n-Sala: %@\r\n-Hora: %@\r\n-Descripcion: %@", self.titulo, self.ponente, self.twitter, self.web, self.sala, self.hora, self.descripcion];
}

@end
