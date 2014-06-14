//
//  MWPreferences.h
//  MbedDebuggerForMac
//
//  Created by Heng Lik Wee on 2014/06/01.
//  Copyright (c) 2014年 Heng Lik Wee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWPreferences : NSObject

extern NSString* const MWPrefInterfaceType;
extern NSString* const MWPrefSourceFolderPath;
extern NSString* const MWPrefDestFolderPath;
extern NSString* const MWPrefNoticeWhenMoved;
extern NSString* const MWPrefBluetoothNoticeWhenSent;

+(id)objectForKey:(NSString *)keyName;
+(NSString* )stringForKey:(NSString *)keyName;
+(BOOL)boolForKey:(NSString *)keyName;
+(NSUserDefaults* )getUserDefaults;

@end
