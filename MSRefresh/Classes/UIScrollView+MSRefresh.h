//
//  UIScrollView+MSRefresh.h
//  MJRefresh
//
//  Created by Myshao on 2020/4/3.
//




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (MSRefresh)
/**
 下拉刷新
 @param beginRefresh 是否自动刷新
 @param animation 是否需要动画
 @param block 刷新回调
 */
-(void)addHeaderWithBeginRefresh:(BOOL)beginRefresh animation:(BOOL)animation refreshBlock:(void(^)(NSInteger page))block;

/**
 下拉刷新
 @param beginRefresh 是否自动刷新
 @param animation 是否需要动画
 @param block 刷新回调
 */
-(void)addFooterWithBeginRefresh:(BOOL)beginRefresh animation:(BOOL)animation refreshBlock:(void(^)(NSInteger page))block;

/**
 *普通请求结束刷新
 */
-(void)endFooterRefresh;
/**
 *没有数据结束刷新
 */
-(void)endFooterNoMoreData;
@end

NS_ASSUME_NONNULL_END
