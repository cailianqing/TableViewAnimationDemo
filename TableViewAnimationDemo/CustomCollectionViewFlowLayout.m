//
//  CustomCollectionViewFlowLayout.m
//  iMessageDemo
//
//  Created by clq on 16/7/6.
//  Copyright © 2016年 conor. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"
#import <math.h>
#define kScrollRefreshThreshold        30.0f
#define kScrollResistanceCoefficient    1 / 2000.0f

@implementation CustomCollectionViewFlowLayout
{
    UIDynamicAnimator *_animator;
    NSMutableSet      *_visibleIndexPaths;
    CGPoint           _lastContentOffset;
    CGFloat           _lastScrollDelta;
    CGPoint           _lastTouchLocation;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _animator          = [[UIDynamicAnimator alloc]initWithCollectionViewLayout:self];
        _visibleIndexPaths = [NSMutableSet set];
    }
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    CGPoint contentOffset = self.collectionView.contentOffset;
    
    if (fabs(contentOffset.y - _lastContentOffset.y) < kScrollRefreshThreshold && _visibleIndexPaths.count > 0){
        return;
    }
    
    _lastContentOffset = contentOffset;

    CGFloat padding                 = 100;
    CGRect currentRect              = CGRectMake(0, contentOffset.y - padding, self.collectionView.frame.size.width, self.collectionView.frame.size.height + 2 * padding);

    NSArray * itemsInCurrentRect    = [super layoutAttributesForElementsInRect:currentRect];
    NSSet * indexPathsInVisibleRect = [NSSet setWithArray:[itemsInCurrentRect valueForKey:@"indexPath"]];
    
    //删除视野外的动画
    [_animator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *behaviour, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes * item = (UICollectionViewLayoutAttributes *)[behaviour.items firstObject];
        BOOL isInVisibleIndexPaths = [indexPathsInVisibleRect member:item.indexPath] != nil;
        if (!isInVisibleIndexPaths){
            [_animator removeBehavior:behaviour];
            [_visibleIndexPaths removeObject:item.indexPath];
        }
    }];
    
    //新出现的动画
    NSArray * newVisibleItems = [itemsInCurrentRect filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        BOOL isInVisibleIndexPaths = [_visibleIndexPaths member:item.indexPath] != nil;
        return !isInVisibleIndexPaths;
    }]];
    
    [newVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL *stop) {
        UIAttachmentBehavior *spring = [[UIAttachmentBehavior alloc] initWithItem:attribute attachedToAnchor:attribute.center];
        spring.length    = 0;
        spring.frequency = 0.8;
        //阻尼
        spring.damping   = 0.6;
        
        // If our touchLocation is not (0,0), we need to adjust our item's center
        if (_lastScrollDelta != 0) {
            [self adjustSpring:spring centerForTouchPosition:_lastTouchLocation scrollDelta:_lastScrollDelta];
        }
        [_animator addBehavior:spring];
        [_visibleIndexPaths addObject:attribute.indexPath];
    }];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [_animator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [_animator layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    UIScrollView *scrollView = self.collectionView;
    _lastScrollDelta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    _lastTouchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [_animator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *spring, NSUInteger idx, BOOL *stop) {
        [self adjustSpring:spring centerForTouchPosition:_lastTouchLocation scrollDelta:_lastScrollDelta];
        [_animator updateItemUsingCurrentState:[spring.items firstObject]];
    }];
    
    return NO;
}
#pragma -私有方法
- (void)adjustSpring:(UIAttachmentBehavior *)spring centerForTouchPosition:(CGPoint)touchLocation scrollDelta:(CGFloat)scrollDelta {
    CGFloat distanceFromTouch              = fabs(touchLocation.y - spring.anchorPoint.y);
    CGFloat scrollResistance               = distanceFromTouch * kScrollResistanceCoefficient;

    UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)[spring.items firstObject];
    CGPoint center = item.center;
    if (_lastScrollDelta < 0) {
        center.y += MAX(_lastScrollDelta, _lastScrollDelta * scrollResistance);
    } else {
        center.y += MIN(_lastScrollDelta, _lastScrollDelta * scrollResistance);
    }
    item.center = center;
}
@end
