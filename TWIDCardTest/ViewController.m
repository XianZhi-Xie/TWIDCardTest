//
//  ViewController.m
//  TWIDCardTest
//
//  Created by 谢贤智 on 2018/1/5.
//  Copyright © 2018年 攀领网络科技. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic,   strong) UITextField *inputField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputField = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 150, 30)];
    self.inputField.backgroundColor = [UIColor redColor];
    self.inputField.delegate = self;
    [self.view addSubview:self.inputField];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击屏幕的时候就结束编辑，方便又快捷
    [self.view endEditing:YES];//结束编辑
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    BOOL result = [self isValidateIDCardFisrtStep:textField.text];
    NSLog(@"%d", result);
}

- (BOOL)isValidateIDCardFisrtStep:(NSString *)str {
    NSString *idcard = @"^[a-zA-Z][0-9]{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idcard];
    BOOL firstStep = [regextestmobile evaluateWithObject:str];
    if (!firstStep) {
        return firstStep;
    } else {
        return [self isValidateIDCardSecondStep:str];
    }
}

- (BOOL)isValidateIDCardSecondStep:(NSString *)str {
    NSDictionary *firstCodeDict = @{@"A": @10, @"B": @11, @"C": @12, @"D": @13, @"E": @14,
                                    @"F": @15, @"G": @16, @"H": @17, @"J": @18, @"K": @19,
                                    @"L": @20, @"M": @21, @"N": @22, @"P": @23, @"Q": @24,
                                    @"R": @25, @"S": @26, @"T": @27, @"U": @28, @"V": @29,
                                    @"X": @30, @"Y": @31, @"Z": @32, @"W": @33, @"I": @34,
                                    @"O": @35, };
    NSString *first = [[str substringWithRange:NSMakeRange(0, 1)] uppercaseString];
    NSString *mid = [str substringWithRange:NSMakeRange(1, 8)];
    NSString *end = [str substringWithRange:NSMakeRange(9, 1)];
    
    NSInteger firstCodeValue = [[firstCodeDict objectForKey:first] integerValue];
    NSInteger sum = firstCodeValue / 10 + (firstCodeValue % 10) * 9;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    [mid enumerateSubstringsInRange:NSMakeRange(0, mid.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [arr addObject:substring];
    }];
    
    for (NSInteger i = 8; i > 0; i--) {
        NSInteger index = [arr[8 - i] integerValue];
        sum = sum + index * i;
    }
    return (sum % 10 == 0 ? 0 : (10 - sum % 10)) == [end integerValue] ? YES : NO;
}

@end
