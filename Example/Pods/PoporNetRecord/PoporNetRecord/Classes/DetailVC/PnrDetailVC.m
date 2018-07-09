//
//  PnrDetailVC.m
//  linRunShengPi
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 popor. All rights reserved.

#import "PnrDetailVC.h"
#import "PnrDetailVCPresenter.h"
#import "PnrDetailVCRouter.h"

#import <Masonry/Masonry.h>
#import <PoporFoundation/NSDictionary+tool.h>
#import <PoporUI/IToastKeyboard.h>

@interface PnrDetailVC ()

@property (nonatomic, strong) PnrDetailVCPresenter * present;

@end

@implementation PnrDetailVC
@synthesize infoTV;
@synthesize infoArray;
@synthesize jsonArray;
@synthesize selectRow;
@synthesize menu;

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        if (dic) {
            self.title = dic[@"title"];
            
            self.infoArray = dic[@"infoArray"];
            self.jsonArray = dic[@"jsonArray"];
        }
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.menu) {
        [self.menu setMenuVisible:NO];
        self.menu = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title) {
        self.title = @"PnrDetailVC";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.present) {
        [PnrDetailVCRouter setVCPresent:self];
    }
    
    [self addViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 参考: https://www.jianshu.com/p/c244f5930fdf
    if (self.isViewLoaded && !self.view.window) {
        // self.view = nil;//当再次进入此视图中时能够重新调用viewDidLoad方法
        
    }
}

#pragma mark - VCProtocol
- (UIViewController *)vc {
    return self;
}

- (void)setMyPresent:(id)present {
    self.present = present;
}

#pragma mark - views
- (void)addViews {
    self.infoTV = [self addTVs];
    self.infoTV.separatorInset = UIEdgeInsetsMake(0, 14, 0, 14);
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.infoTV addGestureRecognizer:recognizer];
    
    {
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"复制" style:UIBarButtonItemStylePlain target:self.present action:@selector(copyAction)];
        self.navigationItem.rightBarButtonItems = @[item1];
    }
}

- (UITableView *)addTVs {
    UITableView * oneTV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    oneTV.delegate   = self.present;
    oneTV.dataSource = self.present;
    
    oneTV.allowsMultipleSelectionDuringEditing = YES;
    oneTV.directionalLockEnabled = YES;
    
    oneTV.estimatedRowHeight           = 0;
    oneTV.estimatedSectionHeaderHeight = 0;
    oneTV.estimatedSectionFooterHeight = 0;
    
    [self.view addSubview:oneTV];
    
    __weak typeof (self) weakSelf = self;
    [oneTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    return oneTV;
}

#pragma mark - 复制
// uiscrollview 会把touch事件覆盖掉,但是我不想重新定义UITableView,因为涉及到了很多runtime函数.
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    //两句话是保存触摸起点位置
//    UITouch *touch=[touches anyObject];
//    CGPoint cureentTouchPosition=[touch locationInView:self.infoTV];
//    //得到cell中的IndexPath
//    NSIndexPath *indexPath=[self.infoTV indexPathForRowAtPoint:cureentTouchPosition];
//
//    self.selectRow = (int)indexPath.row;
//
//    [self showUIMenuAtPoint:cureentTouchPosition];
//}

- (void)tapGRAction:(UITapGestureRecognizer *)tapGR {
    CGPoint point = [tapGR locationInView:self.infoTV];
    if (point.y > self.infoTV.contentSize.height) {
        if (self.menu) {
            [self.menu setMenuVisible:NO];
            self.menu = nil;
        }
    }else{
        NSIndexPath *indexPath = [self.infoTV indexPathForRowAtPoint:point];
        self.selectRow = (int)indexPath.row;
        if (self.selectRow >=0 && self.selectRow<self.infoArray.count) {
            [self showUIMenuAtPoint:point];
        }
    }
}

- (void)showUIMenuAtPoint:(CGPoint)point {
    [self.view becomeFirstResponder];
    
    UIMenuItem *copyTextContentMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制Text" action:@selector(copyTextContent:)];
    UIMenuItem *copyJsonContentMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制Json" action:@selector(copyJsonContent:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    if ([self.jsonArray[self.selectRow] isKindOfClass:[NSNull class]]) {
        [menu setMenuItems:@[copyTextContentMenuItem]];
    }else{
        [menu setMenuItems:@[copyTextContentMenuItem, copyJsonContentMenuItem]];
    }
    
    [menu setTargetRect:CGRectMake(point.x - 50, point.y - 30, 100, 40) inView:self.infoTV];
    [menu setMenuVisible:YES animated:YES];
    
    self.menu = menu;
}

- (void)copyTextContent:(UIMenuItem *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.infoArray[self.selectRow]];
}

- (void)copyJsonContent:(UIMenuItem *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSDictionary * dic = self.jsonArray[self.selectRow];
    NSString * jsonString = [dic toJsonString];
    if (jsonString) {
        [pasteboard setString:jsonString];
    }else{
        AlertToastTitle(@"复制失败");
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    BOOL result = NO;
    if(@selector(copyTextContent:) == action
       ||@selector(copyJsonContent:) == action
       ) {
        result = YES;
    }
    return result;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end