//
//  DirectoryObserver.h
//  MbedDebuggerForMac
//
//  Created by Edisonthk on 4/25/14.
//  Copyright (c) 2014 Maizework. All rights reserved.
//


#import <CoreServices/CoreServices.h>

#import <Foundation/Foundation.h>


@protocol BinDownloaded <NSObject>
- (void)binDownloaded:(NSString*) binPath;
@end

@interface DirectoryObserver : NSObject
- (id)initWithDirectoryPath:(NSString *)path;

- (void)startObserving;
- (void)stopObserving;


@property (weak, nonatomic) id<BinDownloaded> delegate;
@end