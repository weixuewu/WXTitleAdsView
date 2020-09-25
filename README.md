# WXTitleAdsView
单条文字上下滚动效果（Masonry布局）

使用示例：

NSArray *texts = @[@"1qqq你到家哥德堡辅导班",@"2appppppp几点丹尼尔过需要先执行一次更新约束mmmm么么么么么么",@"3ddddddd"];

WXTitleAdsView *noteView = [[WXTitleAdsView alloc]init];

noteView.isRepeat = YES;

[noteView showTitleAdWith:texts onView:view];//view可为任意一个view
