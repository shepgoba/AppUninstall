#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <objc/runtime.h>
#include <Foundation/Foundation.h>
 
@interface LSApplicationProxy : NSObject
+(instancetype)applicationProxyForIdentifier:(NSString *)identifier;
@property (getter=isDeletable,nonatomic,readonly) BOOL deletable;
-(NSString *)applicationIdentifier;
-(NSString *)localizedNameForContext:(id)arg1;
@end

@interface LSApplicationWorkspace : NSObject
+(instancetype)defaultWorkspace;
-(BOOL)uninstallApplication:(id)arg1 withOptions:(id)arg2 ;
-(NSArray *)allInstalledApplications;
@end



int main(int argc, char *argv[], char *envp[]) 
{
	if (argc < 2) {
		printf("Usage: AppUninstall <app name OR bundle id>\n");
		return 0;
	}

	LSApplicationWorkspace *workspace = [LSApplicationWorkspace defaultWorkspace];

	NSString *bundleID = nil;
	NSString *appName = nil;
	NSString *arg = [NSString stringWithUTF8String: argv[1]];


	BOOL foundApp = NO;

	for (LSApplicationProxy *app in workspace.allInstalledApplications) {
		if (app.isDeletable) {
			NSString *localizedAppName = [app localizedNameForContext:nil];
			if ([arg isEqual:localizedAppName]|| [arg isEqual:app.applicationIdentifier]) {
				bundleID = app.applicationIdentifier;
				appName = localizedAppName;
				foundApp = YES;
				break;
			}
		}
	}

	if (!foundApp) {
		printf("Application \"%s\" not found\n", argv[1]);
		return 2;
	}


	BOOL success = [workspace uninstallApplication:bundleID withOptions:nil];
	if (success) {
		printf("successfully uninstalled %s\n", appName.UTF8String);
	} else {
		printf("uninstall of %s failed\n", appName.UTF8String);
		return 1;
	}

	return 0;
}
