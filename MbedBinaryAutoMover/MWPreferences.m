//
//  MWPreferences.m
//  MbedDebuggerForMac
//
//  Created by Edisonthk on 2014/06/01.
//  Copyright (c) 2014年 Maizework. All rights reserved.
//

#import "MWPreferences.h"

@interface MWPreferences()

@property NSUserDefaults* defaults;

@end

@implementation MWPreferences

// UserDefault key for usb interface
NSString* const MWPrefInterfaceType = @"interfaceType";
NSString* const MWPrefSourceFolderPath = @"sourceFolderPath";
NSString* const MWPrefDestFolderPath = @"destFolderPath";
NSString* const MWPrefNoticeWhenMoved = @"noticeWhenMoved";


// UserDefault key for bluetooth interface
NSString* const MWPrefBluetoothNoticeWhenSent = @"noticeWhenSent";


-(id)init
{
    self = [super init];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    if([self.defaults objectForKey:@"initial"] == nil){
        [self configDefaultPreferences];
    }
    
    return self;
}

//　初期のユーザ設定を初期化
// もし、NSUserDefaultsに該当のキーは存在していなければ、該当のメソッドは
// 実行される。
-(void)configDefaultPreferences
{
    
    NSUserDefaults* sd = self.defaults;
    
    [sd setValue:@"initial" forKey:@"initial"];
    
    [sd setValue:@"usb" forKey:MWPrefInterfaceType];
    
    NSString* defaultSourceFolderPath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Downloads"];
    [sd setValue:defaultSourceFolderPath forKey:MWPrefSourceFolderPath];
    
    [sd setValue:@"/Volumes/MBED/" forKey:MWPrefDestFolderPath];
    
    [sd setBool:TRUE forKey:MWPrefNoticeWhenMoved];
    
    [sd setBool:TRUE forKey:MWPrefBluetoothNoticeWhenSent];
    
    [sd synchronize];
}


+(id)objectForKey:(NSString *)keyName
{
    MWPreferences* pref = [[MWPreferences alloc]init];
    
    return [pref.defaults objectForKey:keyName];
}

+(NSString* )stringForKey:(NSString *)keyName
{

    MWPreferences* pref = [[MWPreferences alloc]init];
    
    return [pref.defaults stringForKey:keyName];
}

+(BOOL)boolForKey:(NSString *)keyName
{
    
    MWPreferences* pref = [[MWPreferences alloc]init];
    
    return [pref.defaults boolForKey:keyName];
    
}


+(NSUserDefaults* )getUserDefaults
{
    return [[MWPreferences alloc]init].defaults;
}

@end
