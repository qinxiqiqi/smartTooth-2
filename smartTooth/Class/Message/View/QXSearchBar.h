//
//  QXSearchBar.h
//  WeiboDemo
//
//  Created by NIT on 2017/9/28.
//  Copyright © 2017年 beifanghudong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QXSearchBar;
typedef NS_ENUM(NSUInteger, SearchBarStyle) {
    SearchBarStyleCenter,//放大镜在中间
    SearchBarStyleLeft//放大镜在右边
};
@protocol QXSearchBarDelegate <NSObject>
- (void)searchBar:(QXSearchBar *)searchBar clickedSearchBtn:(UIButton *)sender;
@end

@interface QXSearchBar : UITextField

/**
 *  使用了键盘头部工具条，调整了键盘的高度
 */
@property (nonatomic, assign) BOOL adjustTextFeildH;
/**
 *  占位文字
 */
@property (nonatomic, strong) UILabel *placeHolderLabel;
/**
 *  放大镜图片
 */
@property (nonatomic, weak) UIImageView *searchView;
@property (nonatomic, weak) id <QXSearchBarDelegate>sdelegate;

- (instancetype)initWithStyle:(SearchBarStyle)style frame:(CGRect)frame;
- (void)beginSearch;
- (void)endSearch;
+ (instancetype)searchBar;
@end
