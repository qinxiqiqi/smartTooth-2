//
//  QXSearchBar.m
//  WeiboDemo
//
//  Created by NIT on 2017/9/28.
//  Copyright © 2017年 beifanghudong. All rights reserved.
//

#import "QXSearchBar.h"
@interface QXSearchBar()
/** 异形按钮 */
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, assign) BOOL willShowKeyboard;

@property (nonatomic, assign) BOOL displayingKeyboard;

@property (nonatomic, assign) SearchBarStyle style;
@property (nonatomic, assign) CGFloat leftViewWidth;
@end
@implementation QXSearchBar


- (instancetype)initWithStyle:(SearchBarStyle)style frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.style = style;
        self.backgroundColor = UIColorHex(0xffffff);
        [self setupNormalView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}
- (void)setAdjustTextFeildH:(BOOL)adjustTextFeildH
{
    if (adjustTextFeildH) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeginShow:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillEndShow:) name:UITextFieldTextDidEndEditingNotification object:nil];
    }
}
- (void)setupNormalView
{
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.returnKeyType = UIReturnKeySearch;
    //设置左边的放大镜
    UIImageView *leftView = [[UIImageView alloc]init];
    self.searchView = leftView;
    leftView.image = [UIImage imageNamed:@"search"];
    leftView.width = leftView.image.size.width;
    leftView.height = self.frame.size.height;
    leftView.contentMode = UIViewContentModeCenter;
    self.leftViewWidth = leftView.image.size.width + 20;
    //        self.leftViewMode = UITextFieldViewModeAlways;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.placeHolderLabel = [[UILabel alloc]init];
    self.placeHolderLabel.text = @"输入关键词";
    self.placeHolderLabel.textColor = UIColorHex(0xc9c9c9);
    self.placeHolderLabel.font = [UIFont systemFontOfSize:12];
    self.font = self.placeHolderLabel.font;
    [self.placeHolderLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self addSubview:self.placeHolderLabel];
    [self layoutIfNeeded];
}
- (void)dealloc{
    [self.placeHolderLabel removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setupSearchView
{
    UIImageView *leftView = [[UIImageView alloc]init];
    leftView.image = [UIImage imageNamed:@"search"];
    leftView.width = self.leftViewWidth;
    leftView.height = self.frame.size.height;
    leftView.contentMode = UIViewContentModeCenter;
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}
+ (instancetype)searchBar
{
    return [[self alloc]init];
}
- (void)beginSearch
{
    if (_style == SearchBarStyleCenter) {
        [self.searchView removeFromSuperview];
        [self.placeHolderLabel removeFromSuperview];
        [self setupSearchView];
    } else if (_style == SearchBarStyleLeft) {
        //[self.placeHolderLabel removeFromSuperview];
    }
}
- (void)endSearch
{
    if (_style == SearchBarStyleCenter) {
        //self.text = @"";
        //[self setupNormalView];
    }
}

- (void)setupFrame
{
    //重写frmae
    CGFloat placeW = [self.placeHolderLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.placeHolderLabel.font} context:nil].size.width;
    CGFloat controlW = placeW + self.searchView.width + 10;//10是中间的间隔
    switch (_style) {
        case SearchBarStyleCenter: {
            [self addSubview:self.searchView];
            self.searchView.x = (self.frame.size.width - controlW)/2;
            self.placeHolderLabel.x = self.searchView.right + 10;
            self.placeHolderLabel.y = 0;
            self.placeHolderLabel.width = placeW;
            self.placeHolderLabel.height = self.frame.size.height;
            break;
        }
        case SearchBarStyleLeft: {
            self.searchView.width = self.leftViewWidth;
            self.leftView = self.searchView;
            self.leftViewMode = UITextFieldViewModeAlways;
            self.placeHolderLabel.x = self.leftViewWidth;
            self.placeHolderLabel.y = 0;
            self.placeHolderLabel.width = placeW;
            self.placeHolderLabel.height = self.frame.size.height;
            
            break;
        }
            
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupFrame];
}

//监听文字的改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [self setupFrame];//重新布局
}

- (void)infoAction
{
    //UITextRange *selectedRange = [self markedTextRange];
    //获取高亮部分
    //UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    //if (!position) {
        
        if (self.text.length > 0) {
            self.placeHolderLabel.hidden = YES;
        } else {
            self.placeHolderLabel.hidden = NO;
        }
    //}
}



#pragma mark - 异形按钮
- (void)keyboardWillBeginShow:(NSNotification *)notification {
    if (self.keyboardType != UIKeyboardTypeNumberPad) return;
    self.willShowKeyboard = notification.object == self;
}


