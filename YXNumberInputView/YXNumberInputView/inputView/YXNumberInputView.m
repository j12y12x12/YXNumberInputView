//
//  YXNumberInputView.m
//
//  Created by jyx on 2022/8/2.
//

#import "YXNumberInputView.h"

@interface YXNumberInputView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *labelArray;
// 不显示，仅是来存储text和拉起键盘
@property (nonatomic, strong) UITextField *hideTextField;

@end

@implementation YXNumberInputView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapAction {
    [self becomeFirstResponder];
}

- (void)becomeFirstResponder {
    [self.hideTextField becomeFirstResponder];
}

- (void)resignFirstResponder {
    [self.hideTextField resignFirstResponder];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self initSubViews];
}

- (void)clearInputView {
    self.hideTextField.text = @"";
    [self setLabelText:self.hideTextField.text];
    if (self.inputTextDidChangeBlock)  {
        self.inputTextDidChangeBlock(self.hideTextField.text, self.hideTextField.text.length == self.count);
    }
}
- (void)initSubViews {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.labelArray removeAllObjects];
    CGFloat margin = 4;
    CGFloat width = 44;
    CGFloat height = 48;
    CGFloat labelY = (self.frame.size.height - height)/2;
    
    for (int i=0; i<self.count; i++) {
        UILabel *label = [self createInputLabel];
        label.frame = CGRectMake(i*(width + margin), labelY, width, height);
        [self addSubview:label];
        [self.labelArray addObject:label];
    }
    
    [self addSubview:self.hideTextField];

//    self.hideTextField.frame = CGRectMake(0, 0, self.frame.size.width, 30);

}


- (UILabel *)createInputLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:28];
    label.textColor = self.textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = self.borderColor.CGColor;
    label.layer.borderWidth = 1;
    return label;
}

- (UIColor *)textColor {
    if (!_textColor) {
        return [UIColor blackColor];
    }
    return _textColor;
}

- (UIColor *)borderColor {
    
    if (!_borderColor) {
        return [UIColor lightGrayColor];
    }
    return _borderColor;
}

- (UIColor *)borderHighLightColor {
    if (!_borderHighLightColor) {
        return [UIColor blackColor];
    }
    return _borderHighLightColor;
}

- (void)setLabelText:(NSString *)text {
    
    if (self.labelArray.count == 0) {
        return;
    }
    if (text.length > self.labelArray.count) {
        text = [text substringToIndex:self.labelArray.count];
    }
    self.hideTextField.text = text;
    NSInteger textLength = text.length;
    for (int i=0; i<self.labelArray.count; i++) {
        
        UILabel *label = self.labelArray[i];
        if (text.length > i) {
            unichar value = [text characterAtIndex:i];
            NSString *values = [NSString stringWithFormat:@"%C",value];
            label.text = values;
        } else {
            label.text = nil;
        }
        
    }
    [self clearHighLightBorder];

    if (textLength < self.labelArray.count && [self.hideTextField isFirstResponder]) {
        UILabel *label = self.labelArray[textLength];
        label.layer.borderColor = self.borderHighLightColor.CGColor;
    }
}

- (void)clearHighLightBorder {
    for (UILabel *label in self.labelArray) {
        label.layer.borderColor = self.borderColor.CGColor;
    }
}

- (NSString *)text {
    return self.hideTextField.text;
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (UITextField *)hideTextField {
    if (!_hideTextField) {
        _hideTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _hideTextField.textColor = self.textColor;
        _hideTextField.keyboardType = UIKeyboardTypeNumberPad;
        _hideTextField.delegate = self;
        [_hideTextField addTarget:self action:@selector(hideTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];

    }
    return _hideTextField;
}

- (void)hideTextFieldEditingChanged:(UITextField *)textField {
    
    NSString *text = textField.text;
    if (text.length > self.count) {
        text = [textField.text substringToIndex:self.count];
    }
    textField.text = text;
    [self setLabelText:text];
    if (self.inputTextDidChangeBlock)  {
        self.inputTextDidChangeBlock(text, text.length == self.count);
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setLabelText:textField.text];
    
    if (textField.text.length == self.count && self.labelArray.count > 0) {
        // 拉起焦点时如果已输满，聚焦最后一个
        UILabel *lastLabel = [self.labelArray lastObject];
        lastLabel.layer.borderColor = self.borderHighLightColor.CGColor;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self clearHighLightBorder];
}



@end
