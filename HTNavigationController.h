//
//  HTNavigationController.h
//  HTNavigationController
//
//  Created by Mr.Yang on 13-10-29.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTPushViewController.h"

@class HTPushViewController;
@interface HTNavigationController : UIViewController

@property (nonatomic, strong)   HTPushViewController *topViewController;
@property (nonatomic, strong)   NSMutableArray *viewControllers;
@property (nonatomic, strong)   HTPushViewController *rootViewController;


- (id)initWithRootViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)popToRootViewControllerAnimated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;
- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end

