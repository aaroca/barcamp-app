//
//  NSError_Extensions.m
//  TouchCode
//
//  Created by Jonathan Wight on 8/27/07.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY JONATHAN WIGHT ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JONATHAN WIGHT OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of toxicsoftware.com.

#import "NSError_Extensions.h"

@implementation NSError (NSError_Extensions)

+ (id)errorWithDomain:(NSString *)inDomain code:(int)inCode userInfo:(NSDictionary *)inUserInfo localizedDescription:(NSString *)inFormat, ...
{
NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionaryWithDictionary:inUserInfo];

va_list theArgs;
va_start(theArgs, inFormat);
NSString *theLocalizedDescription = [[[NSString alloc] initWithFormat:inFormat arguments:theArgs] autorelease];
va_end(theArgs);
[theUserInfo setObject:theLocalizedDescription forKey:NSLocalizedDescriptionKey];

NSError *theError = [self errorWithDomain:inDomain code:inCode userInfo:theUserInfo];
return(theError);
}

+ (int)errnoForError:(NSError *)inError;
{
NSAssert(inError && [[inError domain] isEqualToString:NSPOSIXErrorDomain] == YES, @"Error domain is not NSPOSIXErrorDomain");
return((int)[inError code]);
}

+ (id)errorWithException:(NSException *)inException
{
NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
	inException, @"NSException",
	NULL];


NSError *theError = [NSError errorWithDomain:@"NSException" code:-1 userInfo:theUserInfo];
return(theError);
}

@end
