//
//  MWAppDelegate.h
//  MbedBinaryAutoMover
//
//  Created by Edisonthk on 2014/06/14.
//  Copyright (c) 2014年 Maizework. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MWPreferences.h"
#import "DirectoryObserver.h"

@interface MWAppDelegate : NSObject <NSApplicationDelegate, BinDownloaded, NSUserNotificationCenterDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
