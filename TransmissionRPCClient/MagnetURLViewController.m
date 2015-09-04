//
//  MagnetURLViewController.m
//  TransmissionRPCClient
//
//  Created by Alexey Chechetkin on 03.09.15.
//  Copyright (c) 2015 Alexey Chechetkin. All rights reserved.
//

#import "MagnetURLViewController.h"

@interface MagnetURLViewController ()

@end

@implementation MagnetURLViewController

{
    __weak IBOutlet UISwitch *_switchTogglePasskeyView;
    UIBarButtonItem *_btnCopyToBuffer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.textMagnetLink.layer.borderWidth = 1.0f;
    //self.textMagnetLink.layer.borderColor = [UIColor darkGrayColor].CGColor;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _btnCopyToBuffer = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString( @"Copy to buffer", nil )
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(copyToBuffer:)];
    _btnCopyToBuffer.enabled = ( _urlString != nil );
    _switchTogglePasskeyView.enabled = ( _urlString != nil );
    self.toolbarItems = @[spacer, _btnCopyToBuffer, spacer];
}

/// remove passkey from url
- (NSString *)removedPassKey
{
    NSRange rng = [_urlString  rangeOfString:@"passkey"];
    if( rng.location != NSNotFound )
    {
        rng.length = _urlString.length - rng.location;
        NSRange rngEnd = [_urlString rangeOfString:@"&" options:NSCaseInsensitiveSearch range:rng];
        
        if( rngEnd.location != NSNotFound )
        {
            rng.length = rngEnd.location - rng.location;
            NSString *s = [_urlString stringByReplacingCharactersInRange:rng withString:@""];
            //self.textMagnetLink.text = s;
            return s;
            //[self.textMagnetLink select:self.textMagnetLink];
            //self.textMagnetLink.selectedRange = rng;
        }
        else
        {
            NSString *s = [_urlString stringByReplacingCharactersInRange:rng withString:@""];
            //self.textMagnetLink.text = s;
            return s;
            //self.textMagnetLink.selectedRange = rng;
        }
    }
    
    return nil;
}

- (void)copyToBuffer:(id)sender
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.textMagnetLink.text;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.toolbarHidden = NO;
    self.textMagnetLink.text = _urlString;
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
    self.textMagnetLink.text = urlString;
    _btnCopyToBuffer.enabled = YES;
    _switchTogglePasskeyView.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (IBAction)togglePasskeyView:(UISwitch *)sender
{
    if( sender.on )
    {
        self.textMagnetLink.text = _urlString;
    }
    else
    {
        NSString * s = self.removedPassKey;
        if( s )
            self.textMagnetLink.text = s;
        else
            sender.enabled = NO;
    }
}

@end
