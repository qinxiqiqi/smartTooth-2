//
//  QXTitleImageBtn.m
//  NaHao
//
//  Created by NIT on 2017/10/19.
//  Copyright © 2017年 beifanghudong. All rights reserved.
//

#import "QXTitleImageBtn.h"
@interface QXTitleImageBtn()
{
    CGFloat _imageX,_imageY,_imageW,_imageH,
    _titleX,_titleY,_titleW,_titleH,
    _leftMargin,_centerMargin,_rightMargin;
}
@property (nonatomic, assign)TitleImageBtnStyle currentStyle;
@property (nonatomic, assign) BOOL isAutoWidth;
@end
@implementation QXTitleImageBtn
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title titleFont:(UIFont*)titleFont titleColor:(UIColor*)titleColor imageName:(NSString *)imageName style:(TitleImageBtnStyle)style leftMargin:(CGFloat)leftMargin centerMargin:(CGFloat)centerMargin rightMargin:(CGFloat)rightMargin frame:(CGRect)frame isAutoWidth:(BOOL)isAutoWidth
{
    self = [super init];
    if (self) {
        _leftMargin = leftMargin;
        _centerMargin = centerMargin;
        _rightMargin = rightMargin;
        _currentStyle = style;
        self.isAutoWidth = isAutoWidth;
        self.customTitleLabel = [[UILabel alloc]init];
        self.customImageView = [[UIImageView alloc]init];
        [self addSubview:self.customTitleLabel];
        [self addSubview:self.customImageView];
        self.customTitleLabel.text = title;
        self.customTitleLabel.font = titleFont;
        self.customTitleLabel.textColor = titleColor;
        [self.customTitleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        UIImage *image = [UIImage imageNamed:imageName];
        self.customImageView.image = image;
        self.customTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.customImageView.contentMode = UIViewContentModeCenter;
        [self setFrameWithTitle:title titleFont:titleFont style:style frame:frame];
    }
    return self;
}
- (void)dealloc
{
    [self.customTitleLabel removeObserver:self forKeyPath:@"text"];
}
- (void)setFrameWithTitle:(NSString *)title titleFont:(UIFont*)titleFont style:(TitleImageBtnStyle)style frame:(CGRect)frame
{
    CGSize titleSize;
    if (title.length > 0 && titleFont) {
       titleSize  = ([title boundingRectWithSize:(CGSize){ScreenWidth,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleFont} context:nil]).size;
    } else {
        titleSize = CGSizeMake(0, 0);
    }
    //计算frame
    switch (style) {
        case TitleImageBtnStyleLeftImage: {
            _imageX = _leftMargin;
            _imageY = 0;
            _imageW = self.customImageView.image.size.width;
            _imageH = frame.size.height;
            _titleX = _imageX + _imageW + _centerMargin;
            _titleY = 0;
            _titleW = titleSize.width;
            _titleH = frame.size.height;
            break;
        }
        case TitleImageBtnStyleTopImage: {
            _imageX = 0;
            _imageY = _leftMargin;
            _imageW = frame.size.width;
            _imageH = self.customImageView.image.size.height;
            _titleX = 0;
            _titleY = _imageY + _imageH + _centerMargin;
            _titleW = frame.size.width;
            _titleH = titleSize.height;
            break;
        }
        case TitleImageBtnStyleRightImage: {
            _titleX = _leftMargin;
            _titleY = 0;
            _titleW = titleSize.width;
            _titleH = frame.size.height;
            _imageX = _titleX + _titleW + _centerMargin;
            _imageY = 0;
            _imageW = self.customImageView.image.size.width;
            _imageH = frame.size.height;
            
            break;
        }
        case TitleImageBtnStyleBottomImage: {
            _titleX = 0;
            _titleY = _leftMargin;
            _titleW = frame.size.width;
            _titleH = titleSize.height;
            _imageX = 0;
            _imageY = _titleX + _titleH + _centerMargin;
            _imageW = frame.size.width;
            _imageH = self.customImageView.image.size.width;
            
            break;
        }
        case TitleImageBtnStyleSingleImage: {
            _titleX = 0;
            _titleY = 0;
            _titleW = 0;
            _titleH = 0;
            _imageX = _leftMargin;
            _imageY = 0;
            _imageW = self.customImageView.image.size.width;
            _imageH = frame.size.height;
            
            break;
        }
        case TitleImageBtnStyleSingleTitle: {
            _titleX = _leftMargin;
            _titleY = 0;
            _titleW = titleSize.width;
            _titleH = frame.size.height;
            _imageX = 0;
            _imageY = 0;
            _imageW = 0;
            _imageH = 0;
            
            break;
        }
    }
    self.customTitleLabel.frame = CGRectMake(_titleX, _titleY, _titleW, _titleH);
    self.customImageView.frame = CGRectMake(_imageX, _imageY, _imageW, _imageH);
    CGFloat width;//控件的宽
    if (self.isAutoWidth) {
        width = _leftMargin + _imageW + _centerMargin + _titleW + _rightMargin;
    } else {
        width = frame.size.width;
    }
//    CGFloat x = frame.origin.x + (frame.size.width - width)/2;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
}

//监听文字的改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    UILabel *titleLabel = object;
    CGSize titleSize = ([titleLabel.text boundingRectWithSize:(CGSize){ScreenWidth,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLabel.font} context:nil]).size;
    _titleW = titleSize.width;
    [self setFrameWithTitle:titleLabel.text titleFont:titleLabel.font style:self.currentStyle frame:self.frame];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
