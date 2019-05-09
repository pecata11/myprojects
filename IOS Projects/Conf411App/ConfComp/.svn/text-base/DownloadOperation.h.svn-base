//
//  DownloadOperation.h
//  ConfComp
//
//  Created by Anto  XX on 10/18/11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadOperationDelegate;

//Main clss for a download conference operation.

@interface DownloadOperation : NSOperation {
@private
    id<DownloadOperationDelegate> delegate;
    NSURL *url;
    
    NSURLConnection *conn;
    NSMutableData *data;
    BOOL finishedLoading, startedLoading;
    
    NSString *tag;
}

- (id) initWithUrl:(NSURL *)url;

@property (nonatomic, assign) id<DownloadOperationDelegate> delegate;
@property (nonatomic, copy) NSString *tag;

@property (nonatomic, readonly) NSData *downloadedData;

@end

@protocol DownloadOperationDelegate <NSObject>

@optional
- (void) downloadOperationFinished:(DownloadOperation *)downloadOperation;
- (void) downloadOperationFailed:(DownloadOperation *)downloadOperation;

@end