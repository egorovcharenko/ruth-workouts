//
//  RWMiscViewController.m
//  Ruth Workouts
//
//  Created by Egor Ovcharenko on 09.06.13.
//  Copyright (c) 2013 Egor Ovcharenko. All rights reserved.
//

#import "RWMiscViewController.h"
#import <MessageUI/MessageUI.h>
#import "Appirater.h"

#import "RWHelper.h"

@interface RWMiscViewController ()

@end

@implementation RWMiscViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.sendButton.backgroundColor = [RWHelper sharedInstance].giantGoldfish;
    self.sendButton.titleLabel.textColor = [UIColor whiteColor];

    self.rateButton.backgroundColor = [RWHelper sharedInstance].giantGoldfish;
    self.rateButton.titleLabel.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rateButtonClicked:(id)sender
{
    [Appirater rateApp];
}

- (IBAction)sendFeedbackButtonClicked:(id)sender
{
    [self openMail:sender];
}

- (IBAction)openMail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Feedback on 'Swim a Mile' app"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"egor.ovcharenko@gmail.com", nil];
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = @"Hi Egor, ";
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
