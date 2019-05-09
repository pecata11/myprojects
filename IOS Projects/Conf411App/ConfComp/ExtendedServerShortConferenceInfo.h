//
//  ExtendedServerShortConferenceInfo.h
//  ConfComp
//
//  Created by Antoan Tateosian on 28.10.11.
//  Copyright (c) 2012 Xentio LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerShortConferenceInfo.h"

@interface ExtendedServerShortConferenceInfo : ServerShortConferenceInfo {
@private
    NSString *confDescription;
    NSURL *smallImageUrl;
    NSURL *bigImageUrl;
    NSURL *mapImageUrl;
    NSURL *confDataUrl;
}

@property (nonatomic, copy) NSString *confDescription;
@property (nonatomic, retain) NSURL *smallImageUrl;
@property (nonatomic, retain) NSURL *bigImageUrl;
@property (nonatomic, retain) NSURL *mapImageUrl;
@property (nonatomic, retain) NSURL *confDataUrl;

@property (nonatomic, readonly) NSArray *linksToDownload;
@property (nonatomic, readonly) NSArray *fileNames;

@end
