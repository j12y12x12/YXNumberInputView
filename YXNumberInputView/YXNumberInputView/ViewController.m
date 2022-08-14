//
//  ViewController.m
//  YXNumberInputView
//
//  Created by jin on 2022/8/14.
//

#import "ViewController.h"
#import "YXNumberInputView.h"

@interface ViewController ()

@property (nonatomic, strong) YXNumberInputView *inputView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSInteger count = 6;
    YXNumberInputView *inputView = [[YXNumberInputView alloc] init];
    self.inputView = inputView;
    inputView.frame = CGRectMake(0, 0, count * 44 + (count-1)*4, 60);
    inputView.center = CGPointMake(self.view.center.x, 200);
    inputView.count = count;
    inputView.textColor = [UIColor redColor];
    inputView.borderColor = [UIColor lightGrayColor];
    inputView.borderHighLightColor = [UIColor redColor];
    [self.view addSubview:inputView];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(50, 300, self.view.frame.size.width - 100, 50);
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clearBtn setTitle:@"不可点击" forState:UIControlStateDisabled];

    clearBtn.backgroundColor = [UIColor orangeColor];
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    clearBtn.enabled = NO;
    
    inputView.inputTextDidChangeBlock = ^(NSString *text, BOOL isComplete) {
        
        clearBtn.enabled = isComplete;
    };
}


- (void)clearBtnClick {
    [self.inputView clearInputView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputView resignFirstResponder];
}


@end
