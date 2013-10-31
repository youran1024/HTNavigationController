//
//  HTPushViewController.m
//  HTNavigationController
//
//  Created by Mr.Yang on 13-10-30.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import "HTPushViewController.h"
#import <objc/runtime.h>

@interface HTPushViewController ()

@end

@implementation HTPushViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (HTNavigationBar *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[HTNavigationBar alloc] initWithFrame:CGRectMake(0, 0, HTNavigationBarWidth, HTNavigationBarHeight)];
    }
    return _navigationBar;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.frame];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0;
    }
    
    return _maskView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

@implementation HTNavigationBar

- (void)setRightView:(UIView *)rightView
{
    if (_rightView != rightView) {
        [_rightView removeFromSuperview];
        _rightView = rightView;
        [self addSubview:_rightView];
        [self setNeedsDisplay];
    }
}

- (void)setLeftView:(UIView *)leftView
{
    if (_leftView != leftView) {
        [_leftView removeFromSuperview];
        _leftView = leftView;
        [self addSubview:_leftView];
        [self setNeedsDisplay];
    }
}

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [self titleLabel];
        [self addSubview:_titleView];
        [self setNeedsDisplay];
    }
    return _titleView;
}

- (UILabel *)titleLabel
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HTNavigationBarWidth, HTNavigationBarHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:HTNavigationBarTitleSize];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    
    return titleLabel;
}

- (void)setTitleView:(UIView *)titleView
{
    if (_titleView != titleView) {
        [_titleView removeFromSuperview];
        [self addSubview:titleView];
        _titleView = titleView;
        [self setNeedsDisplay];
    }
}

- (void)layoutSubviews
{
    CGRect rect     = self.frame;
    CGFloat height  = CGRectGetHeight(rect);
    CGFloat originY;
    
    if (_leftView) {
        originY = (height - CGRectGetHeight(_leftView.frame)) / 2;
        rect = _leftView.frame;
        rect.origin.x = HTNavigationBarLeftMargin;
        rect.origin.y = originY;
        _leftView.frame = rect;
    }
    
    if (_titleView) {
        
    }
    
    if (_rightView) {
        originY = (height - CGRectGetHeight(_rightView.frame)) / 2;
        rect = _rightView.frame;
        rect.origin.x = HTNavigationBarWidth - HTNavigationBarRightMargin - CGRectGetWidth(rect);
        rect.origin.y = originY;
        _rightView.frame = rect;
    }
    
    
}

- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"banner.png"] drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    float centerX = rect.size.width / 2;
    float centerY = rect.size.height / 2;
    float width = rect.size.width;
    float radius = 7;
    CGContextMoveToPoint(context, 0, centerY);
    CGContextAddArcToPoint(context, 0, 0, centerX, 0, radius);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextMoveToPoint(context, width, centerY);
    CGContextAddArcToPoint(context, width, 0, centerX, 0, radius);
    CGContextAddLineToPoint(context, width, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
}
@end

@implementation HTNavigationItem

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    [self.htNavigationBar setLeftView:leftBarButtonItem.customView];
}

- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    [self.htNavigationBar setLeftView:[self barButtonItemsView:leftBarButtonItems]];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    [self.htNavigationBar setRightView:rightBarButtonItem.customView];
}

- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    [self.htNavigationBar setRightView:[self barButtonItemsView:rightBarButtonItems]];
}

- (UIView *)barButtonItemsView:(NSArray *)barButtonItems
{
    UIView *itemView = [[UIView alloc] init];
    CGFloat margin = 5.0f;
    CGFloat width = .0f;
    CGFloat height = CGRectGetHeight(self.htNavigationBar.frame);
    CGRect rect;
    for (UIBarButtonItem *item in barButtonItems) {
        if ([item isKindOfClass:[UIBarButtonItem class]]) {
            rect = item.customView.frame;
            rect.origin.x += margin + width;
            rect.origin.y = (height - CGRectGetHeight(rect)) / 2.0f;
            item.customView.frame = rect;
            [itemView addSubview:item.customView];
            width += (CGRectGetWidth(rect) + margin);
        }
    }
    itemView.frame = CGRectMake(0, 0, width, height);
    return itemView;
}

@end


static char htNavigationControllerV1;
static char htNavigationItemV1;

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

@end


