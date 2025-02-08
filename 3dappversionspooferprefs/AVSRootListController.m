#include "AVSRootListController.h"
#import <spawn.h>

@implementation AVSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)loadView {
    [super loadView];
	[self headerCell];
}

- (void)headerCell
{
	@autoreleasepool {
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 140)];
	int width = [[UIScreen mainScreen] bounds].size.width;
	CGRect frame = CGRectMake(0, 20, width, 60);
	CGRect botFrame = CGRectMake(0, 55, width, 60);
 
		_label = [[UILabel alloc] initWithFrame:frame];
		[_label setNumberOfLines:1];
		_label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:35];
		[_label setText:@"3DAppVersionSpoofer"];
		[_label setBackgroundColor:[UIColor clearColor]];
		_label.textAlignment = NSTextAlignmentCenter;
		_label.alpha = 1;

		_underLabel = [[UILabel alloc] initWithFrame:botFrame];
		[_underLabel setNumberOfLines:4];
		_underLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
		[_underLabel setText:@"\n伪装任何应用的版本\n\n 作者：0xkuj\n\n 汉化：Ponyln"];
		[_underLabel setBackgroundColor:[UIColor clearColor]];
		_underLabel.textColor = [UIColor grayColor];
		_underLabel.textAlignment = NSTextAlignmentCenter;
		_underLabel.alpha = 1;
		
		[headerView addSubview:_label];
		[headerView addSubview:_underLabel];
		
		[[self table] setTableHeaderView:headerView];		
	}
}

/* read values from preferences */
- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:SPOOF_VER_PLIST_WITH_PATH];
	id obj = [dict objectForKey:[[specifier properties] objectForKey:@"key"]];
	if(!obj)
	{
		obj = [[specifier properties] objectForKey:@"default"];
	}

	return obj;
}

/* set the value immediately when needed */
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:SPOOF_VER_PLIST_WITH_PATH];
	if (!settings) {
		settings = [NSMutableDictionary dictionary];
	}
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:SPOOF_VER_PLIST_WITH_PATH atomically:YES];
	CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}
}

/* 默认 settings 和 repsring right after。 files to be deleted are specified in this function */
-(void)defaultsettings:(PSSpecifier*)specifier {
	UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"继续"
    									                    message:@"这将会把插件恢复为默认值\n你确定要继续吗？" 
    														preferredStyle:UIAlertControllerStyleAlert];
	/* prepare function for "yes" button */
	UIAlertAction* OKAction = [UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault
    		handler:^(UIAlertAction * action) {
				[[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:SPOOF_VER_PLIST_WITH_PATH] error: nil];
    			[self reload];
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
				message:@"设置已重置为默认\n请注销你的设备" 
				preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* 已完成Action =  [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDefault
    			handler:^(UIAlertAction * action) {
					[self respring];
				}];
				[alert addAction:DoneAction];
				[self presentViewController:alert animated:YES completion:nil];
	}];
	/* prepare function for "no" button" */
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style: UIAlertActionStyleCancel handler:^(UIAlertAction * action) { return; }];
	/* actually assign those actions to the buttons */
	[alertController addAction:OKAction];
    [alertController addAction:cancelAction];
	/* present the dialog 和 wait for an answer */
	[self presentViewController:alertController animated:YES completion:nil];
	return;
}

- (void)respring {
	pid_t pid;
	const char* args[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, jbroot("/usr/bin/killall"), NULL, NULL, (char* const*)args, NULL);
}

-(void)openTwitter {
	UIApplication *application = [UIApplication sharedApplication];
	NSURL *URL = [NSURL URLWithString:@"https://www.twitter.com/omrkujman"];
	[application openURL:URL options:@{} completionHandler:^(BOOL success) {return;}];
}

-(void)donationLink {
	UIApplication *application = [UIApplication sharedApplication];
	NSURL *URL = [NSURL URLWithString:@"https://www.paypal.me/0xkuj"];
	[application openURL:URL options:@{} completionHandler:^(BOOL success) {return;}];
}

-(void)openGithub {
	UIApplication *application = [UIApplication sharedApplication];
	NSURL *URL = [NSURL URLWithString:@"https://github.com/0xkuj/3DAppVersionSpoofer"];
	[application openURL:URL options:@{} completionHandler:^(BOOL success) {return;}];
}
@end
