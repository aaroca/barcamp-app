//
//  CTrivialTemplate.m
//  TouchCode
//
//  Created by Jonathan Wight on 9/19/08.
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

#import "CTrivialTemplate.h"

@implementation CTrivialTemplate

@synthesize template;

- (id)initWithTemplate:(NSString *)inTemplate
{
if ((self = [super init]) != NULL)
	{
	self.template = inTemplate;
	}
return(self);
}

- (id)initWithPath:(NSString *)inPath;
{
//NSString *theTemplate = [NSString stringWithContentsOfFile:inPath];
NSStringEncoding encoding;
NSString *theTemplate = [NSString stringWithContentsOfFile:inPath usedEncoding:&encoding error:NULL];
return([self initWithTemplate:theTemplate]);
}

- (id)initWithTemplateName:(NSString *)inTemplateName
{
NSString *theName = [inTemplateName stringByDeletingPathExtension];
NSString *theExtension = [inTemplateName pathExtension];

NSString *thePath = [[NSBundle mainBundle] pathForResource:theName ofType:theExtension];
return([self initWithPath:thePath]);
}

- (void)dealloc
{
self.template = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSString *)transform:(id)inParameters error:(NSError **)outError
{
return [self transform:inParameters error:outError usedKeys:NULL];
}

- (NSString *)transform:(id)inParameters error:(NSError **)outError usedKeys:(NSArray **)outKeys
{
NSMutableString *theOutputString = [NSMutableString stringWithCapacity:self.template.length];
NSMutableArray *theUsedKeyArray = [NSMutableArray array];
NSAssert(self.template != NULL, @"template is null");
NSScanner *theScanner = [NSScanner scannerWithString:self.template];
[theScanner setCharactersToBeSkipped:NULL];

NSUInteger theLastScanLocation = [theScanner scanLocation];

NSString *theString = NULL;
while ([theScanner isAtEnd] == NO)
	{
	if ([theScanner scanUpToString:@"${" intoString:&theString] == YES)
		{
		[theOutputString appendString:theString];
		}

	if ([theScanner scanString:@"${" intoString:&theString] == YES)
		{
		if ([theScanner scanUpToString:@"}" intoString:&theString] == NO)
			{
			return(NULL);
			}

		NSArray *theComponents = [theString componentsSeparatedByString:@":"];
		NSString *theKeyValuePath = [theComponents objectAtIndex:0];
		NSString *theTransformerName = NULL;
		if (theComponents.count == 2)
			theTransformerName = [theComponents objectAtIndex:1];

		id theValue = [inParameters valueForKeyPath:theKeyValuePath];
		[theUsedKeyArray addObject:theKeyValuePath];

		if (theTransformerName)
			{
			NSValueTransformer *theTransformer = [NSValueTransformer valueTransformerForName:theTransformerName];
			if (theTransformer == NULL)
				{
				[NSException raise:NSGenericException format:@"Cannot find a value transform named: %@", theTransformerName];
				}
			theValue = [theTransformer transformedValue:theValue];
			}

		if (theValue)
			{
			NSString *theReplacementString = [theValue description];
			[theOutputString appendString:theReplacementString];
			}

		if ([theScanner scanString:@"}" intoString:&theString] == NO)
			{
			return(NULL);
			}
		}

	if ([theScanner scanLocation] == theLastScanLocation)
		{
		NSAssert(NO, @"NSScanner infinite loop detected!");
		}

	theLastScanLocation = [theScanner scanLocation];
	}

if (outKeys) *outKeys = [NSArray arrayWithArray:theUsedKeyArray]; 
return(theOutputString);
}

@end

#pragma mark -

@implementation CTrivialTemplate (CTrivialTemplate_Conveniences)

+ (NSString *)transformTemplateNamed:(NSString *)inName replacementDictionary:(NSDictionary *)inDictionary error:(NSError **)outError
{
CTrivialTemplate *theTemplate = [[[self alloc] initWithTemplateName:inName] autorelease];
return([theTemplate transform:inDictionary error:outError]);
}

@end
