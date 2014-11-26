//
//  CDVFileOpener.h
//  OUAnywhere
//

#import <Cordova/CDV.h>

@interface CDVFileOpener : CDVPlugin <UIDocumentInteractionControllerDelegate>

-(void)openFile:(CDVInvokedUrlCommand *)command;
-(void)test:(CDVInvokedUrlCommand *)command;

@end
