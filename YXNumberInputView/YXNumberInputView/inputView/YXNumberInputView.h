//
//  YXNumberInputView.h
//
//  Created by jyx on 2022/8/2.
//

#import <UIKit/UIKit.h>

@interface YXNumberInputView : UIView

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *borderHighLightColor;

@property (nonatomic, copy) void (^inputTextDidChangeBlock)(NSString *text,BOOL isComplete);

- (void)becomeFirstResponder;
- (void)resignFirstResponder;

- (void)clearInputView;

@end
