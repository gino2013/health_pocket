//
//  CMKeyboardManager.m
//  phi-ios
//
//  Created by Kenneth Wu on 2024/9/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CMKeyboardManager.h"

@implementation CMKeyboardManager

// 禁用第三方鍵盤的邏輯
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier {
    // 使用 Objective-C 中對應的鍵盤識別符號字符串
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        return NO; // 禁用第三方鍵盤
    }
    return YES;
}

@end
