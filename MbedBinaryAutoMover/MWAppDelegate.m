//
//  MWAppDelegate.m
//  MbedBinaryAutoMover
//
//  Created by Edisonthk on 2014/06/14.
//  Copyright (c) 2014年 Maizework. All rights reserved.
//

#import "MWAppDelegate.h"

@interface MWAppDelegate()

@property DirectoryObserver *directoryObserver;
@property (weak) IBOutlet NSView *contentSubview;
@property (weak) IBOutlet NSView *usbSubview;
@property (weak) IBOutlet NSButton *sourceFolderPathButton;
@property (weak) IBOutlet NSButton *destFolderPathButton;
@property (weak) IBOutlet NSButton *noticeWhenMovedCheckbox;

@end

@implementation MWAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString* sourceFolderPath = [MWPreferences stringForKey:MWPrefSourceFolderPath];
    
    
    // フォルダの監視を初期化し、開始する
    NSString* dirPath = sourceFolderPath;
    self.directoryObserver = [[[DirectoryObserver alloc]init] initWithDirectoryPath:dirPath];
    [_directoryObserver startObserving];
    _directoryObserver.delegate = self;
    
    
    // ビューを更新
    [self refreshViewWithPref];
    
    
    // 親ビューにusb用subviewを挿入
    [self.contentSubview addSubview:self.usbSubview];
    
}
- (IBAction)changeFolderPathAction:(id)sender {
    
    NSOpenPanel* dialog = [NSOpenPanel openPanel];
    
    [dialog setCanChooseDirectories:TRUE];
    [dialog setAllowsMultipleSelection:FALSE];
    
    [dialog beginWithCompletionHandler:^(NSInteger result)
     {
         if (result==NSFileHandlingPanelOKButton)
         {
             NSFileManager *fileManager = [[NSFileManager alloc] init];
             
             NSString* filePath = [dialog.URL path];
             
             BOOL isDir;
             BOOL fileExists = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
             if(fileExists){
                 
                 if(!isDir){
                     
                     NSAlert *alert = [NSAlert alertWithMessageText:@"Warning"
                                                      defaultButton:@"OK"
                                                    alternateButton:nil
                                                        otherButton:nil
                                          informativeTextWithFormat:
                                       @"Please choose directory!"];
                     [alert setAlertStyle:NSCriticalAlertStyle];
                     [alert runModal];
                     
                 }else{
                     
                     NSUserDefaults* defaults = [MWPreferences getUserDefaults];
                     [defaults setValue:filePath forKey:MWPrefSourceFolderPath];
                     [defaults synchronize];
                     
                     [self refreshViewWithPref];
                 }
             }
             
         }
         
     }];
    
}
- (IBAction)changeDestFolderPath:(id)sender {
    
    NSOpenPanel* dialog = [NSOpenPanel openPanel];
    
    [dialog setCanChooseDirectories:TRUE];
    [dialog setAllowsMultipleSelection:FALSE];
    
    [dialog beginWithCompletionHandler:^(NSInteger result)
     {
         if (result==NSFileHandlingPanelOKButton)
         {
             NSFileManager *fileManager = [[NSFileManager alloc] init];
             
             NSString* filePath = [dialog.URL path];
             
             BOOL isDir;
             BOOL fileExists = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
             if(fileExists){
                 
                 if(!isDir){
                     
                     NSAlert *alert = [NSAlert alertWithMessageText:@"Warning"
                                                      defaultButton:@"OK"
                                                    alternateButton:nil
                                                        otherButton:nil
                                          informativeTextWithFormat:
                                       @"Please choose directory!"];
                     [alert setAlertStyle:NSCriticalAlertStyle];
                     [alert runModal];
                     
                 }else{
                     
                     NSUserDefaults* defaults = [MWPreferences getUserDefaults];
                     [defaults setValue:filePath forKey:MWPrefSourceFolderPath];
                     [defaults synchronize];
                     
                     [self refreshViewWithPref];
                 }
             }
             
         }
         
     }];
    
}

// ビューを更新
- (void) refreshViewWithPref
{
    
    NSString* sourceFolderPath = [MWPreferences stringForKey:MWPrefSourceFolderPath];
    
    [self.sourceFolderPathButton setTitle:[sourceFolderPath lastPathComponent]];
    
    
    // ============================================= //
    //
    // ターゲットフォルダのパス
    //
    // ============================================= //
    NSString* destFolderPath = [MWPreferences stringForKey:MWPrefDestFolderPath];
    
    [self.destFolderPathButton setTitle:[destFolderPath lastPathComponent]];
    
    
    // ============================================= //
    //
    // バイナリファイルの移動通知
    //
    // ============================================= //
    
    BOOL noticeWhenMoved = [MWPreferences boolForKey:MWPrefNoticeWhenMoved];
    
    [self.noticeWhenMovedCheckbox setState:noticeWhenMoved];
    
}


// 通知を表示
// ただし、アプリケーションがフォーカスされている時は通知しません。
-(void)noticeWithMessage:(NSString* )message
{
    
    NSUserNotificationCenter *nc = [NSUserNotificationCenter defaultUserNotificationCenter];
    nc.delegate = self;
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Debug";
    
    notification.informativeText = message;
    
    [nc deliverNotification:notification];
}


// binPath : ダウンロードしたbinファイルのabsoluteパス
-(void)binDownloaded:(NSString *)binPath
{
    if([binPath length] > 0){
        
        // インスタンスfile変数
        NSString* filename = [binPath lastPathComponent];
        
        
        // ============================================= //
        //
        // USBでつないた前提でダウンロードしたバイナリファイルを
        // 移動する
        //
        // ============================================= //
        
        // from パス
        NSString* from = binPath;
        
        // to パス
        NSString* destFolderPath = [MWPreferences stringForKey:MWPrefDestFolderPath];
        NSString* to = [NSString stringWithFormat:@"%@%@", destFolderPath ,filename];
        
        //
        NSError* err;
        
        [[NSFileManager defaultManager] copyItemAtPath:from toPath:to error:&err];
        
        
        if( [MWPreferences boolForKey:MWPrefNoticeWhenMoved] ){
            
            if(err){
                NSLog(@"Faield to move file due to :%@",err);
                [self noticeWithMessage:[NSString stringWithFormat:@"Failed to moving file %@",filename]];
            }else{
                [self noticeWithMessage:[NSString stringWithFormat:@"Success! Moved %@ to Mbed",filename]];
            }
            
        }
        
        
    }
    
}


@end
