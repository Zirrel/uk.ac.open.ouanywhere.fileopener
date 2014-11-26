//
//  CDVFileOpener.m
//  OUAnywhere
//

#import "CDVFileOpener.h"

@interface CDVFileOpener ()

@property (nonatomic, strong) UIDocumentInteractionController *controller;
@property BOOL hasApps;

@end

@implementation CDVFileOpener {
    NSString *localFile;
    CDVPluginResult *pluginResult;
    NSString *callbackID;
}

-(void)test:(CDVInvokedUrlCommand *)command {
    callbackID = command.callbackId;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"FileOpener"];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)openFile:(CDVInvokedUrlCommand *)command {
    NSString *callbackID = command.callbackId;
    
    NSMutableDictionary* options = [command.arguments objectAtIndex:1];
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *components = [[command.arguments objectAtIndex:0] componentsSeparatedByString:@"/"];
    
    // the file name will be uk.ac.open.ouanywhere/<module folder>/cm536356536725.epub (for example)
    
    NSString *fName = [NSString stringWithFormat:@"%@/%@/%@",[components objectAtIndex:components.count-3],[components objectAtIndex:components.count-2], [components objectAtIndex:components.count-1]];
    
    // now append onto full path to users Documents folder
    
    NSString *fNameFullPath = [documentsDirectory stringByAppendingPathComponent:fName];
    
    // check file exists before doing anything with it
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fNameFullPath]) {
      
        // get the lowercase of file extention
        
        NSString *ext = [[fNameFullPath pathExtension] lowercaseString];
    
        // and test for types we want to action
        
        if ([ext isEqualToString:@"pdf"] || [ext isEqualToString:@"epub"] ) {
            
            self.hasApps = NO;
            
            // create a DIC using the file as target
            
            self.controller = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:fNameFullPath]];
            
            // we will intercept events of DIC
            
            self.controller.delegate = self;
            
            // grab a reference to the main view controller in use
            
            CDVViewController *controller = (CDVViewController*)[ super viewController ];
            
            // and display DIC at required location in it
            
            [self.controller presentOpenInMenuFromRect:CGRectMake([[options objectForKey:@"x"] floatValue], [[options objectForKey:@"y"] floatValue], [[options objectForKey:@"w"] floatValue], [[options objectForKey:@"h"] floatValue])
                                                inView:controller.view
                                              animated:YES];
            
            
            if (!self.hasApps) {
                
                [[[UIAlertView alloc] initWithTitle:@"No Reader"
                                           message:@"There is no reader app installed on this device"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        }
    }
}

-(void) documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller {

    self.hasApps = YES;
}

- (void) documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
     // NSLog(@"did dismiss menu");
}

- (void) documentInteractionController: (UIDocumentInteractionController *) controller didEndSendingToApplication: (NSString *) application {
   // NSLog(@"did send to app");
}

@end
