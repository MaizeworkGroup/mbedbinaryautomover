//
//  DirectoryObserver.m
//  MbedDebuggerForMac
//
//  Created by Heng Lik Wee on 4/25/14.
//  Copyright (c) 2014 Heng Lik Wee. All rights reserved.
//

#import "DirectoryObserver.h"

@interface DirectoryObserver()
- (void)binDownloaded:(NSString *)binPath;
@end

@implementation DirectoryObserver
{
    NSString *_path;
    FSEventStreamRef _stream;
    
}

- (id)initWithDirectoryPath:(NSString *)path
{
    if(self = [super init])
    {
        _path = path;
    }
    return self;
}


- (void)binDownloaded:(NSString *)binPath
{
    if(self.delegate) {
        [self.delegate binDownloaded:binPath];
    }
}


- (void)startObserving
{
    if(_stream) return;
    
    FSEventStreamContext context = {0};
    context.info = (__bridge void *)self;
    CFTimeInterval latency = 0.5;
    _stream = FSEventStreamCreate(kCFAllocatorDefault,
                                  fs_event_callback,
                                  &context,
                                  (__bridge CFArrayRef)@[_path],
                                  kFSEventStreamEventIdSinceNow,
                                  latency,
                                  kFSEventStreamCreateFlagNone);
    
    FSEventStreamScheduleWithRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    FSEventStreamStart(_stream);
    
    NSLog(@"### start observing directory - %@", _path);
}

- (void)stopObserving
{
    if(_stream == NULL) return;
    
    FSEventStreamStop(_stream);
    FSEventStreamUnscheduleFromRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    FSEventStreamRelease(_stream);
    _stream = NULL;
    
    NSLog(@"### stop observing directory - %@", _path);
}



void fs_event_callback(
                       ConstFSEventStreamRef streamRef,
                       void *clientCallBackInfo,
                       size_t numEvents,
                       void *eventPaths,
                       const FSEventStreamEventFlags eventFlags[],
                       const FSEventStreamEventId eventIds[])
{
    
    char **paths = eventPaths;
    
    //    ProjectUploader *_projectUploader = [[ProjectUploader alloc]init];
    //
    //    for (int i = 0 ; i < numEvents ; i++) {
    //        NSString *strPath = [NSString stringWithCString:paths[i] encoding:NSUTF8StringEncoding];
    //        [_projectUploader callUploadAPI:strPath];
    //        [directories addObject:strPath];
    //    }
    
    NSString* path = @"";
    
    for(int i = 0; i < numEvents; i++){
//        printf("Change %llu in %s, flags %u\n", eventIds[i], paths[i], eventFlags[i]);
        
        NSString* folderPath = [NSString stringWithFormat:@"%s",paths[i]];
        
        NSString* temp = getLatestFilePath(folderPath);
        if([temp hasSuffix:@".bin"]){
            path = temp;
        }
    }
    
    DirectoryObserver *observer = (__bridge DirectoryObserver *)clientCallBackInfo;
    [observer binDownloaded:path];
    
    
}


NSString* getLatestFilePath(NSString* folderPath)
{
    NSError* error;
    
    NSArray *desktopFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    
    if(desktopFiles == nil){
        return @"";
    }
    
    NSDate* latestFileDate = nil;
    NSString* latestFilepath = @"";
    
    for (NSString* filename in desktopFiles){
        
        NSString* filePath = [NSString stringWithFormat:@"%@%@",folderPath,filename];
        
        NSDictionary* fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        NSDate *result =[fileAttribs objectForKey:NSFileModificationDate];
        
        if(latestFileDate == nil || [result compare:latestFileDate]==NSOrderedDescending){
            latestFileDate = result;
            latestFilepath = filePath;
        }
    }
    
    return latestFilepath;
}

bool downloadFileIsGenerated(NSString* folderPath){
    NSError* error;
    
    NSArray *desktopFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    
    if(desktopFiles == nil){
        NSLog(@"Error on getting latest file path :%@", [error localizedDescription]);
        return NO;
    }
    
    NSArray *filteredDesktopFiles = [desktopFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.download'"]];

    return [filteredDesktopFiles count] > 0;
}

@end