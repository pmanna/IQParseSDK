//
//  IQViewController.m
//  IQParseSDK
//
//  Created by Iftekhar on 03/09/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import "IQViewController.h"
#import "IQ_PFObject.h"

@interface IQViewController ()

@end

@implementation IQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IQ_PFObject *object = [[IQ_PFObject alloc] initWithClassName:@"TestClass" dictionary:@{@"TestKey": @"TestObject"}];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

    }];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
