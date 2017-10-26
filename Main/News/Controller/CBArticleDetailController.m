//
//  CBArticleDetailController.m
//  mustard
//
//  Created by chinabyte on 2017/8/16.
//  Copyright © 2017年 chinabyte. All rights reserved.
//

#import "CBArticleDetailController.h"

@interface CBArticleDetailController ()<UIWebViewDelegate>
@property (nonatomic , strong) UIWebView *webView;
@property (nonatomic, strong)CBHelperUI * helper;
@end

@implementation CBArticleDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helper = [[CBHelperUI alloc]init];
    UIView * navVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navVIew.backgroundColor = MainThemeColor;
    [self.view addSubview:navVIew];
    [self.helper addImageViewWithFrame:CGRectMake(10, 29, 26, 26) withImageName:@"nav_back" target:self Event:@selector(backClick) inView:navVIew];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    //设置相关属性
    for (UIView *_aView in [self.webView subviews]){
        if ([_aView isKindOfClass:[UIScrollView class]]){
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            [(UIScrollView *)_aView setAlwaysBounceHorizontal:NO];//禁止左右滑动
            //下侧的滚动条
            for (UIView *_inScrollview in _aView.subviews){
                if ([_inScrollview isKindOfClass:[UIImageView class]]){
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    [self setupData];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupData{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"detail.css" withExtension:nil]];
    [html appendString:@"<script src=\"http://code.jquery.com/jquery-2.1.1.min.js\">"];
    [html appendString:@"</script>"];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    [html appendString:[self touchBody]];
    [html appendString:@"<script>$('img').attr({width:'',height: ''}).css({width: '100%'})</script>"];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    [self.webView loadHTMLString:html baseURL:nil];
}
- (NSString *)touchBody{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.model.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.model.create_time];
    if (self.model.content != nil) {
        [body appendString:self.model.content];
    }
    return body;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载完成");
}
@end
