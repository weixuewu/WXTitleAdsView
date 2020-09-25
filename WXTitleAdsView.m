//
//  WXTitleAdsView.m
//  WanHuiJiuZhou
//
//  Created by weixuewu on 2020/9/23.
//

#import "WXTitleAdsView.h"
#import <Masonry/Masonry.h>

@interface WXTitleAdsView ()

@property (nonatomic, strong) UIView *currentView;          //当前view
@property (nonatomic, strong) UIView *stayView;             //等待view
@property (nonatomic, strong) UILabel *currentTextLabel;    //当前label
@property (nonatomic, strong) UILabel *stayTextLabel;       //等待label
@property (nonatomic, assign) NSInteger index;

@end

@implementation WXTitleAdsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = [UIColor clearColor];
    
    //视图之外的不显示
    self.clipsToBounds = YES;
    
    self.index = 0;
    self.textStayTime = 3.0;
    self.animationTime = 1.0;
    self.outMargin = 15;
    self.margin = 10;
    self.textArray = @[];
    
    self.contentViewBackGround = [UIColor colorWithRed:41.0/255 green:36.0/255 blue:33.0/255 alpha:0.6];
    self.cornerRadius = 5.0f;
    
    self.textFont = [UIFont systemFontOfSize:12.0];
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentLeft;
}

-(void)showTitleAdWith:(NSArray *)array onView:(UIView *)superView{
    
    //空数组，消除当前视图并返回
    if (array.count == 0) {
        [self removeFromSuperview];
        return;
    }
    
    //设置self布局
    [superView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(superView).offset(self.outMargin);
        //添加宽高默认值且设置priorityLow级别，子视图变化时，父视图不会胡乱变化
        make.width.mas_equalTo(superView.frame.size.width/2.0).priorityLow();
        make.height.mas_equalTo(45).priorityLow();
        make.right.lessThanOrEqualTo(superView).offset(-self.outMargin).priorityHigh();
    }];
    
    //设置数组
    self.textArray = array;
    
    //创建当前view与label
    self.currentView = [UIView new];
    self.currentView.backgroundColor = self.contentViewBackGround;
    self.currentView.layer.cornerRadius = self.cornerRadius;
    [self addSubview:self.currentView];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(self.margin);
        make.right.bottom.lessThanOrEqualTo(self).offset(-self.margin);
    }];

    self.currentTextLabel = [[UILabel alloc]init];
    self.currentTextLabel.font = self.textFont;
    self.currentTextLabel.textColor = self.textColor;
    self.currentTextLabel.textAlignment = self.textAlignment;
    [self.currentView addSubview:self.currentTextLabel];
    [self.currentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.currentView).offset(self.margin);
        make.right.bottom.equalTo(self.currentView).offset(-self.margin);
    }];
    
    //当前页面
    id text = self.textArray[self.index];
    if ([text isKindOfClass:[NSAttributedString class]]) {
        self.currentTextLabel.attributedText = text;
    }else if ([text isKindOfClass:[NSString class]]) {
        self.currentTextLabel.text = text;
    }
    
    //若数据大于一条，则创建等待view与label
    if (array.count > 1) {
        
        self.stayView = [UIView new];
        self.stayView.backgroundColor = self.contentViewBackGround;
        self.stayView.layer.cornerRadius = self.cornerRadius;
        [self addSubview:self.stayView];
        [self.stayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(self.margin);
            make.left.equalTo(self).offset(self.margin);
            make.right.lessThanOrEqualTo(self).offset(-self.margin);
        }];

        self.stayTextLabel = [[UILabel alloc]init];
        self.stayTextLabel.font = self.textFont;
        self.stayTextLabel.textColor = self.textColor;
        self.stayTextLabel.textAlignment = self.textAlignment;
        [self.stayView addSubview:self.stayTextLabel];
        [self.stayTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.stayView).offset(self.margin);
            make.right.bottom.equalTo(self.stayView).offset(-self.margin);
        }];
    }
    
    [self scrollTextLabel:array];
    
}


-(void)scrollTextLabel:(NSArray *)array{
    //非当前页面，延迟尝试
    if (![self isCurrentViewControllerVisible:[self viewController]]) {
        
        [self performSelector:@selector(scrollTextLabel:) withObject:array afterDelay:3.0];
        
    }else{
        
        //当前页面
        
        id text = self.textArray[self.index];
        if ([text isKindOfClass:[NSAttributedString class]]) {
            self.currentTextLabel.attributedText = text;
        }else if ([text isKindOfClass:[NSString class]]) {
            self.currentTextLabel.text = text;
        }
        
        id nextText = self.textArray[[self nextIndex:self.index]];
        if ([nextText isKindOfClass:[NSAttributedString class]]) {
            self.stayTextLabel.attributedText = nextText;
        }else if ([nextText isKindOfClass:[NSString class]]) {
            self.stayTextLabel.text = nextText;
        }
        
        [self.stayView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(self.margin);
            make.left.equalTo(self).offset(self.margin);
            make.right.lessThanOrEqualTo(self).offset(-self.margin);
        }];
        
        // 注意需要先执行一次更新约束,避免self视图布局不到位
        [self layoutIfNeeded];
        // 告诉self约束需要更新
        [self setNeedsUpdateConstraints];
        // 调用此方法告诉self检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
        [self updateConstraintsIfNeeded];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:self.animationTime delay:self.textStayTime options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            [self.currentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(self.margin);
                make.right.lessThanOrEqualTo(self).offset(-self.margin);
                make.bottom.equalTo(self.mas_top).offset(-self.margin);
            }];

            [self.stayView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self).offset(self.margin);
                make.right.lessThanOrEqualTo(self).offset(-self.margin);
                make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-self.margin);
            }];

            [self layoutIfNeeded];

        } completion:^(BOOL finished) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.index = [self nextIndex:strongSelf.index];
                        
            UIView * temp = strongSelf.currentView;
            strongSelf.currentView = strongSelf.stayView;
            strongSelf.stayView = temp;
            
            UILabel *tempLabel = strongSelf.currentTextLabel;
            strongSelf.currentTextLabel = strongSelf.stayTextLabel;
            strongSelf.stayTextLabel = tempLabel;
            
            if (strongSelf.isRepeat == YES) {
                [self performSelector:@selector(scrollTextLabel:) withObject:array];
            }else{
                //展示完后，停留一会儿自动删除self
                if (strongSelf.index == 0) {
                    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:strongSelf.textStayTime];
                }else{
                    [self performSelector:@selector(scrollTextLabel:) withObject:array];
                }
            }
        }];
    }
}

-(NSInteger)nextIndex:(NSInteger)index{
    NSInteger nextIndex = index + 1;
    if (nextIndex >= self.textArray.count) {
        nextIndex = 0;
    }
    return nextIndex;
}


#pragma mark - State Check
-(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController{
    return (viewController.isViewLoaded && viewController.view.window && [UIApplication sharedApplication].applicationState == UIApplicationStateActive);
}

- (UIViewController *)viewController {
    
    for (UIView * next = [self superview]; next; next = next.superview) {
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
