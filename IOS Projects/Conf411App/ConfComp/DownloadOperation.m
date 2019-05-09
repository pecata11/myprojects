//
//  DownloadOperation.m
//  ConfComp
//
//  Created by Anto  XX on 10/18/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import "DownloadOperation.h"

@interface DownloadOperation ()

@property (nonatomic, retain) NSURLConnection *conn;
@property (nonatomic, retain) NSMutableData *data;

- (void) didFail;
- (void) didSucceed;

@end

@implementation DownloadOperation

@synthesize delegate;
@synthesize conn;
@synthesize data;
@synthesize tag;

- (id) initWithUrl:(NSURL *)inUrl
{
    if ((self = [super init]))
    {
        NSAssert(inUrl != nil, @"in url is nil, damn it!");
        
        url = [inUrl retain];
        
        finishedLoading = NO;
        startedLoading = NO;
    }
    
    return self;
}

- (void) main
{
    BOOL shouldDestr = NO;
    NSAutoreleasePool *pool = nil;
    @try
    {
        pool = [[NSAutoreleasePool alloc] init];
        shouldDestr = YES;
        
        do
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
            if (!startedLoading)
            {
                startedLoading = YES;
                
                NSMutableData *theData = [[NSMutableData alloc] init];
                self.data = theData;
                [theData release];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLConnection *c = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                self.conn = c;
                [c release];
                
                if (!c)
                {
                    [self didFail];
                }
            }
        } while (![self isCancelled] && !finishedLoading);
    }
    @finally
    {
        if (shouldDestr)
        {
            [pool release];
        }
    }
}

- (NSData *) downloadedData
{
    return data;
}

- (void) didFail
{
    finishedLoading = YES;
    
    if ([delegate respondsToSelector:@selector(downloadOperationFailed:)])
    {
        [(id)delegate performSelectorOnMainThread:@selector(downloadOperationFailed:) withObject:self waitUntilDone:NO];
    }
}

- (void) didSucceed
{
    finishedLoading = YES;
    
    if ([delegate respondsToSelector:@selector(downloadOperationFinished:)])
    {
        [(id)delegate performSelectorOnMainThread:@selector(downloadOperationFinished:) withObject:self waitUntilDone:NO];
    }
}

- (void) dealloc
{
    [url release];
    
    self.conn = nil;
    self.data = nil;
    self.tag = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([self isCancelled])
    {
        self->delegate = nil;
        return;
    }
    
    [self.data setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)inData
{
    if ([self isCancelled])
    {
        self->delegate = nil;
        return;
    }
    
    [self.data appendData:inData];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.conn = nil;
    self.data = nil;

    if ([self isCancelled])
    {
        self->delegate = nil;
        return;
    }
    
    [self didFail];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self isCancelled])
    {
        self->delegate = nil;
        return;
    }
    
    [self didSucceed];
}

@end
