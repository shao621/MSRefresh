//
//  UIScrollView+MSRefresh.m
//  MJRefresh
//
//  Created by Myshao on 2020/4/3.
//

#import "UIScrollView+MSRefresh.h"
#import <objc/runtime.h>
#import <MJRefresh/MJRefresh.h>
typedef void(^RefreshBlock)(NSInteger page);
typedef void(^LoadMoreBlock)(NSInteger page);
typedef void(^RefreshBlock)(NSInteger page);
typedef void(^LoadMoreBlock)(NSInteger page);
static void *PageKey=&PageKey;
static void *RefreshBlockKey=&RefreshBlockKey;
static void *LoadMoreBlockKey=&LoadMoreBlockKey;


@interface UIScrollView ()
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) RefreshBlock refreshBlock;

@property (nonatomic, copy) LoadMoreBlock loadMoreBlock;

@end

@implementation UIScrollView (MSRefresh)
-(void)addHeaderWithBeginRefresh:(BOOL)beginRefresh animation:(BOOL)animation refreshBlock:(void(^)(NSInteger page))block{
    __weak typeof(self) weakSelf=self;
    self.refreshBlock = block;
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf resetPage];
        if (weakSelf.refreshBlock) {
            weakSelf.refreshBlock(weakSelf.page);
        }
        [weakSelf endHeaderRefresh];
    }];
    if (beginRefresh && animation) {
        [self beginHeaderRefresk];
    }else if (beginRefresh && !animation){
        [self.mj_header executeRefreshingCallback];
    }
    header.mj_h=70;
    self.mj_header=header;
}

-(void)addFooterWithBeginRefresh:(BOOL)beginRefresh animation:(BOOL)animation refreshBlock:(void(^)(NSInteger page))block{
    __weak typeof(self) weakSelf=self;
    self.loadMoreBlock = block;
    if (beginRefresh) {
        MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page+=1;
            if (weakSelf.loadMoreBlock) {
                weakSelf.loadMoreBlock(weakSelf.page);
            }
            [weakSelf endFooterRefresh];
        }];
        footer.automaticallyRefresh=beginRefresh;
        //        footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
        //        footer.stateLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        [footer setTitle:@"加载中…" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"~~这是我的底线啦~~" forState:MJRefreshStateNoMoreData];
         footer.stateLabel.hidden=YES;
        self.mj_footer=footer;
    }else{
        MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page += 1;
            if (weakSelf.loadMoreBlock) {
                weakSelf.loadMoreBlock(weakSelf.page);
            }
            [weakSelf endFooterRefresh];
        }];
        
        footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
        footer.stateLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        [footer setTitle:@"加载中…" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"~~这是我的底线啦~~" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.hidden=YES;
        self.mj_footer = footer;
    }
}



-(void)beginHeaderRefresk{
    [self resetPage];
    [self.mj_header beginRefreshing];
}
-(void)endHeaderRefresh{
    [self.mj_header endRefreshing];
    [self resetNoMoreData];
}
-(void)resetPage{
    self.page=0;
}

-(void)resetNoMoreData{
    [self.mj_footer resetNoMoreData];
}


-(void)endFooterRefresh{
    [self.mj_footer endRefreshing];
}

-(void)endFooterNoMoreData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mj_footer endRefreshingWithNoMoreData];
    });
}

-(NSInteger)page{
    return [objc_getAssociatedObject(self, &PageKey) integerValue];
}
-(void)setPage:(NSInteger)page{
    objc_setAssociatedObject(self, &PageKey, @(page), OBJC_ASSOCIATION_ASSIGN);
}

-(RefreshBlock)refreshBlock{
    return objc_getAssociatedObject(self, &RefreshBlockKey);
}
-(void)setRefreshBlock:(RefreshBlock)refreshBlock{
    objc_setAssociatedObject(self, &RefreshBlockKey, refreshBlock, OBJC_ASSOCIATION_COPY);
}

-(LoadMoreBlock)loadMoreBlock{
    return objc_getAssociatedObject(self, &LoadMoreBlockKey);
}
-(void)setLoadMoreBlock:(LoadMoreBlock)loadMoreBlock{
    objc_setAssociatedObject(self, &LoadMoreBlockKey, loadMoreBlock, OBJC_ASSOCIATION_COPY);
}

@end
