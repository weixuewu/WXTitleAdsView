//
//  WXTitleAdsView.h
//  WanHuiJiuZhou
//
//  Created by weixuewu on 2020/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 文字单条上下滚动效果
@interface WXTitleAdsView : UIView

/// 数据源
@property (nonatomic, strong) NSArray *textArray;

/// 文字停留时间，默认3s
@property (nonatomic, assign) NSTimeInterval textStayTime;

/// 动画时间，默认1s
@property (nonatomic, assign) NSTimeInterval animationTime;

/// 外边距，默认15
@property (nonatomic, assign) NSInteger outMargin;

/// 内边距(上下左右), 默认10
@property (nonatomic, assign) NSInteger margin;

/// 是否循环滚动，默认NO
@property (nonatomic, assign) BOOL isRepeat;

/// 内容视图背景色，默认象牙黑0.6透明
@property (nonatomic, strong)   UIColor * contentViewBackGround;

/// 内容视图圆角，默认5.0f
@property (nonatomic, assign)   CGFloat   cornerRadius;

@property (nonatomic, strong)   UIFont  * textFont;
@property (nonatomic, strong)   UIColor * textColor;
@property (nonatomic, assign)   NSTextAlignment textAlignment;

/// 加载view
/// @param array 需要滚动展示的数组（仅限NSString、NSAttributedString两种类型）
/// @param superView 父视图
-(void)showTitleAdWith:(NSArray *)array onView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