- (void)keyboardWillEndShow:(NSNotification *)notification {
    if (self.keyboardType != UIKeyboardTypeNumberPad) return;
    self.willShowKeyboard = NO;
    NSDictionary *userInfo = [notification userInfo];
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    // 添加动画
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    self.doneButton.transform = CGAffineTransformIdentity;
    [self.doneButton removeFromSuperview];
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.keyboardType != UIKeyboardTypeNumberPad) return;
    if (!self.willShowKeyboard) {
        self.displayingKeyboard = YES;
        return;
    }
    [self.doneButton removeFromSuperview];
    self.doneButton = nil;
    
    NSDictionary *userInfo = [notification userInfo];
    // 动画时间
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 键盘的Frame
    CGRect kbEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbEndFrame.size.height;
    
    // 获取到最上层的window,这句代码很关键
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0) {
        tempWindow = [[[UIApplication sharedApplication] windows] lastObject];
    }
    // 通过图层查看系统的键盘有UIKeyboardAutomatic这个View，第三方的对应位置的view为_UISizeTrackingView
    // 只有iOS 8.0以上需要
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
//        if (![UIView ff_foundViewInView:tempWindow clazzName:@"UIKeyboardAutomatic"]) return;
    }
    
    // 这里因为用了第三方的键盘顶部，所有加了44
    if (self.adjustTextFeildH) {
        kbHeight = kbEndFrame.size.height - 44;
    }
    
    // 动画的轨迹
    NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    // 按钮的位置计算
    CGFloat doneButtonX = 0;
    CGFloat doneButtonW = 0;
    CGFloat doneButtonH = 0;
    // 为了适配不同屏幕
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        doneButtonW = ([UIScreen mainScreen].bounds.size.width - 6) / 3;
        doneButtonH = (kbHeight - 2) / 4;
    } else if ([UIScreen mainScreen].bounds.size.width == 375) {
        doneButtonW = ([UIScreen mainScreen].bounds.size.width - 8) / 3;
        doneButtonH = (kbHeight - 2) / 4;
    } else if ([UIScreen mainScreen].bounds.size.width == 414) {
        doneButtonW = ([UIScreen mainScreen].bounds.size.width - 7) / 3;
        doneButtonH = kbHeight / 4;
    }
    CGFloat doneButtonY = 0;
    if (self.displayingKeyboard) {
        doneButtonY = [UIScreen mainScreen].bounds.size.height - doneButtonH;
    } else {
        doneButtonY = [UIScreen mainScreen].bounds.size.height + kbHeight - doneButtonH;
    }
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(doneButtonX, doneButtonY, doneButtonW, doneButtonH)];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [doneButton setTitle:@"搜索" forState:(UIControlStateNormal)];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[self createImageWithColor:UIColorHex(0xacb8c8)] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (@available(iOS 11.0, *)) {
        doneButton.frame = CGRectMake(doneButtonX + 5, doneButtonY + 5, doneButtonW - 5, doneButtonH - 7);
        doneButton.layer.cornerRadius = 5;
        doneButton.layer.masksToBounds = YES;
        //自己画一条阴影线
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        //设置起始点
        CGPoint startPoint = CGPointMake(0, doneButton.height - 5);
        [linePath moveToPoint:startPoint];
        //画左下角半弧
        [linePath addArcWithCenter:CGPointMake(startPoint.x + 5, startPoint.y) radius:5 startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
        [linePath moveToPoint:CGPointMake(startPoint.x + 5, startPoint.y + 5)];
        //画底部的线
        [linePath addLineToPoint:CGPointMake(doneButton.width - 5, startPoint.y + 5)];
        //画右下角的半圆
        [linePath addArcWithCenter:CGPointMake(doneButton.width - 5, doneButton.height - 5) radius:5 startAngle:M_PI_2 endAngle:M_PI * 2 clockwise:NO];
        //设置线的属性
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = linePath.CGPath;
        shapeLayer.lineWidth = 2.f;
        shapeLayer.strokeColor = UIColorHex(0x858585).CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        //添加到控件上
        [doneButton.layer addSublayer:shapeLayer];
    }
    self.doneButton = doneButton;
    // 添加按钮
    [tempWindow addSubview:doneButton];
    
    if (!self.displayingKeyboard) {
        // 添加动画
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        doneButton.transform = CGAffineTransformTranslate(doneButton.transform, 0, -kbHeight);
        [UIView commitAnimations];
    }
    self.displayingKeyboard = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.keyboardType != UIKeyboardTypeNumberPad) return;
    self.displayingKeyboard = NO;
}

#pragma mark - 私有方法
/**
 *  完成按钮点击
 */
- (void)doneButtonClick:(UIButton *)doneButton{
    if (self.sdelegate && [self.sdelegate respondsToSelector:@selector(searchBar:clickedSearchBtn:)]) {
        [self.sdelegate searchBar:self clickedSearchBtn:doneButton];
    }
}
/**
 *  用颜色返回一张图片
 */
- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
