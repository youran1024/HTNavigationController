//
//  UIViewController+HTNavigationPush.h
//  HTNavigationController
//
//  Created by Mr.Yang on 13-10-29.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTNavigationController.h"

@interface UIViewController (HTNavigationPush)

@property (nonatomic, retain)   HTNavigationController *navigationController;
@property (nonatomic, retain)   HTNavigationItem  *navigationItem;
@property (nonatomic, retain)   HTNavigationBar *navigationBar;

@end
