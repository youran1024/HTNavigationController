//
//  MyViewController.m
//  HTNavigationController
//
//  Created by Mr.Yang on 13-10-31.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//


#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    static NSInteger i = 0;
    self.title = [NSString stringWithFormat:@"hello, world %d", i++];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor redColor];
    button1.frame = CGRectMake(0, 0, 30, 30);
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 30, 30);
    button2.backgroundColor = [UIColor greenColor];
    
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    self.navigationItem.rightBarButtonItems = @[bar1, bar2];
    
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)buttonClicked:(UIButton *)button
{
    UIApplication *app = [UIApplication sharedApplication];
    
    if (app.statusBarStyle == UIStatusBarStyleDefault) {
        [app setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    
    MyViewController *mvc = [[MyViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
