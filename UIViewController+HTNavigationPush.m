//
//  UIViewController+HTNavigationPush.m
//  HTNavigationController
//
//  Created by Mr.Yang on 13-10-29.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import "UIViewController+HTNavigationPush.h"
#import <objc/runtime.h>
#import "HTNavigationController.h"
#import "HTNavigationController.h"

#define HTNavigationBarWidth  320
#define HTNavigationBarHeight 42

static char htNavigationControllerV1;
static char htNavigationItemV1;
static char htNavigationBarV1;

@implementation UIViewController (HTNavigationPush)

- (HTNavigationController *)navigationController
{
    return objc_getAssociatedObject(self, &htNavigationControllerV1);
}

- (void)setNavigationController:(HTNavigationController *)navigationController
{
    objc_setAssociatedObject(self, &htNavigationControllerV1, navigationController, OBJC_ASSOCIATION_ASSIGN);
}

- (HTNavigationItem *)navigationItem
{
    id obj =objc_getAssociatedObject(self, &htNavigationItemV1);
    if (!obj) {
        obj = [[HTNavigationItem alloc] init];
        self.navigationItem = obj;
    }
    return obj;
}

- (void)setNavigationItem:(HTNavigationItem *)navigationItem
{
    objc_setAssociatedObject(self, &htNavigationItemV1, navigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNavigationBar:(HTNavigationBar *)navigationBar
{
    objc_setAssociatedObject(self, &htNavigationBarV1, navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HTNavigationBar *)navigationBar
{
    HTNavigationBar *obj = objc_getAssociatedObject(self, &htNavigationBarV1);
    if (!obj) {
        obj = [[HTNavigationBar alloc] initWithFrame:CGRectMake(0, 0, HTNavigationBarWidth, HTNavigationBarHeight)];
        self.navigationBar = obj;
    }
    return obj;
}

@end
